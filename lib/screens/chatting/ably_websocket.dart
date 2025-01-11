import 'dart:convert';
import 'dart:ui';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/models/chat_message.dart';
import 'package:kltn_mobile/models/chat_session.dart';
import 'package:kltn_mobile/models/chat_session_role.dart';
import 'package:kltn_mobile/screens/chatting/client_id.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AblyWebsocket extends BasePage {
  const AblyWebsocket({super.key});

  @override
  State<AblyWebsocket> createState() => _AblyChatState();
}

//Final
class _AblyChatState extends BasePageState<AblyWebsocket> {
  bool _isLoading = false;

  late String _clientId;
  void connect() {
    // Thực hiện kết nối WebSocket với _clientId
  }

  final String _userId = '';
  //Ably API Key and Channel
  // Replace with your API key
  late ably.Realtime realtimeInstance;
  late ably.RealtimeChannel chatChannel;
  //Text Controller
  final TextEditingController _messageController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var newMsgFromAbly;
  late ChatSession _currentChatSession;
  //User Initialization
  late ChatUser currentUser;
  String userName = "User";
  String avtUser =
      "https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg";
  ChatUser system = ChatUser(
    id: "1",
    firstName: "System",
    profileImage:
        "https://files.edgestore.dev/ej1zo8o303l788n0/publicFiles/_public/ffc6e80a-123e-4e2e-aacf-f7c0307f1613.png",
  );
  @override
  void initState() {
    super.initState();
    setLoadingState();
    _clientId = Provider.of<ClientIdProvider>(context, listen: false).clientId;
    currentUser = ChatUser(
        id: "0",
        firstName: userName, // Sử dụng giá trị mặc định hoặc tạm thời
        profileImage: avtUser);
    createAblyRealtimeInstance();
    _loadChatSession();
    _currentChatSession = ChatSession.placeholder();
  }

