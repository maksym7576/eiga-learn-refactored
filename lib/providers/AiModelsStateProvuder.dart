import 'dart:async';

import 'package:eiga/backend/data/dto/AIModelDataDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
import 'package:eiga/config/modelsUrl/aiModelManager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config/modelsUrl/TranslationPipelineStep.dart';

// TODO: якщо TranslationPipelineStep лежить в окремому файлі — імпортуйте
// його тут явно. Я припускаю, що він доступний через один із імпортів вище
// (як і у вашому оригінальному ModelPreviewWidget).

/// Стан усіх AI-моделей: список даних по моделях, яка модель активна
/// на кожному кроці пайплайну, скільки лишилось до ресету лімітів.
class AiModelsState {
  final bool isLoading;
  final List<AiModelDataDTO> allModels;
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
    List<AiModelDataDTO>? allModels,
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

  /// О котрій годині UTC відбувається щоденний ресет лімітів.
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
    _tick(); // одразу порахувати, не чекаючи першої секунди
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
      // Дійшли до нуля — це те, чого не вистачало в оригіналі: реально
      // скидаємо використання і одразу перезавантажуємо дані моделей.
      await _resetAllUsage();
      return;
    }

    state = state.copyWith(remainingTime: _formatDuration(remaining));
  }

  Future<void> _resetAllUsage() async {
    for (final model in aiModels) {
      await _aiModelManager.resetDailyUsage(model.name);
      // Якщо треба скидати ще й загальний (не денний) ліміт — розкоментуйте:
      // await _aiModelManager.resetUsage(model.name);
    }
    await _loadData();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return '00:00:00';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(duration.inHours)}:${two(duration.inMinutes.remainder(60))}:'
        '${two(duration.inSeconds.remainder(60))}';
  }

  /// Змінити активну модель для конкретного кроку пайплайну.
  Future<void> setActiveModel(TranslationPipelineStep step, String modelName) async {
    await _aiModelManager.setActiveModel(tag: step.name, modelName: modelName);
    state = state.copyWith(
      activeNameByStep: {
        ...state.activeNameByStep,
        step: modelName,
      },
    );
  }

  /// Ручне оновлення даних (напр. pull-to-refresh).
  Future<void> refresh() => _loadData();

  /// Перемкнути стрімінг для конкретної моделі (research/translate/parse-
  /// незалежний, це властивість самої моделі, а не кроку).
  /// Якщо модель не підтримує стрімінг — нічого не робить.
  Future<void> toggleStreaming(AiModelDataDTO model) async {
    final entry = _entryFor(model);
    if (!entry.supportsStreaming) return;

    await _aiModelManager.setStreamingEnabled(
      model.name,
      !model.isStreamingEnabled,
    );

    state = state.copyWith(
      allModels: [
        for (final m in state.allModels)
          if (m.name == model.name)
            m.copyWith(isStreamingEnabled: !model.isStreamingEnabled)
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

AiModelEntry _entryFor(AiModelDataDTO dto) {
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

/// ⚠️ ГОЛОВНЕ МІСЦЕ ДЛЯ ПРАВИЛ ФІЛЬТРАЦІЇ ПО КРОКАХ.
///
/// Додайте сюди `case` для кожного кроку, де є обмеження на моделі.
/// Кроки, яких тут немає, проходять без фільтрації (гілка `default`).
bool _isModelAllowedForStep(AiModelEntry entry, TranslationPipelineStep step) {
  switch (step) {
    case TranslationPipelineStep.research:
    // displayName цього кроку — 'Analyze'. Аналіз потребує виходу
    // в інтернет — моделі без web search відсіюємо.
      return entry.supportsWebSearch;

    case TranslationPipelineStep.translate:
      return true;

    case TranslationPipelineStep.parse:
      return true;
  }
}

/// Відфільтрований і відсортований (найкраща якість — першою) список
/// моделей для конкретного кроку. Реактивний: перебудується сам, щойно
/// зміниться [aiModelsProvider] (наприклад, після щоденного ресету).
final modelsForStepProvider =
Provider.family<List<AiModelDataDTO>, TranslationPipelineStep>((ref, step) {
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