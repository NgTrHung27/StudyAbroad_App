// ignore_for_file: use_build_context_synchronously
import 'package:easy_localization/easy_localization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/bloc/gemini_chat/gemini_chat_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/bloc/gemini_chat/gemini_chat_event.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/bloc/gemini_chat/gemini_chat_state.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';

class GeminiAIFlash extends StatefulWidget {
  const GeminiAIFlash({super.key});

  @override
  State<GeminiAIFlash> createState() => _GeminiAIState();
}

class _GeminiAIState extends State<GeminiAIFlash> {
  bool _hasSentFirstMessage = false;
  String subtitle = "Good";
  bool isInputDisabled = false;

  String userName = "User";
  String avtUser =
      "https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg";
  late ChatUser currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(id: "0", firstName: userName, profileImage: avtUser);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkNetworkConnection();
    Theme.of(context);
  }

  void checkNetworkConnection() async {
    var connectivityResults = await (Connectivity().checkConnectivity());
    if (connectivityResults.contains(ConnectivityResult.none)) {
      setState(() {
        subtitle = 'No internet connection. Please check your network.';
        isInputDisabled = true;
      });
    } else {
      setState(() {
        subtitle = 'Good';
        isInputDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAuth =
        context.watch<UserAuthProvider>().userAuthLogin;
    String newUserName = userAuth?.name ?? 'N/A';
    String newAvtUser = userAuth?.student?.school.logo ??
        'https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg';

    if (newUserName != userName) {
      setState(() {
        userName = newUserName;
        currentUser =
            ChatUser(id: "0", firstName: userName, profileImage: newAvtUser);
      });
    }

    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final redCorlor = AppColor.redButton;
    final textColorWhite = isDarkMode ? Colors.white : Colors.black;
    final containerUserBox = isDarkMode ? AppColor.greyChatBox : Colors.white;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.redButton,
          title: TextMonserats(
            '${aiChattingTitleKey.tr()} - 2.0',
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 26,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
            onPressed: () {
              context.read<GeminiChatBloc>().add(ClearGeminiChat());
              Navigator.pushNamed(context, '/mainpage');
            },
          )),
      body: BlocConsumer<GeminiChatBloc, GeminiChatState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
          }
        },
        builder: (context, state) {
          return _buildUI(
              redCorlor,
              subtitle,
              aiChattingInputKey.tr(),
              containerUserBox,
              textColorWhite,
              'No internet connection',
              state.messages,
              state.isLoading);
        },
      ),
    );
  }

  Widget _buildUI(
      Color redCorlor,
      String subtitle,
      String hintText,
      Color containerUserBox,
      Color textColorWhite,
      String errorConn,
      List<ChatMessage> messages,
      bool isLoading) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(children: [
        DashChat(
          inputOptions: InputOptions(
            alwaysShowSend: true,
            sendButtonBuilder: (send) {
              return IconButton(
                icon: ImageIcon(const AssetImage(ImageAssets.iconSend),
                    color: redCorlor),
                onPressed: send,
              );
            },
            trailing: [
              IconButton(
                onPressed: _sendMediaMessage,
                icon: Icon(Icons.image, color: redCorlor, size: 30),
              )
            ],
            inputTextStyle: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            inputDisabled: isInputDisabled,
            inputDecoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: hintText,
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderGrey),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                contentPadding: const EdgeInsets.all(10)),
            cursorStyle: CursorStyle(
              color: redCorlor,
            ),
          ),
          typingUsers: isLoading ? [context.read<GeminiChatBloc>().geminiUser] : null,
          currentUser: currentUser,
          onSend: (message) {
            setState(() {
              _hasSentFirstMessage = true;
            });
            context
                .read<GeminiChatBloc>()
                .add(SendGeminiMessage(message, modelName: 'gemini-2.5-flash'));
          },
          messages: messages,
          messageListOptions: MessageListOptions(
            showDateSeparator: true,
            dateSeparatorFormat: DateFormat('dd/MM/yyyy'),
          ),
          messageOptions: MessageOptions(
            currentUserTextColor: Colors.black,
            containerColor: Colors.white,
            currentUserContainerColor: containerUserBox,
            showCurrentUserAvatar: true,
            showOtherUsersAvatar: true,
            showTime: true,
            showOtherUsersName: true,
          ),
        ),
        if (!_hasSentFirstMessage && messages.isEmpty)
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                isInputDisabled ? errorConn : subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
      ]),
    );
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: aiChattingDesPicKey.tr(),
        medias: [
          ChatMedia(
            url: file.path,
            type: MediaType.image,
            fileName: '',
          ),
        ],
      );

      setState(() {
        _hasSentFirstMessage = true;
      });
      context
          .read<GeminiChatBloc>()
          .add(SendGeminiMessage(chatMessage, modelName: 'gemini-2.5-flash'));
    }
  }
}
