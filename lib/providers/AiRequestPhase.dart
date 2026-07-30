
import '../backend/exeption/AiUserFacingError.dart';

enum AiRequestPhase { success, partialSuccess, error }

class AiRequestResult {
  final AiRequestPhase phase;
  final AiUserFacingError? error;
  final List<String> failedPhraseIds;

  const AiRequestResult({
    required this.phase,
    this.error,
    this.failedPhraseIds = const [],
  });

  bool get isOk => phase == AiRequestPhase.success;

  factory AiRequestResult.success() =>
      const AiRequestResult(phase: AiRequestPhase.success);

  factory AiRequestResult.partialSuccess(List<String> failedIds) => AiRequestResult(
    phase: AiRequestPhase.partialSuccess,
    failedPhraseIds: failedIds,
    error: PartialFailureInfo(failedIds).toUserFacing(),
  );

  factory AiRequestResult.failure(AiErrorType type) =>
      AiRequestResult(phase: AiRequestPhase.error, error: type.toUserFacing());
}