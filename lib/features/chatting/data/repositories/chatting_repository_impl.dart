import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:study_abroad_cemc_mobile/features/chatting/domain/failures/chatting_failures.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/domain/repositories/chatting_repository.dart';

class ChattingRepositoryImpl implements ChattingRepository {
  GenerativeModel? _model;
  String? _currentModelName;

  Future<void> _ensureGeminiInitialized(String modelName) async {
    if (_model == null || _currentModelName != modelName) {
      try {
        final jsonString = await rootBundle.loadString('env.json');
        final jsonResponse = jsonDecode(jsonString);
        final apiKey = jsonResponse['api_key'];

        // Load knowledge base
        String systemInstructionText = "";
        try {
          systemInstructionText = await rootBundle.loadString('assets/knowledge/cemc_study_abroad.txt');
        } catch (e) {
          print("Could not load knowledge base: $e");
        }

        _model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
          systemInstruction: systemInstructionText.isNotEmpty 
              ? Content.system(systemInstructionText)
              : null,
        );
        _currentModelName = modelName;
      } catch (e) {
        throw Exception("Failed to initialize Gemini API: $e");
      }
    }
  }

  @override
  Stream<Either<ChattingFailure, String>> streamGenerateContent(
    String question, {
    List<Uint8List>? images,
    required String modelName,
    List<Map<String, dynamic>>? history,
  }) async* {
    try {
      await _ensureGeminiInitialized(modelName);
      
      final content = [
        Content.multi([
          if (images != null) ...images.map((img) => DataPart('image/jpeg', img)),
          TextPart(question),
        ])
      ];

      // Build history if provided
      List<Content> chatHistory = [];
      if (history != null) {
        for (var msg in history) {
          final role = msg['role'] as String; // 'user' or 'model'
          final text = msg['text'] as String;
          chatHistory.add(role == 'user' ? Content.text(text) : Content.model([TextPart(text)]));
        }
      }

      final chatSession = _model!.startChat(history: chatHistory);
      final stream = chatSession.sendMessageStream(content.first);

      await for (final chunk in stream) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          yield Right(chunk.text!);
        }
      }
    } catch (e) {
      yield Left(GeminiFailure(
          message: 'Error communicating with Gemini: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ChattingFailure, void>> connectLiveSupport(
      String clientId) async {
    return const Left(LiveSupportFailure(message: 'Not implemented yet'));
  }

  @override
  Future<Either<ChattingFailure, void>> sendMessageLiveSupport(
      String message) async {
    return const Left(LiveSupportFailure(message: 'Not implemented yet'));
  }
}

