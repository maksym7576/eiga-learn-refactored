
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage {

  static const _storage = FlutterSecureStorage();
  static const _geminiApiKeyStorageKey = 'gemini_api_key';

  static Future<String> getToken() async {
    final token = await _storage.read(key: _geminiApiKeyStorageKey);

    if(token == null || token.isEmpty) {
      throw Exception('Gemini API key not set in secure storage');
    }
    return token;
  }

  static Future<void> setToken(String apiKey) async {
    await _storage.write(key: _geminiApiKeyStorageKey, value: apiKey);
  }
}