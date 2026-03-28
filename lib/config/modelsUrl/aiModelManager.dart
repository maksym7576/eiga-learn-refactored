

import 'package:eiga/backend/data/dto/AIModelDataDTO.dart';
import 'package:eiga/config/modelsUrl/AIModelsURLData.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiModelManager {
    static const String _currentKey = 'current_ai_model';
    static const String _defaultModel = 'gemini-2.5-flash-lite';
    
    Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

    String _maxKey(String name) => '${name}_max_limit';
    String _usedKey(String name) => '${name}_used';
    String _updatedTimeKey(String name) => '${name}_last_updated';
    
    Future<String> getCurrentModelName() async {
      final pref = await prefs;
      return pref.getString(_currentKey) ?? _defaultModel;
    }
    
    Future<AiModelEntry> getCurrentModel() async {
      final name = await getCurrentModelName();
      return aiModels.firstWhere((element) => element.name == name, orElse: () => aiModels.first);
    }
    
    Future<void> setCurrentModel(String name) async {
      final pref = await prefs;
      await pref.setString(_currentKey, name);
    }
    
    Future<void> incrementUsage(String name) async {
      final pref = await prefs;
      final used = (pref.getInt(_usedKey(name)) ?? 0 + 1);
      await pref.setInt(_usedKey(name), used);
      await pref.setInt(_updatedTimeKey(name), DateTime.now().microsecondsSinceEpoch);
    }
    
    Future<void> setMaxLimit(String name, int value) async {
      final pref = await prefs;
      await pref.setInt(name, value);
    }
    
    Future<void> resetUsage(String name) async {
      final pref = await prefs;
      await pref.setInt(_usedKey(name), 0);
      await pref.setInt(_updatedTimeKey(name), DateTime.now().microsecondsSinceEpoch);
    }
    
    Future<AiModelDataDTO> getModelData(String name) async {
      final pref = await prefs;
      final entry = aiModels.firstWhere((element) => element.name == name, orElse: () => aiModels.first);
      final max = pref.getInt(_maxKey(name)) ?? entry.defaultLimit;
      final used = pref.getInt(_usedKey(name)) ?? 0;
      final updated = pref.getInt(_updatedTimeKey(name));
      return AiModelDataDTO(name: name, url: entry.url, maxLimit: max, used: used, lastUpdated: updated != null ? DateTime.fromMillisecondsSinceEpoch(updated): null);
    }

    Future<List<AiModelDataDTO>> getAllModelsData() async {
      List<AiModelDataDTO> result = [];
      for (final m in aiModels) {
        result.add(await getModelData(m.name));
      }
      return result;
    }

    Future<bool> isLimitReached(String name) async {
      final data = await getModelData(name);
      return data.used >= data.maxLimit;
    }

    Future<int> remainingUses(String name) async {
      final data = await getModelData(name);
      return data.maxLimit - data.used;
    }
}