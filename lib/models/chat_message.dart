import 'package:study_abroad_cemc_mobile/models/chat_session_role.dart';

class Message {
  final String? name;
  final String message;
  final ChatSessionRole? role;
  final DateTime createdAt;
  final String? clientId;
  final String? userId;

  Message({
    this.name,
    required this.message,
    this.role,
    required this.createdAt,
    this.clientId,
    this.userId,
  });
// Phương thức sao chép đối tượng với giá trị createdAt mới
  Message copyWith({String? text, DateTime? createdAt, String? role}) {
    return Message(
      name: name,
      message: text ?? message,
      role: role != null ? _parseChatSessionRole(role) : this.role,
      createdAt: createdAt ?? DateTime.now(),
      clientId: clientId,
      userId: userId,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      name: json['name'],
      message: json['message'],
      role: _parseChatSessionRole(json['role']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      clientId: json['clientId'],
      userId: json['userId'],
    );
  }
}

ChatSessionRole _parseChatSessionRole(String roleString) {
  switch (roleString) {
    case 'ADMIN':
      return ChatSessionRole.ADMIN;
    case 'USER':
      return ChatSessionRole.USER;
    default:
      throw Exception('Invalid chat session role: $roleString');
  }
}

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    clientId: 'clzz2fp4x0000fntxlz9asr63',
    message: 'Hey, how\'s it going?',
    role: ChatSessionRole.USER,
    userId: 'clzz2fp4x0000fntxlz9asr63',
    createdAt: DateTime.now().toLocal(),
  )
];
