import 'dart:convert';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kltn_mobile/models/chat_message.dart';
import 'package:kltn_mobile/models/chat_session.dart';
import 'package:kltn_mobile/models/chat_session_role.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:http/http.dart' as http;

class AblyChat extends BasePage {
  const AblyChat({super.key});

  @override
  State<AblyChat> createState() => _AblyChatState();
}

class _AblyChatState extends BasePageState<AblyChat> {
  final String _clientId = '1d9dca79-eef1-46ce-9c49-lannaytutao';
  final String _userId = '';
  //Ably API Key and Channel
  final String ablyApiKey =
      '9bh_vA.1AUw5A:WmXhnQ4HahteJggps_qvNQF9HYzqU-mLGgUzBaUvY28'; // Replace with your API key
  late ably.Realtime realtimeInstance;
  late ably.RealtimeChannel chatChannel;
  //Text Controller
  final TextEditingController _messageController = TextEditingController();
  // ignore: prefer_typing_uninitialized_variables
  var newMsgFromAbly;
  late ChatSession _currentChatSession;
  //User Initialization
  String userName = "User";
  String avtUser =
      "https://static.vecteezy.com/system/resources/thumbnails/008/442/086/small_2x/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg";
  @override
  void initState() {
    super.initState();
    createAblyRealtimeInstance();
    _loadChatSession();
    _currentChatSession = ChatSession.placeholder();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadChatSession() async {
    // Ghi lại thời gian trước khi gọi API
    final DateTime beforeApiCall = DateTime.now();
    print(
        'Time before API call: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(beforeApiCall)}');

    final chatSessionResponse = await http.get(
      Uri.parse(
          'https://admin-cemc-co.vercel.app/api/chat-session/$_clientId/$_clientId'),
    );

    // Ghi lại thời gian sau khi gọi API
    final DateTime afterApiCall = DateTime.now();
    print(
        'Time after API call: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(afterApiCall)}');

    if (chatSessionResponse.statusCode == 200) {
      final chatSessionData =
          json.decode(utf8.decode(chatSessionResponse.bodyBytes));
      _currentChatSession = ChatSession.fromJson(chatSessionData);
      setState(() {});
    } else {
      // Handle error
    }
  }

  void createAblyRealtimeInstance() async {
    // ignore: deprecated_member_use
    var clientOptions = ably.ClientOptions.fromKey(
        '9bh_vA.1AUw5A:WmXhnQ4HahteJggps_qvNQF9HYzqU-mLGgUzBaUvY28');
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

  String _lastSentMessage = '';
  void subscribeToChatChannel() {
    var messageStream = chatChannel.subscribe();
    messageStream.listen((ably.Message message) {
      Message newChatMsg;
      var newMsgFromAbly = message.data; // message.data could be a String

      // Check if newMsgFromAbly is a Map or String
      if (newMsgFromAbly is Map<String, dynamic>) {
        final messageText = newMsgFromAbly["message"];

        // Check if the message is the same as the last sent message
        if (messageText == _lastSentMessage) {
          return; // Skip adding the message if it's the same as the last sent message
        }

        newChatMsg = Message(
            clientId: _clientId,
            message: messageText,
            role: ChatSessionRole.ADMIN,
            userId: _userId,
            createdAt: DateTime.now().toLocal());

        setState(() {
          _currentChatSession.messages?.add(newChatMsg);
        });
      } else if (newMsgFromAbly is String) {
        // Check if the message is the same as the last sent message
        if (newMsgFromAbly == _lastSentMessage) {
          return; // Skip adding the message if it's the same as the last sent message
        }

        newChatMsg = Message(
          clientId: _clientId,
          message: newMsgFromAbly, // Directly assign the string as message
          role: ChatSessionRole.ADMIN,
          userId: _userId, createdAt: DateTime.now().toLocal(),
        );

        setState(() {
          _currentChatSession.messages?.add(newChatMsg);
        });
      } else {
        // Handle unexpected data type
        print("Unexpected data type: ${newMsgFromAbly.runtimeType}");
        print(
            "Received message data: ${message.data}, Type: ${message.data.runtimeType}");
      }
    });
  }

  void publishMyMessage() async {
    var myMessage = _messageController.text;
    if (myMessage.isEmpty) return;

    _messageController.clear();
    print('Sending message: $myMessage to channel: support:$_clientId');

    await chatChannel.publish(name: 'support:$_clientId', data: myMessage);

    final newMessage = Message(
        clientId: _clientId,
        message: myMessage,
        role: ChatSessionRole.USER,
        userId: _userId,
        createdAt: DateTime.now().toLocal());
    print('Check message send from mobile: ${newMessage.role}');

    setState(() {
      _currentChatSession.messages?.add(newMessage);
    });

    // Update the last sent message
    _lastSentMessage = myMessage;

    if (myMessage.isNotEmpty) {
      final requestBody = jsonEncode({
        'userId': _userId,
        'name': '',
        'email': '',
        'phone': '',
        'clientId': _clientId,
        'message': myMessage,
      });

      // Log data before sending
      print('Request Body: $requestBody');

      final chatSupportResponse = await http.post(
        Uri.parse('https://admin-cemc-co.vercel.app/api/chat-session'),
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      final chatData = json.decode(utf8.decode(chatSupportResponse.bodyBytes));
      if (chatSupportResponse.statusCode == 200) {
        // Message sent successfully
        _messageController.clear();

        _loadChatSession(); // Refresh the chat session
      } else {
        // Handle error
        print('Check json $chatData');
      }
    }
  }

  _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 50.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _messageController,
              onChanged: (value) {},
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              publishMyMessage();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    final isAdmin = message.role == ChatSessionRole.ADMIN;
    final formattedTime =
        DateFormat('HH:mm - dd/MM/yy').format(message.createdAt.toLocal());
    return Align(
      alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isAdmin ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.name ?? 'Hung Null User Test',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              message.message,
              style: TextStyle(
                color: isAdmin ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Admin'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _currentChatSession.messages?.length ?? 0,
              itemBuilder: (context, index) {
                final message = _currentChatSession.messages?[index];
                // Check if the message is not null and has a valid role
                if (message != null && message.role != null) {
                  return _buildMessage(message);
                } else {
                  return const SizedBox
                      .shrink(); // Return an empty widget if the message is null or has no role
                }
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }
}
