import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'package:study_abroad_cemc_mobile/features/chatting/domain/failures/chatting_failures.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/domain/repositories/chatting_repository.dart';

class ChattingRepositoryImpl implements ChattingRepository {
  bool _isGeminiInitialized = false;

  Future<void> _ensureGeminiInitialized() async {
    if (!_isGeminiInitialized) {
      try {
        final jsonString = await rootBundle.loadString('env.json');
        final jsonResponse = jsonDecode(jsonString);
        final apiKey = jsonResponse['api_key'];
        Gemini.init(apiKey: apiKey);
        _isGeminiInitialized = true;
      } catch (e) {
        throw Exception("Failed to initialize Gemini API Key");
      }
    }
  }

  @override
  Stream<Either<ChattingFailure, String>> streamGenerateContent(
    String question, {
    List<Uint8List>? images,
    required String modelName,
  }) async* {
    try {
      await _ensureGeminiInitialized();
      final gemini = Gemini.instance;

      // ignore: deprecated_member_use
      final stream = gemini.streamGenerateContent(
        question,
        images: images,
        modelName: modelName,
      );

      await for (final event in stream) {
        final response = event.content?.parts?.fold(
                "", (previous, current) => "$previous ${current.toString()}") ??
            "";
        yield Right(response);
      }
    } catch (e) {
      yield Left(GeminiFailure(
          message: 'Error communicating with Gemini: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ChattingFailure, void>> connectLiveSupport(
      String clientId) async {
    // TODO: Implement Ably logic
    return const Left(LiveSupportFailure(message: 'Not implemented yet'));
  }

  @override
  Future<Either<ChattingFailure, void>> sendMessageLiveSupport(
      String message) async {
    // TODO: Implement Ably logic
    return const Left(LiveSupportFailure(message: 'Not implemented yet'));
  }
}
