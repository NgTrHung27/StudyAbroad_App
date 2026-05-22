import 'package:study_abroad_cemc_mobile/models/chat_message.dart';

class ChatSession {
  final String id;
  final String clientId;
  final String? name;
  final String? email;
  final String? phone;
  final String? userId;
  final List<Message>? messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.clientId,
    this.name,
    this.email,
    this.phone,
    this.userId,
    this.messages,
    required this.createdAt,
    required this.updatedAt,
  });
  ChatSession copyWith({
    String? name,
    String? email,
    String? phone,
    String? userId,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatSession(
      id: id,
      clientId: clientId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userId: userId ?? this.userId,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      clientId: json['clientId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userId: json['userId'],
      messages: (json['messages'] as List<dynamic>?)
          ?.map((messageData) => Message.fromJson(messageData))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  // Placeholder method
  static ChatSession placeholder() {
    return ChatSession(
      id: '',
      clientId: '',
      createdAt: DateTime.now().toLocal(),
      updatedAt: DateTime.now().toLocal(),
      messages: [],
    );
  }
}
