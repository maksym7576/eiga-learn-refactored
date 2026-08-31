import 'package:eiga/backend/data/models/videoObject.dart';
import 'package:eiga/providers/AiRequestPhase.dart';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:eiga/providers/videoDataProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AiTrackerState {
  final List<AiRequestEntry> history;

  AiTrackerState({
    this.history = const [],
  });

  AiTrackerState copyWith({
    List<AiRequestEntry>? history,
  }) {
    return AiTrackerState(
      history: history ?? this.history,
    );
  }
}

class AiTrackerNotifier extends Notifier<AiTrackerState> {
  @override
  AiTrackerState build() {
    final videoId = ref.watch(playerIdProvider);
    if (videoId != null) {
      Future.microtask(() => _loadHistoryForVideo(videoId));
    }
    return AiTrackerState();
  }

  Future<void> _loadHistoryForVideo(int videoId) async {
    final videoService = ref.read(videoServiceProvider.notifier);
    final video = await videoService.getVideoById(videoId);
    if (video != null) {
      List<AiRequestEntry> history = video.aiHistory ?? [];
      
      // Cleanup: mark stuck "processing" requests as "error"
      bool modified = false;
      final cleanedHistory = history.map((e) {
        if (e.phase == 'processing') {
          modified = true;
          return AiRequestEntry(
            id: e.id,
            modelName: e.modelName,
            requestType: e.requestType,
            startTime: e.startTime,
            endTime: DateTime.now(),
            phase: 'error',
            errorMessage: 'Interrupted or failed to complete',
            failedIds: e.failedIds,
          );
        }
        return e;
      }).toList();

      if (modified) {
        await videoService.updateVideo(video.copyWith(aiHistory: cleanedHistory));
        state = state.copyWith(history: cleanedHistory);
      } else {
        state = state.copyWith(history: history);
      }
    } else {
      state = state.copyWith(history: []);
    }
  }

  Future<String> startRequest({
    required String modelName,
    required String requestType,
  }) async {
    final videoId = ref.read(playerIdProvider);
    if (videoId == null) return '';

    final requestId = DateTime.now().microsecondsSinceEpoch.toString();
    final entry = AiRequestEntry(
      id: requestId,
      modelName: modelName,
      requestType: requestType,
      startTime: DateTime.now(),
      phase: 'processing',
    );

    final videoService = ref.read(videoServiceProvider.notifier);
    final video = await videoService.getVideoById(videoId);
    if (video != null) {
      final currentHistory = video.aiHistory ?? [];
      final updatedHistory = [entry, ...currentHistory];
      if (updatedHistory.length > 100) updatedHistory.removeLast();
      
      await videoService.updateVideo(video.copyWith(aiHistory: updatedHistory));
      state = state.copyWith(history: updatedHistory);
    }

    return requestId;
  }

  Future<void> completeRequest({
    required String requestId,
    required AiRequestPhase phase,
    String? errorMessage,
    List<int>? failedPhraseIds,
    int? videoId,
  }) async {
    final targetVideoId = videoId ?? ref.read(playerIdProvider);
    if (targetVideoId == null) return;

    final videoService = ref.read(videoServiceProvider.notifier);
    final video = await videoService.getVideoById(targetVideoId);
    if (video == null) return;

    final currentHistory = video.aiHistory ?? [];
    final index = currentHistory.indexWhere((e) => e.id == requestId);
    
    if (index != -1) {
      final active = currentHistory[index];
      final completedEntry = AiRequestEntry(
        id: active.id,
        modelName: active.modelName,
        requestType: active.requestType,
        startTime: active.startTime,
        endTime: DateTime.now(),
        phase: phase.name,
        errorMessage: errorMessage,
        failedIds: failedPhraseIds,
      );

      final updatedHistory = List<AiRequestEntry>.from(currentHistory);
      updatedHistory[index] = completedEntry;
      
      await videoService.updateVideo(video.copyWith(aiHistory: updatedHistory));
      
      // Only update local state if we are still on the same video
      if (targetVideoId == ref.read(playerIdProvider)) {
        state = state.copyWith(history: updatedHistory);
      }
    }
  }
}

final aiTrackerProvider = NotifierProvider<AiTrackerNotifier, AiTrackerState>(() {
  return AiTrackerNotifier();
});
