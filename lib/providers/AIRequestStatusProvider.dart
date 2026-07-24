// lib/providers/AIRequestStatusProvider.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum AiProcessingMethod {
  fullResponse,
  streaming,
}

enum AiRequestStatus {
  idle,
  preparing,
  sending,
  waitingResponse,
  streamingResponse,
  success,
  error,
}

class AiRequestState {
  final AiRequestStatus status;
  final AiProcessingMethod? processingMethod;
  final String? modelName;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final Object? error;
  final String? errorMessage;
  final StackTrace? stackTrace;
  final int itemsProcessed;
  final int? itemsTotal;
  final int retryCount;
  final List<String> logs;

  const AiRequestState({
    this.status = AiRequestStatus.idle,
    this.processingMethod,
    this.modelName,
    this.startedAt,
    this.finishedAt,
    this.error,
    this.errorMessage,
    this.stackTrace,
    this.itemsProcessed = 0,
    this.itemsTotal,
    this.retryCount = 0,
    this.logs = const [],
  });

  Duration? get duration {
    if (startedAt == null) return null;
    return (finishedAt ?? DateTime.now()).difference(startedAt!);
  }

  bool get isRunning =>
      status == AiRequestStatus.preparing ||
          status == AiRequestStatus.sending ||
          status == AiRequestStatus.waitingResponse ||
          status == AiRequestStatus.streamingResponse;

  bool get hasError => status == AiRequestStatus.error;
  bool get isSuccess => status == AiRequestStatus.success;

  double? get progress {
    if (itemsTotal == null || itemsTotal == 0) return null;
    return itemsProcessed / itemsTotal!;
  }

  AiRequestState copyWith({
    AiRequestStatus? status,
    AiProcessingMethod? processingMethod,
    String? modelName,
    DateTime? startedAt,
    DateTime? finishedAt,
    Object? error,
    String? errorMessage,
    StackTrace? stackTrace,
    int? itemsProcessed,
    int? itemsTotal,
    int? retryCount,
    List<String>? logs,
  }) {
    return AiRequestState(
      status: status ?? this.status,
      processingMethod: processingMethod ?? this.processingMethod,
      modelName: modelName ?? this.modelName,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      stackTrace: stackTrace ?? this.stackTrace,
      itemsProcessed: itemsProcessed ?? this.itemsProcessed,
      itemsTotal: itemsTotal ?? this.itemsTotal,
      retryCount: retryCount ?? this.retryCount,
      logs: logs ?? this.logs,
    );
  }

  @override
  String toString() {
    return 'AiRequestState(status: $status, method: $processingMethod, model: $modelName, items: $itemsProcessed/$itemsTotal, duration: $duration, error: $errorMessage, logsCount: ${logs.length})';
  }
}

class AiRequestNotifier extends StateNotifier<AiRequestState> {
  AiRequestNotifier() : super(const AiRequestState());

  // Початковий старт запиту
  void start({
    required AiProcessingMethod processingMethod,
    required String modelName,
    int? itemsTotal,
  }) {
    final newState = AiRequestState(
      status: AiRequestStatus.preparing,
      processingMethod: processingMethod,
      modelName: modelName,
      startedAt: DateTime.now(),
      itemsTotal: itemsTotal,
      logs: ['Started at ${DateTime.now().toIso8601String()}'],
    );
    state = newState;
    print('[AI_REQ] start: $newState');
  }

  void setSending() {
    state = state.copyWith(status: AiRequestStatus.sending, logs: [
      ...state.logs,
      '[${DateTime.now().toIso8601String()}] sending'
    ]);
    print('[AI_REQ] setSending: ${state.toString()}');
  }

  void setWaitingResponse() {
    state = state.copyWith(status: AiRequestStatus.waitingResponse, logs: [
      ...state.logs,
      '[${DateTime.now().toIso8601String()}] waitingResponse'
    ]);
    print('[AI_REQ] setWaitingResponse: ${state.toString()}');
  }

  void setStreamingResponse() {
    state = state.copyWith(status: AiRequestStatus.streamingResponse, logs: [
      ...state.logs,
      '[${DateTime.now().toIso8601String()}] streamingResponse'
    ]);
    print('[AI_REQ] setStreamingResponse: ${state.toString()}');
  }

  void incrementProgress([int by = 1]) {
    state = state.copyWith(itemsProcessed: state.itemsProcessed + by);
    print('[AI_REQ] progress: ${state.itemsProcessed}/${state.itemsTotal}');
  }

  void setItemsProcessed(int value) {
    state = state.copyWith(itemsProcessed: value);
    print('[AI_REQ] setItemsProcessed: ${state.itemsProcessed}/${state.itemsTotal}');
  }

  void setItemsTotal(int? total) {
    state = state.copyWith(itemsTotal: total);
    print('[AI_REQ] setItemsTotal: ${state.itemsProcessed}/${state.itemsTotal}');
  }

  void setRetry(int attempt) {
    state = state.copyWith(retryCount: attempt, logs: [
      ...state.logs,
      '[${DateTime.now().toIso8601String()}] retry #$attempt'
    ]);
    print('[AI_REQ] retry #$attempt');
  }

  void success() {
    state = state.copyWith(
      status: AiRequestStatus.success,
      finishedAt: DateTime.now(),
      logs: [...state.logs, '[${DateTime.now().toIso8601String()}] success'],
    );
    print('[AI_REQ] success: ${state.toString()}');
  }

  void reportError(
      Object error, {
        String? message,
        StackTrace? stackTrace,
        bool terminal = true,
      }) {
    state = state.copyWith(
      status: terminal ? AiRequestStatus.error : state.status,
      finishedAt: terminal ? DateTime.now() : state.finishedAt,
      error: error,
      errorMessage: message ?? error.toString(),
      stackTrace: stackTrace,
      logs: [
        ...state.logs,
        '[${DateTime.now().toIso8601String()}] ERROR: ${message ?? error.toString()}'
      ],
    );
    print('[AI_REQ] reportError: ${state.errorMessage}\n$stackTrace');
  }

  void appendLog(String text) {
    state = state.copyWith(logs: [...state.logs, text]);
    print('[AI_REQ] appendLog: $text');
  }

  void reset() {
    state = const AiRequestState();
    print('[AI_REQ] reset');
  }
}

final aiRequestStatusProvider =
StateNotifierProvider<AiRequestNotifier, AiRequestState>((ref) {
  return AiRequestNotifier();
});