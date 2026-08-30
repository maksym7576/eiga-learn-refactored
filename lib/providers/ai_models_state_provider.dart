import 'dart:async';

import 'package:eiga/backend/data/dto/AiModelSettingsDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
import 'package:eiga/config/modelsUrl/aiModelManager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/modelsUrl/TranslationPipelineStep.dart';

class AiModelsState {
  final bool isLoading;
  final List<AiModelSettingsDTO> allModels;
  final Map<TranslationPipelineStep, String> activeNameByStep;
  final String remainingTime;

  const AiModelsState({
    this.isLoading = true,
    this.allModels = const [],
    this.activeNameByStep = const {},
    this.remainingTime = '00:00:00',
  });

  AiModelsState copyWith({
    bool? isLoading,
    List<AiModelSettingsDTO>? allModels,
    Map<TranslationPipelineStep, String>? activeNameByStep,
    String? remainingTime,
  }) {
    return AiModelsState(
      isLoading: isLoading ?? this.isLoading,
      allModels: allModels ?? this.allModels,
      activeNameByStep: activeNameByStep ?? this.activeNameByStep,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}

class AiModelsNotifier extends StateNotifier<AiModelsState> {
  AiModelsNotifier() : super(const AiModelsState()) {
    _init();
  }

  final _aiModelManager = AiModelManager();
  Timer? _timer;

  static const int resetHourUTC = 0;

  Future<void> _init() async {
    await _loadData();
    _startTimer();
  }

  Future<void> _loadData() async {
    final allModels = await _aiModelManager.getAllModelsData();

    final Map<TranslationPipelineStep, String> activeNames = {};
    for (final step in TranslationPipelineStep.values) {
      activeNames[step] = await _aiModelManager.getActiveModelName(step.name);
    }

    state = state.copyWith(
      allModels: allModels,
      activeNameByStep: activeNames,
      isLoading: false,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  DateTime _nextResetTime(DateTime nowUtc) {
    DateTime resetTime = DateTime.utc(
      nowUtc.year,
      nowUtc.month,
      nowUtc.day,
      resetHourUTC,
    );
    if (!nowUtc.isBefore(resetTime)) {
      resetTime = resetTime.add(const Duration(days: 1));
    }
    return resetTime;
  }

  Future<void> _tick() async {
    final now = DateTime.now().toUtc();
    final resetTime = _nextResetTime(now);
    final remaining = resetTime.difference(now);

    if (remaining <= Duration.zero) {
      await _resetAllUsage();
      return;
    }

    state = state.copyWith(remainingTime: _formatDuration(remaining));
  }

  Future<void> _resetAllUsage() async {
    for (final model in aiModels) {
      await _aiModelManager.resetDailyUsage(model.name);
    }
    await _loadData();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return '00:00:00';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(duration.inHours)}:${two(duration.inMinutes.remainder(60))}:'
        '${two(duration.inSeconds.remainder(60))}';
  }

  Future<void> setActiveModel(TranslationPipelineStep step, String modelName) async {
    await _aiModelManager.setActiveModel(tag: step.name, modelName: modelName);
    state = state.copyWith(
      activeNameByStep: {
        ...state.activeNameByStep,
        step: modelName,
      },
    );
  }

  Future<void> refresh() => _loadData();

  Future<void> toggleStreaming(AiModelSettingsDTO model) async {
    final entry = _entryFor(model);
    if (!entry.supportsStreaming) return;

    final newValue = !model.currentStreamingEnabled;

    await _aiModelManager.setStreamingEnabled(model.name, newValue);

    state = state.copyWith(
      allModels: [
        for (final m in state.allModels)
          if (m.name == model.name)
            m.copyWith(
              currentStreamingEnabled: newValue,
              isStreamingCustom: true,
            )
          else
            m,
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final aiModelsProvider =
StateNotifierProvider<AiModelsNotifier, AiModelsState>((ref) {
  return AiModelsNotifier();
});

AiModelEntry _entryFor(AiModelSettingsDTO dto) {
  return aiModels.firstWhere(
        (e) => e.name == dto.name,
    orElse: () => aiModels.first,
  );
}

int _qualityRank(ModelQuality quality) {
  switch (quality) {
    case ModelQuality.frontier:
      return 3;
    case ModelQuality.high:
      return 2;
    case ModelQuality.standard:
      return 1;
    case ModelQuality.basic:
      return 0;
  }
}


bool _isModelAllowedForStep(AiModelEntry entry, TranslationPipelineStep step) {
  switch (step) {
    case TranslationPipelineStep.research:

      return entry.supportsWebSearch;

    case TranslationPipelineStep.translate:
      return true;

    case TranslationPipelineStep.parse:
      return true;
  }
}

final modelsForStepProvider =
Provider.family<List<AiModelSettingsDTO>, TranslationPipelineStep>((ref, step) {
  final allModels = ref.watch(aiModelsProvider).allModels;

  final filtered = allModels
      .where((dto) => _isModelAllowedForStep(_entryFor(dto), step))
      .toList();

  filtered.sort((a, b) {
    final rankA = _qualityRank(_entryFor(a).quality);
    final rankB = _qualityRank(_entryFor(b).quality);
    return rankB.compareTo(rankA); // спочатку кращі за якістю
  });

  return filtered;
});