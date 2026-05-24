import 'package:fpdart/fpdart.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/domain/failures/chatting_failures.dart';
import 'dart:typed_data';

abstract class ChattingRepository {
  /// Sends a message to Gemini and returns a stream of response chunks
  Stream<Either<ChattingFailure, String>> streamGenerateContent(
    String question, {
    List<Uint8List>? images,
    required String modelName,
    List<Map<String, dynamic>>? history,
  });

  /// Connects to Ably Live Support
  Future<Either<ChattingFailure, void>> connectLiveSupport(String clientId);

  /// Sends a message via Ably
  Future<Either<ChattingFailure, void>> sendMessageLiveSupport(String message);
}
