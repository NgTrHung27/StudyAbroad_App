import 'package:study_abroad_cemc_mobile/core/errors/failures.dart';

abstract class ChattingFailure extends Failure {
  const ChattingFailure({String? message}) : super(message: message ?? 'Chatting failure occurred');
}

class GeminiFailure extends ChattingFailure {
  const GeminiFailure({super.message});
}

class LiveSupportFailure extends ChattingFailure {
  const LiveSupportFailure({super.message});
}
