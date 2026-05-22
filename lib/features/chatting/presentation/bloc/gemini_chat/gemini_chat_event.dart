import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:equatable/equatable.dart';

abstract class GeminiChatEvent extends Equatable {
  const GeminiChatEvent();

  @override
  List<Object?> get props => [];
}

class SendGeminiMessage extends GeminiChatEvent {
  final ChatMessage message;
  final String modelName;

  const SendGeminiMessage(this.message, {required this.modelName});

  @override
  List<Object?> get props => [message, modelName];
}

class ClearGeminiChat extends GeminiChatEvent {}