  void setLoadingState() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sortMessages() {
    _currentChatSession.messages
        ?.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _loadChatSession() async {
    final chatSessionResponse = await http.get(
      Uri.parse(
          'https://admin-cemc-co.vercel.app/api/chat-session/$_clientId/$_clientId'),
    );

    if (chatSessionResponse.statusCode == 200) {
      final chatSessionData =
          json.decode(utf8.decode(chatSessionResponse.bodyBytes));
      final newChatSession = ChatSession.fromJson(chatSessionData);

      setState(() {
        _currentChatSession = newChatSession;
        _sortMessages();
      });

    } else {
      _loadChatSession();
    }
  }

  void createAblyRealtimeInstance() async {
    final jsonString = await rootBundle.loadString('env.json');
    final jsonResponse = jsonDecode(jsonString);
    String ablykey = jsonResponse['ably_key'];
    // ignore: deprecated_member_use
    var clientOptions = ably.ClientOptions.fromKey(ablykey);
    clientOptions.clientId = _clientId;
    try {
      realtimeInstance = ably.Realtime(options: clientOptions);
      chatChannel = realtimeInstance.channels.get('support:$_clientId');
      subscribeToChatChannel();
      realtimeInstance.connection
          .on(ably.ConnectionEvent.connected)
          .listen((ably.ConnectionStateChange stateChange) async {
      });
      chatChannel.subscribe().listen((ably.Message message) {
      });
    } catch (error) {
      print('Error creating Ably Realtime Instance: $error');
      rethrow;
    }
  }

  void subscribeToChatChannel() {
    chatChannel.subscribe().listen((ably.Message message) async {
      var newMsgFromAbly = message.data;

      // Kiểm tra nếu tin nhắn này là của chính người dùng
      if (newMsgFromAbly is String &&
          newMsgFromAbly == _messageController.text) {
        // Tin nhắn này đã được gửi bởi người dùng, không cần thêm vào danh sách nữa
        return;
      }

      Message newChatMsg;

      if (newMsgFromAbly is Map<String, dynamic>) {
        newChatMsg = Message.fromJson(newMsgFromAbly);
      } else if (newMsgFromAbly is String) {
        newChatMsg = Message(
          clientId: _clientId,
          message: newMsgFromAbly,
          role: ChatSessionRole.ADMIN,
          userId: _userId,
          createdAt: DateTime.now().toLocal(),
        );
      } else {
        return;
      }

      setState(() {
        _currentChatSession.messages?.add(newChatMsg);
        _sortMessages();
      });
    });
  }

  void publishMyMessage(ChatSession newChatSession) async {
    setState(() {
      _isLoading = true;
    });

    var myMessage = _messageController.text;
    if (myMessage.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final newMessage = Message(
      clientId: _clientId,
      message: myMessage,
      role: ChatSessionRole.USER,
      userId: _userId,
      createdAt: DateTime.now().toLocal(),
    );

    setState(() {
      _currentChatSession.messages?.add(newMessage);
      _currentChatSession = newChatSession;
      _sortMessages();
    });

    _messageController.clear();

    try {
      // Gửi tin nhắn lên Ably và server song song
      await Future.wait([
        chatChannel.publish(name: 'support:$_clientId', data: myMessage),
        _sendMessageToServer(myMessage),
      ]);

      // Làm mới danh sách tin nhắn từ server sau khi gửi thành công
      await _loadChatSession();
    } catch (error) {
      print('Error sending message: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessageToServer(String myMessage) async {
    final requestBody = jsonEncode({
      'userId': _userId,
      'name': '',
      'email': '',
      'phone': '',
      'clientId': _clientId,
      'message': myMessage,
    });

    final chatSupportResponse = await http.post(
      Uri.parse('https://admin-cemc-co.vercel.app/api/chat-session'),
      body: requestBody,
      headers: {'Content-Type': 'application/json'},
    );

    if (chatSupportResponse.statusCode != 200) {
      throw Exception('Failed to send message to the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    //Language
    final localizations = AppLocalizations.of(context);
    final title =
        localizations != null ? localizations.chat_system : 'Default Text';
    final hintText = localizations != null
        ? localizations.ai_chatting_input
        : 'Default Text';
    //Theme
    final isDarkMode = context.select(
        (ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final redCorlor = AppColor.redButton;
    final containerUserBox =
        isDarkMode ? const Color(0xffD9D9D9) : Colors.white;

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColor.redButton,
            title: TextMonserats(
              title,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
              onPressed: () => Navigator.pushNamed(context, '/mainpage'),
            )),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Stack(children: [
            Column(
              children: [
                Expanded(
                  child: Material(
                    color: context.select((ThemeSettingCubit cubit) =>
                        cubit.state.scaffoldBackgroundColor),
                    child: DashChat(
                      inputOptions: InputOptions(
                        alwaysShowSend: true,
                        sendButtonBuilder: (send) {
                          return IconButton(
                            icon: ImageIcon(
                              const AssetImage('assets/send.png'),
                              color: redCorlor,
                            ),
                            onPressed: send,
                          );
                        },
                        inputTextStyle: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
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
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(22),
                              bottomRight: Radius.circular(22),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(22),
                              bottomRight: Radius.circular(22),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                        cursorStyle: CursorStyle(
                          color: redCorlor,
                        ),
                      ),
                      currentUser: currentUser,
                      onSend: (ChatMessage message) {
                        _messageController.text = message.text;
                        publishMyMessage(_currentChatSession);
                      },
                      messages: _currentChatSession.messages
                              ?.map((message) => ChatMessage(
                                    user: message.role == ChatSessionRole.ADMIN
                                        ? system
                                        : currentUser,
                                    createdAt: message.createdAt,
                                    text: message.message,
                                  ))
                              .toList() ??
                          [],
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
                        avatarBuilder:
                            (user, onPressAvatar, onLongPressAvatar) {
                          return GestureDetector(
                            onTap: () => onPressAvatar?.call(user),
                            onLongPress: () => onLongPressAvatar?.call(user),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.profileImage ?? ''),
                              backgroundColor: Colors.white,
                              radius: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Stack(
                children: [
                  Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: AppColor.redButton,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 100), // Khoảng cách từ đáy màn hình
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              height: 62,
                              width: 420,
                              color: Colors.grey.shade50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
          ]),
        ));
  }
}
