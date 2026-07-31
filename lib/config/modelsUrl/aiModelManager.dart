import 'package:eiga/backend/data/dto/AiModelSettingsDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
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

  Future<String> getCurrentModelName() async {
    return await getActiveModelName('active');
  }

  Future<void> setCurrentModel(String name) async {
    await setActiveModel(tag: 'active', modelName: name);
  }

  Future<void> setActiveModel({required String tag, required String modelName}) async {
    final pref = await prefs;
    await pref.setString(_activeModelKey(tag), modelName);
  }

  // --- Стрімінг ---

  Future<bool> isStreamingEnabled(String name) async {
    final entry = _entryOf(name);
    if (!entry.supportsStreaming) return false;

    final pref = await prefs;
    return pref.getBool(_streamingEnabledKey(name)) ?? true;
  }

  Future<void> setStreamingEnabled(String name, bool value) async {
    final entry = _entryOf(name);
    if (!entry.supportsStreaming) return;

    final pref = await prefs;
    await pref.setBool(_streamingEnabledKey(name), value);
  }

  Future<bool?> toggleStreaming(String name) async {
    final entry = _entryOf(name);
    if (!entry.supportsStreaming) return null;

    final current = await isStreamingEnabled(name);
    final next = !current;
    await setStreamingEnabled(name, next);
    return next;
  }

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

  // --- Скидання кастомних налаштувань до дефолту ---

  Future<void> resetMaxLimitToDefault(String name) async {
    final pref = await prefs;
    await pref.remove(_maxKey(name));
  }

  Future<void> resetDailyMaxLimitToDefault(String name) async {
    final pref = await prefs;
    await pref.remove(_dailyMaxKey(name));
  }

  Future<void> resetPhrasesPerRequestToDefault(String name) async {
    final pref = await prefs;
    await pref.remove(_phrasesPerRequestKey(name));
  }

  Future<void> resetStreamingToDefault(String name) async {
    final pref = await prefs;
    await pref.remove(_streamingEnabledKey(name));
  }

  // --- DTO ---

  Future<AiModelSettingsDTO> getModelData(String name) async {
    final pref = await prefs;
    final entry = _entryOf(name);

    // --- max limit ---
    final storedMax = pref.getInt(_maxKey(name));
    final currentMax = storedMax ?? entry.defaultLimit;

    // --- daily max limit ---
    final storedDailyMax = pref.getInt(_dailyMaxKey(name));
    final currentDailyMax = storedDailyMax ?? entry.defaultLimit;

    // --- phrases per request ---
    final storedPhrases = pref.getInt(_phrasesPerRequestKey(name));
    final currentPhrases = storedPhrases ?? entry.defaultPhrasesPerRequest;

    // --- streaming ---
    final storedStreaming = pref.getBool(_streamingEnabledKey(name));
    final defaultStreaming = entry.supportsStreaming;
    final currentStreaming = await isStreamingEnabled(name);

    final used = pref.getInt(_usedKey(name)) ?? 0;
    final dailyUsed = pref.getInt(_dailyUsedKey(name)) ?? 0;
    final updated = pref.getInt(_updatedTimeKey(name));

    return AiModelSettingsDTO(
      name: name,
      url: entry.url,
      currentMaxLimit: currentMax,
      defaultMaxLimit: entry.defaultLimit,
      isMaxLimitCustom: storedMax != null,
      used: used,
      currentDailyMaxLimit: currentDailyMax,
      defaultDailyMaxLimit: entry.defaultLimit,
      isDailyMaxLimitCustom: storedDailyMax != null,
      dailyUsed: dailyUsed,
      currentPhrasesPerRequest: currentPhrases,
      defaultPhrasesPerRequest: entry.defaultPhrasesPerRequest,
      isPhrasesPerRequestCustom: storedPhrases != null,
      currentStreamingEnabled: currentStreaming,
      defaultStreamingEnabled: defaultStreaming,
      isStreamingCustom: storedStreaming != null,
      lastUpdated: updated != null ? DateTime.fromMillisecondsSinceEpoch(updated) : null,
    );
  }

  Future<List<AiModelSettingsDTO>> getAllModelsData() async {
    List<AiModelSettingsDTO> result = [];

    for (final m in aiModels) {
      result.add(await getModelData(m.name));
    }

    return result;
  }

  // --- Перевірки ---

  Future<bool> isLimitReached(String name) async {
    final data = await getModelData(name);
    return data.used >= data.currentMaxLimit;
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
    return data.currentMaxLimit - data.used;
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