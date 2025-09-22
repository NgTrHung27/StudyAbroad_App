import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';

class GeminiAIFlash extends BasePage {
  const GeminiAIFlash({super.key});

  @override
  State<GeminiAIFlash> createState() => _GeminiAIState();
}

class _GeminiAIState extends BasePageState<GeminiAIFlash> {
  bool _hasSentFirstMessage = false;

  String subtitle = "Good";
  bool isInputDisabled = false;

  String? apiKey;
  Gemini? gemini;
  List<ChatMessage> messages = [];
  String userName = "User"; // Giá trị mặc định, sẽ được cập nhật trong build
  String avtUser =
      "https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg";
  late ChatUser currentUser;
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(
        id: "0",
        firstName: userName, // Sử dụng giá trị mặc định hoặc tạm thời
        profileImage: avtUser);
    _loadApiKey().then((_) {
      setState(() {
        gemini = Gemini.init(apiKey: apiKey!);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkNetworkConnection();
    Theme.of(context);
    AppLocalizations.of(context);
  }

  Future<void> _loadApiKey() async {
    final jsonString = await rootBundle.loadString('env.json');
    final jsonResponse = jsonDecode(jsonString);
    apiKey = jsonResponse['api_key']; // Fixed to correctly update the class-level variable
  }

  void checkNetworkConnection() async {
    final localizations = AppLocalizations.of(context);
    final errorConn = localizations != null ? localizations.error_connection : "Default Text";
    String errorsubtitle = errorConn;
    var connectivityResult = await (Connectivity().checkConnectivity());
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        subtitle = errorsubtitle;
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
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    // Cập nhật userName từ userAuth
    String newUserName = userAuth?.name ?? 'N/A';
    String newAvtUser = userAuth?.student.school.logo ??
        'https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg';
    // Kiểm tra và cập nhật currentUser nếu userName thay đổi
    if (newUserName != userName) {
      setState(() {
        userName = newUserName;
        // Cập nhật currentUser với userName mới
        currentUser = ChatUser(id: "0", firstName: userName, profileImage: newAvtUser);
      });
    }
    //Language
    final localizations = AppLocalizations.of(context);
    final title = localizations != null ? localizations.ai_chatting_title : 'Default Text';
    final subtitle = localizations != null ? localizations.ai_chatting_subtitle : 'Default Text';
    final hintText = localizations != null ? localizations.ai_chatting_input : 'Default Text';
    final errorConn = localizations != null ? localizations.error_connection : "Default Text";
    //Theme
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final redCorlor = AppColor.redButton;
    final textColorWhite = isDarkMode ? Colors.white : Colors.black;
    final containerUserBox = isDarkMode ? const Color(0xffD9D9D9) : Colors.white;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColor.redButton,
          title: TextMonserats(
            '$title -1.5-flash',
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
            onPressed: () => Navigator.pushNamed(context, '/mainpage'),
          )),
      body: _buildUI(redCorlor, subtitle, hintText, containerUserBox, textColorWhite, errorConn),
    );
  }

  Widget _buildUI(redCorlor, subtitle, hintText, containerUserBox, textColorWhite, errorConn) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(children: [
        DashChat(
          inputOptions: InputOptions(
            alwaysShowSend: true, // Đảm bảo nút send luôn hiển thị
            sendButtonBuilder: (send) {
              return IconButton(
                icon: ImageIcon(
                  const AssetImage('assets/send.png'),
                  color: redCorlor,
                ),
                onPressed: send,
              );
            },
            trailing: [
              IconButton(
                onPressed: _sendMediaMessage,
                icon: Icon(
                  Icons.image,
                  color: redCorlor,
                  size: 30,
                ),
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
                    borderSide: BorderSide(color: Color(0xFFCBD5E1)),
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
          currentUser: currentUser,
          onSend: _sendMessage,
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
        if (!_hasSentFirstMessage)
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

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
      _hasSentFirstMessage = true;
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      // Assuming gemini is an instance of a class that handles API requests
      gemini
          // ignore: deprecated_member_use
          ?.streamGenerateContent(
        question,
        images: images,
        modelName: 'gemini-1.5-flash',
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;

        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response =
              event.content?.parts?.fold("", (previous, current) => "$previous ${current.toString()}") ?? "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response =
              event.content?.parts?.fold("", (previous, current) => "$previous ${current.toString()}") ?? "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      }).onError((error) {
        // Handle specific GeminiException
        if (error is GeminiException) {
          // Display error message to the user
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error sending request. Please try again!'),
            ),
          );
        }
      });
    } catch (e) {
      // Display error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again!'),
        ),
      );
    }
  }

  void _sendMediaMessage() async {
    final localizations = AppLocalizations.of(context);
    final desPic = localizations != null ? localizations.ai_chatting_desPic : 'Default Text';
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: desPic,
        medias: [
          ChatMedia(
            url: file.path,
            type: MediaType.image,
            fileName: '',
          ),
        ],
      );

      try {
        // Send the message
        _sendMessage(chatMessage);
      } catch (e) {
        // Log the error details
        print("Exception occurred while sending media message: $e");
      }
    } else {}
  }
}
