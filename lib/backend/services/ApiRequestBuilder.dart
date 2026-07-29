import 'package:eiga/config/secureStorage.dart';
import '../../config/modelsUrl/AIModelsURLData.dart';

class ApiRequestBuilder {
  static ApiTokenType tokenTypeFor(AiProvider provider) {
    switch (provider) {
      case AiProvider.google:
        return ApiTokenType.gemeni;
      default:
        throw Exception('No ApiTokenType mapped for provider: $provider');
    }
  }

  static Future<String> buildUrl(
      AiModelEntry model, {
        required bool isStreaming,
      }) async {
    final tokenType = tokenTypeFor(model.provider);
    final token = await SecureTokenStorage.getToken(tokenType);

    final bool willStream = isStreaming && model.supportsStreaming;
    final endpoint = willStream ? ':streamGenerateContent' : ':generateContent';
    final sse = willStream ? '&alt=sse' : '';

    return '${model.url}$endpoint?key=$token$sse';
  }
}