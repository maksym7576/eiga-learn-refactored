

import 'package:shared_preferences/shared_preferences.dart';

class GeminiApiUrls {

  static const String _storageKey = 'selected_gemini_model';
  static const String _defaultModel = 'gemini-2.5-flash-lite';

  static const Map<String, String> _geminiUrls = {
    'gemini-2.5-flash-lite': 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
    'gemini-2.0-flash-lite': 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-lite:generateContent',
    'gemini-2.5-flash': 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent',
  };

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

  static List<String> getAvailableModes() {
    return _geminiUrls.keys.toList();
  }
}