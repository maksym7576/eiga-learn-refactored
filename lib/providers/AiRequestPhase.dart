import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../backend/exeption/AiUserFacingError.dart';

enum AiRequestPhase { success, partialSuccess, error }

class AiRequestResult {
  final AiRequestPhase phase;
  final AiUserFacingError? error;
  final List<int> failedPhraseIds;

  const AiRequestResult({
    required this.phase,
    this.error,
    this.failedPhraseIds = const [],
  });

  bool get isOk => phase == AiRequestPhase.success;

  factory AiRequestResult.success() =>
      const AiRequestResult(phase: AiRequestPhase.success);

  factory AiRequestResult.partialSuccess(List<int> failedIds) => AiRequestResult(
    phase: AiRequestPhase.partialSuccess,
    failedPhraseIds: failedIds,
    error: PartialFailureInfo(failedIds.map((e) => e.toString()).toList()).toUserFacing(),
  );

  factory AiRequestResult.failure(AiErrorType type) =>
      AiRequestResult(phase: AiRequestPhase.error, error: type.toUserFacing());
}

final aiRequestResultProvider = StateProvider<AiRequestResult?>((ref) => null);
