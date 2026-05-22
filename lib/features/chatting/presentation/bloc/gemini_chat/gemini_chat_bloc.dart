import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/domain/repositories/chatting_repository.dart';
import 'gemini_chat_event.dart';
import 'gemini_chat_state.dart';

class GeminiChatBloc extends Bloc<GeminiChatEvent, GeminiChatState> {
  final ChattingRepository _repository;
  final ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage: "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
  );

  GeminiChatBloc(this._repository) : super(GeminiChatState.initial()) {
    on<SendGeminiMessage>(_onSendGeminiMessage);
    on<ClearGeminiChat>((event, emit) => emit(GeminiChatState.initial()));
  }

  Future<void> _onSendGeminiMessage(SendGeminiMessage event, Emitter<GeminiChatState> emit) async {
    // Add user message to UI
    final newMessages = [event.message, ...state.messages];
    emit(state.copyWith(messages: newMessages, error: null));

    // Prepare images if any
    List<Uint8List>? images;
    if (event.message.medias != null && event.message.medias!.isNotEmpty) {
      images = [File(event.message.medias!.first.url).readAsBytesSync()];
    }

    try {
      final stream = _repository.streamGenerateContent(
        event.message.text,
        images: images,
        modelName: event.modelName,
      );

      await emit.forEach(stream, onData: (result) {
        return result.fold(
          (failure) => state.copyWith(error: failure.message),
          (chunk) {
            final List<ChatMessage> updatedMessages = List.from(state.messages);
            
            // Check if last message was from Gemini
            if (updatedMessages.isNotEmpty && updatedMessages.first.user.id == geminiUser.id) {
              final lastMessage = updatedMessages.removeAt(0);
              lastMessage.text += chunk;
              updatedMessages.insert(0, lastMessage);
            } else {
              // Add a new message from Gemini
              final message = ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text: chunk,
              );
              updatedMessages.insert(0, message);
            }

            return state.copyWith(messages: updatedMessages);
          },
        );
      });
    } catch (e) {
      emit(state.copyWith(error: 'An error occurred: $e'));
    }
  }
}
