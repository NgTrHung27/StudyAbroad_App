import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:equatable/equatable.dart';

class GeminiChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const GeminiChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  factory GeminiChatState.initial() {
    return const GeminiChatState(messages: []);
  }

  GeminiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return GeminiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, error];
}
