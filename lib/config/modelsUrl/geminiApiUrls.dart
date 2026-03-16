

import 'package:shared_preferences/shared_preferences.dart';

class AiModelData {
  final String name;
  final String url;
  final int maxLimit;
  final int used;
  final DateTime? lastUpdated;

  AiModelData({
    required this.name,
    required this.url,
    required this.maxLimit,
    required this.used,
    this.lastUpdated,
});
}

class GeminiApiUrls {

  static const String _storageKey = 'selected_gemini_model';
  static const String _defaultModel = 'gemini-2.5-flash-lite';

  static const Map<String, String> _geminiUrls = {
    'gemini-2.5-flash-lite': 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
    'gemini-2.0-flash-lite': 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent',
    'gemini-2.5-flash': 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
  };

  static const Map<String, int> _defaultLimits = {
    //TODO MARK THE ACTUAL MODELS AND LIMITS
    'gemini-2.5-flash-lite': 15,
    'gemini-2.0-flash-lite': 20,
    'gemini-2.5-flash': 20,
  };

  static String _maxLimitKey(String model) => '${model}_max_limit';
  static String _usedKey(String model) => '${model}_used_count';
  static String _lastUpdatedKey(String model) => '${model}_last_updated';

  static Future<String> getUrl() async {
    final prefs = await SharedPreferences.getInstance();

    final currentModel = prefs.getString(_storageKey) ?? _defaultModel;
    return _geminiUrls[currentModel] ?? _geminiUrls[_defaultModel]!;
  }

  static Future<void> setModel(String modelKey) async {
    if (_geminiUrls.containsKey(modelKey)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, modelKey);
    } else {
      throw Exception('Did not set the modelKey: $modelKey');
    }
  }

  static Future<void> incrementUsage(String modelKey) async {
    _validateModel(modelKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, modelKey);
  }

  static Future<void> setMaxLimit(String modelKey, int limit) async {

  }

  static void _validateModel(String modelKey) {
    if (!_geminiUrls.containsKey(modelKey)) {
      throw Exception('Invalid modelKey: $modelKey');
    }
  }

  static List<String> getAvailableModes() {
    return _geminiUrls.keys.toList();
  }
}
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// class GeminiModelData {
//   final String name;
//   final String url;
//   final int maxLimit;
//   final int used;
//   final DateTime? lastUpdated;
//
//   GeminiModelData({
//     required this.name,
//     required this.url,
//     required this.maxLimit,
//     required this.used,
//     this.lastUpdated,
//   });
// }
//
// class GeminiApiUrls {
//   static const String _storageKey = 'selected_gemini_model';
//   static const String _defaultModel = 'gemini-2.5-flash-lite';
//
//   static const Map<String, String> _geminiUrls = {
//     'gemini-2.5-flash-lite': 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
//     'gemini-2.0-flash-lite': 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent',
//     'gemini-2.5-flash': 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
//   };
//
//   // Початкові ліміти (можна змінити під свої потреби)
//   static const Map<String, int> _defaultLimits = {
//     'gemini-2.5-flash-lite': 15,
//     'gemini-2.0-flash-lite': 15,
//     'gemini-2.5-flash': 50,
//   };
//
//   // Ключі для SharedPreferences
//   static String _maxLimitKey(String model) => '${model}_max_limit';
//   static String _usedKey(String model) => '${model}_used_count';
//   static String _lastUpdatedKey(String model) => '${model}_last_updated';
//
//   static Future<String> getUrl() async {
//     final prefs = await SharedPreferences.getInstance();
//     final currentModel = prefs.getString(_storageKey) ?? _defaultModel;
//     return _geminiUrls[currentModel] ?? _geminiUrls[_defaultModel]!;
//   }
//
//   static Future<void> setModel(String modelKey) async {
//     _validateModel(modelKey);
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_storageKey, modelKey);
//   }
//
//   /// Метод для реєстрації використання моделі (+1 до лічильника та оновлення дати)
//   static Future<void> incrementUsage(String modelKey) async {
//     _validateModel(modelKey);
//     final prefs = await SharedPreferences.getInstance();
//
//     int currentUsed = prefs.getInt(_usedKey(modelKey)) ?? 0;
//     await prefs.setInt(_usedKey(modelKey), currentUsed + 1);
//     await prefs.setString(_lastUpdatedKey(modelKey), DateTime.now().toIso8601String());
//   }
//
//   /// Встановлення власного ліміту для моделі
//   static Future<void> setMaxLimit(String modelKey, int limit) async {
//     _validateModel(modelKey);
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(_maxLimitKey(modelKey), limit);
//   }
//
//   /// Скидання лічильника
//   static Future<void> resetUsage(String modelKey) async {
//     _validateModel(modelKey);
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(_usedKey(modelKey), 0);
//     await prefs.setString(_lastUpdatedKey(modelKey), DateTime.now().toIso8601String());
//   }
//
//   /// НОВИЙ МЕТОД: Повертає список об'єктів з усіма даними по кожній моделі
//   static Future<List<GeminiModelData>> getAllModelsData() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<GeminiModelData> dataList = [];
//
//     for (var modelKey in _geminiUrls.keys) {
//       final maxLimit = prefs.getInt(_maxLimitKey(modelKey)) ?? _defaultLimits[modelKey] ?? 0;
//       final used = prefs.getInt(_usedKey(modelKey)) ?? 0;
//       final lastUpdatedStr = prefs.getString(_lastUpdatedKey(modelKey));
//
//       dataList.add(GeminiModelData(
//         name: modelKey,
//         url: _geminiUrls[modelKey]!,
//         maxLimit: maxLimit,
//         used: used,
//         lastUpdated: lastUpdatedStr != null ? DateTime.tryParse(lastUpdatedStr) : null,
//       ));
//     }
//
//     return dataList;
//   }
//
//   static void _validateModel(String modelKey) {
//     if (!_geminiUrls.containsKey(modelKey)) {
//       throw Exception('Invalid modelKey: $modelKey');
//     }
//   }
// }https://gemini.google.com/app/0ca3930c19e0d3e5

//TODO ДУЖЕ ВАЖЛИВО ЗРОБИТИ ЧАСТИНУ З РОБОТОЮ НАД МОДЕЛЛЮ ДАЛІ МОЖНА ІТИ РОБИТИ ФРОНТЕНД