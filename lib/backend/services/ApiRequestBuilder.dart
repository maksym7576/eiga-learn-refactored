import 'package:eiga/config/secureStorage.dart';
import '../../config/modelsUrl/AIModelsURLData.dart';
import '../../config/modelsUrl/AiModelManager.dart';

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
        bool? forceStreamingOverride,
      }) async {
    final tokenType = tokenTypeFor(model.provider);
    final token = await SecureTokenStorage.getToken(tokenType);

    final userWantsStreaming =
        forceStreamingOverride ?? await AiModelManager().isStreamingEnabled(model.name);
    final willStream = userWantsStreaming && model.supportsStreaming;

    final endpoint = willStream ? ':streamGenerateContent' : ':generateContent';
    final sse = willStream ? '&alt=sse' : '';

    final generatedUrl = '${model.url}$endpoint?key=$token$sse';

    // Виведення URL у логи
    print('API Request URL: $generatedUrl');

    return generatedUrl;
  }
}