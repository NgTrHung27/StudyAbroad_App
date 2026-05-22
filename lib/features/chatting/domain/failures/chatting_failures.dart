import 'package:study_abroad_cemc_mobile/core/errors/failures.dart';

class ChattingFailure extends Failure {
  const ChattingFailure({required super.message, super.originalError});
}

class GeminiFailure extends ChattingFailure {
  const GeminiFailure({required super.message, super.originalError});
}

class LiveSupportFailure extends ChattingFailure {
  const LiveSupportFailure({required super.message, super.originalError});
}
