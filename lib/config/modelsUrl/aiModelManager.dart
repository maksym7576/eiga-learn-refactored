import 'package:eiga/backend/data/dto/AIModelDataDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiModelManager {
  static const String _defaultModel = 'gemini-2.5-flash-lite';

  Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

  String _activeModelKey(String tag) => 'active_model_$tag';

  String _maxKey(String name) => '${name}_max_limit';
  String _usedKey(String name) => '${name}_used';
  String _updatedTimeKey(String name) => '${name}_last_updated';
  String _phrasesPerRequestKey(String name) => '${name}_phrases_per_request';

  String _dailyMaxKey(String name) => '${name}_daily_max_limit';
  String _dailyUsedKey(String name) => '${name}_daily_used';
  String _dailyDateKey(String name) => '${name}_daily_date';

  String _streamingEnabledKey(String name) => '${name}_streaming_enabled';

  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  AiModelEntry _entryOf(String name) {
    return aiModels.firstWhere(
          (element) => element.name == name,
      orElse: () => aiModels.first,
    );
  }

  Future<String> getActiveModelName(String tag) async {
    final pref = await prefs;
    return pref.getString(_activeModelKey(tag)) ?? _defaultModel;
  }

  Future<AiModelEntry> getActiveModel(String tag) async {
    final name = await getActiveModelName(tag);
    return _entryOf(name);
  }

  Future<void> setActiveModel({required String tag, required String modelName}) async {
    final pref = await prefs;
    await pref.setString(_activeModelKey(tag), modelName);
  }

  // --- Стрімінг ---

  /// Чи увімкнений стрімінг для моделі [name].
  /// Якщо модель взагалі не підтримує стрімінг (AiModelEntry.supportsStreaming
  /// == false) — завжди повертає false, незалежно від збереженого значення.
  Future<bool> isStreamingEnabled(String name) async {
    final entry = _entryOf(name);
    if (!entry.supportsStreaming) return false;

    final pref = await prefs;
    // За замовчуванням: якщо модель вміє стрімити — стрімінг увімкнений.
    return pref.getBool(_streamingEnabledKey(name)) ?? true;
  }

  /// Вмикає/вимикає стрімінг для моделі [name].
  /// Якщо модель не підтримує стрімінг — виклик ігнорується.
  Future<void> setStreamingEnabled(String name, bool value) async {
    final entry = _entryOf(name);
    if (!entry.supportsStreaming) return;

    final pref = await prefs;
    await pref.setBool(_streamingEnabledKey(name), value);
  }

  /// Перемкнути поточний стан стрімінгу на протилежний.
  /// Повертає нове значення (або null, якщо модель не підтримує стрімінг).
  Future<bool?> toggleStreaming(String name) async {
    final entry = _entryOf(name);
    if (!entry.supportsStreaming) return null;

    final current = await isStreamingEnabled(name);
    final next = !current;
    await setStreamingEnabled(name, next);
    return next;
  }

  // --- Використання ---

  Future<void> incrementUsage(String name) async {
    final pref = await prefs;
    final nowTime = DateTime.now().millisecondsSinceEpoch;

    final used = (pref.getInt(_usedKey(name)) ?? 0) + 1;
    await pref.setInt(_usedKey(name), used);
    await pref.setInt(_updatedTimeKey(name), nowTime);

    final today = _getTodayString();
    final savedDay = pref.getString(_dailyDateKey(name));

    if (savedDay == today) {
      final dailyUsed = (pref.getInt(_dailyUsedKey(name)) ?? 0) + 1;
      await pref.setInt(_dailyUsedKey(name), dailyUsed);
    } else {
      await pref.setInt(_dailyUsedKey(name), 1);
      await pref.setString(_dailyDateKey(name), today);
    }
  }

  Future<void> setMaxLimit(String name, int value) async {
    if (value < 1) return;
    final pref = await prefs;
    await pref.setInt(_maxKey(name), value);
  }

  Future<void> setDailyMaxLimit(String name, int value) async {
    if (value < 1) return;
    final pref = await prefs;
    await pref.setInt(_dailyMaxKey(name), value);
  }

  Future<void> setPhrasesPerRequest(String name, int value) async {
    if (value < 1) return;
    final pref = await prefs;
    await pref.setInt(_phrasesPerRequestKey(name), value);
  }

  Future<int> getPhrasesPerRequest(String name) async {
    final pref = await prefs;
    final entry = _entryOf(name);
    return pref.getInt(_phrasesPerRequestKey(name)) ?? entry.defaultPhrasesPerRequest;
  }

  Future<void> resetUsage(String name) async {
    final pref = await prefs;
    await pref.setInt(_usedKey(name), 0);
    await pref.setInt(_updatedTimeKey(name), DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> resetDailyUsage(String name) async {
    final pref = await prefs;
    await pref.setInt(_dailyUsedKey(name), 0);
    await pref.setString(_dailyDateKey(name), _getTodayString());
  }

  // --- DTO ---

  Future<AiModelDataDTO> getModelData(String name) async {
    final pref = await prefs;
    final entry = _entryOf(name);

    final max = pref.getInt(_maxKey(name)) ?? entry.defaultLimit;
    final used = pref.getInt(_usedKey(name)) ?? 0;
    final updated = pref.getInt(_updatedTimeKey(name));
    final phrasesPerRequest = pref.getInt(_phrasesPerRequestKey(name)) ?? entry.defaultPhrasesPerRequest;
    final streamingEnabled = await isStreamingEnabled(name);

    return AiModelDataDTO(
      name: name,
      url: entry.url,
      maxLimit: max,
      used: used,
      phrasesPerRequest: phrasesPerRequest,
      lastUpdated: updated != null ? DateTime.fromMillisecondsSinceEpoch(updated) : null,
      isStreamingEnabled: streamingEnabled,
    );
  }

  Future<List<AiModelDataDTO>> getAllModelsData() async {
    List<AiModelDataDTO> result = [];

    for (final m in aiModels) {
      result.add(await getModelData(m.name));
    }

    return result;
  }

  // --- Перевірки ---

  Future<bool> isLimitReached(String name) async {
    final data = await getModelData(name);
    return data.used >= data.maxLimit;
  }

  Future<bool> isDailyLimitReached(String name) async {
    final pref = await prefs;
    final entry = _entryOf(name);

    final savedDay = pref.getString(_dailyDateKey(name));
    if (savedDay != _getTodayString()) return false;

    final dailyUsed = pref.getInt(_dailyUsedKey(name)) ?? 0;
    final dailyMax = pref.getInt(_dailyMaxKey(name)) ?? entry.defaultLimit;

    return dailyUsed >= dailyMax;
  }

  Future<int> remainingUses(String name) async {
    final data = await getModelData(name);
    return data.maxLimit - data.used;
  }

  Future<int> remainingDailyUses(String name) async {
    final pref = await prefs;
    final entry = _entryOf(name);

    final dailyMax = pref.getInt(_dailyMaxKey(name)) ?? entry.defaultLimit;
    final savedDay = pref.getString(_dailyDateKey(name));

    if (savedDay != _getTodayString()) return dailyMax;

    final dailyUsed = pref.getInt(_dailyUsedKey(name)) ?? 0;
    return dailyMax - dailyUsed;
  }
}