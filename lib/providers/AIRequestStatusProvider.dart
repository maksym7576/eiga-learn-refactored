// Провайдер статусу AI-запиту (реальний час, логування, детальні помилки)
import 'dart:async';

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

enum AiErrorType {
  network,
  auth,
  rateLimit,
  model,
  server,
  parsing,
  unknown,
}

class AiEvent {
  final DateTime at;
  final String message;
  final String? kind;
  AiEvent(this.message, {this.kind}) : at = DateTime.now();

  Map<String, dynamic> toJson() => {
    'at': at.toIso8601String(),
    'message': message,
    'kind': kind,
  };
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
  final AiErrorType? lastErrorType;
  final int? lastErrorCode;
  final List<AiEvent> events;

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
    this.lastErrorType,
    this.lastErrorCode,
    this.events = const [],
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
    AiErrorType? lastErrorType,
    int? lastErrorCode,
    List<AiEvent>? events,
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
      lastErrorType: lastErrorType ?? this.lastErrorType,
      lastErrorCode: lastErrorCode ?? this.lastErrorCode,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString(),
      'processingMethod': processingMethod?.toString(),
      'modelName': modelName,
      'startedAt': startedAt?.toIso8601String(),
      'finishedAt': finishedAt?.toIso8601String(),
      'errorMessage': errorMessage,
      'itemsProcessed': itemsProcessed,
      'itemsTotal': itemsTotal,
      'retryCount': retryCount,
      'logs': logs,
      'lastErrorType': lastErrorType?.toString(),
      'lastErrorCode': lastErrorCode,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'AiRequestState(status: $status, method: $processingMethod, model: $modelName, items: $itemsProcessed/$itemsTotal, duration: $duration, error: $errorMessage, logsCount: ${logs.length})';
  }
}

class AiRequestNotifier extends StateNotifier<AiRequestState> {
  AiRequestNotifier() : super(const AiRequestState());

  // Stream for real-time subscribers (UI / logs)
  final StreamController<AiRequestState> _controller =
  StreamController<AiRequestState>.broadcast();

  Stream<AiRequestState> get stream => _controller.stream;

  void _emitState() {
    try {
      if (!_controller.isClosed) _controller.add(state);
    } catch (_) {}
  }

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
      events: [AiEvent('start', kind: 'system')],
    );
    state = newState;
    _emitState();
    print('[AI_REQ] start: $newState');
  }

  void setSending() {
    state = state.copyWith(status: AiRequestStatus.sending, logs: [
      ...state.logs,
      '[${DateTime.now().toIso8601String()}] sending'
    ], events: [...state.events, AiEvent('sending', kind: 'system')]);
    _emitState();
    print('[AI_REQ] setSending: ${state.toString()}');
  }

  void setWaitingResponse() {
    state = state.copyWith(status: AiRequestStatus.waitingResponse, logs: [
      ...state.logs,
      '[${DateTime.now().toIso8601String()}] waitingResponse'
    ], events: [...state.events, AiEvent('waitingResponse', kind: 'system')]);
    _emitState();
    print('[AI_REQ] setWaitingResponse: ${state.toString()}');
  }

  void setStreamingResponse() {
    state = state.copyWith(status: AiRequestStatus.streamingResponse, logs: [
      ...state.logs,
      '[${DateTime.now().toIso8601String()}] streamingResponse'
    ], events: [...state.events, AiEvent('streamingResponse', kind: 'system')]);
    _emitState();
    print('[AI_REQ] setStreamingResponse: ${state.toString()}');
  }

  void incrementProgress([int by = 1]) {
    state = state.copyWith(itemsProcessed: state.itemsProcessed + by);
    _emitState();
    print('[AI_REQ] progress: ${state.itemsProcessed}/${state.itemsTotal}');
  }

  void setItemsProcessed(int value) {
    state = state.copyWith(itemsProcessed: value);
    _emitState();
    print('[AI_REQ] setItemsProcessed: ${state.itemsProcessed}/${state.itemsTotal}');
  }

  void setItemsTotal(int? total) {
    state = state.copyWith(itemsTotal: total);
    _emitState();
    print('[AI_REQ] setItemsTotal: ${state.itemsProcessed}/${state.itemsTotal}');
  }

  void setRetry(int attempt) {
    state = state.copyWith(retryCount: attempt, logs: [
      ...state.logs,
      '[${DateTime.now().toIso8601String()}] retry #$attempt'
    ], events: [...state.events, AiEvent('retry#$attempt', kind: 'system')]);
    _emitState();
    print('[AI_REQ] retry #$attempt');
  }

  void success() {
    state = state.copyWith(
      status: AiRequestStatus.success,
      finishedAt: DateTime.now(),
      logs: [...state.logs, '[${DateTime.now().toIso8601String()}] success'],
      events: [...state.events, AiEvent('success', kind: 'system')],
    );
    _emitState();
    print('[AI_REQ] success: ${state.toString()}');
  }

  /// Регіструє подію / лог у state та емісує її
  void recordEvent(String message, {String? kind}) {
    final e = AiEvent(message, kind: kind);
    state = state.copyWith(events: [...state.events, e], logs: [...state.logs, message]);
    _emitState();
    print('[AI_REQ] event: $message');
  }

  /// Детально звітує про помилку: тип, HTTP-код (якщо є), stackTrace і чи термінальна
  void setErrorWithDetails(
      Object error, {
        String? message,
        StackTrace? stackTrace,
        AiErrorType? type,
        int? httpCode,
        bool terminal = true,
      }) {
    state = state.copyWith(
      status: terminal ? AiRequestStatus.error : state.status,
      finishedAt: terminal ? DateTime.now() : state.finishedAt,
      error: error,
      errorMessage: message ?? error.toString(),
      stackTrace: stackTrace ?? state.stackTrace,
      logs: [
        ...state.logs,
        '[${DateTime.now().toIso8601String()}] ERROR: ${message ?? error.toString()}'
      ],
      lastErrorType: type ?? AiErrorType.unknown,
      lastErrorCode: httpCode ?? state.lastErrorCode,
      events: [...state.events, AiEvent(message ?? error.toString(), kind: 'error')],
    );
    _emitState();
    print('[AI_REQ] setError: ${state.errorMessage}\n$stackTrace');
  }

  void reportError(
      Object error, {
        String? message,
        StackTrace? stackTrace,
        bool terminal = true,
      }) {
    AiErrorType type = AiErrorType.unknown;
    final lower = (message ?? error.toString()).toLowerCase();
    if (lower.contains('token') || lower.contains('auth')) type = AiErrorType.auth;
    if (lower.contains('rate')) type = AiErrorType.rateLimit;
    if (lower.contains('server') || lower.contains('503') || lower.contains('500')) type = AiErrorType.server;
    if (lower.contains('parse') || lower.contains('json')) type = AiErrorType.parsing;
    setErrorWithDetails(error, message: message, stackTrace: stackTrace, type: type, terminal: terminal);
  }

  void appendLog(String text) {
    state = state.copyWith(logs: [...state.logs, text], events: [...state.events, AiEvent(text)]);
    _emitState();
    print('[AI_REQ] appendLog: $text');
  }

  List<String> getLogs({int? lastN}) {
    if (lastN == null || lastN <= 0) return state.logs;
    final start = state.logs.length - lastN;
    if (start <= 0) return state.logs;
    return state.logs.sublist(start);
  }

  AiRequestState getSnapshot() => state;

  void clearLogs() {
    state = state.copyWith(logs: [], events: []);
    _emitState();
  }

  void reset() {
    state = const AiRequestState();
    _emitState();
    print('[AI_REQ] reset');
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

final aiRequestStatusProvider =
StateNotifierProvider<AiRequestNotifier, AiRequestState>((ref) {
  return AiRequestNotifier();
});