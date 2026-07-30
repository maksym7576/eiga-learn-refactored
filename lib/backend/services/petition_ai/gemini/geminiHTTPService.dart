import 'dart:convert';
import 'package:eiga/providers/servicesProviders.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:eiga/backend/exeption/geminiException.dart';
import '../../../../providers/videoDataProviders.dart';
import '../../../data/models/videoObject.dart';
import '../parsers/PhraseResponseHandler.dart';

class GeminiHTTPService {
  final PhraseResponseHandler phraseResponseHandler;

  GeminiHTTPService({
    required this.phraseResponseHandler,
  });

  Future<void> fetchEpisodeContext(Ref ref, String url, String prompt) async {
    try {
      final String jsonString = await sendRequest(url, prompt);

      final jsonResponse = jsonDecode(jsonString);

      final VideoObject? video = await ref.read(currentVideoProvider.future);

      if (video != null) {
        video.isResearchDone = true;
        video.researchInformation = jsonResponse.toString();
        ref.read(videoServiceProvider.notifier).updateVideo(video);
      }

    } catch (error, stackTrace) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchTranslations(String url, String prompt) async {
    try {
      final String jsonString = await sendRequest(url, prompt);

      final Map<String, dynamic> jsonResponse = jsonDecode(jsonString);

      await phraseResponseHandler.saveTranslationsResponse(jsonResponse);

      return jsonResponse;
    } catch (error, stackTrace) {
      rethrow;
    }
  }

  Future<void> fetchParseAndSaveData(String url, String prompt) async {
    try {
      final String jsonResponse = await sendRequest(url, prompt);

      await phraseResponseHandler.processResponse(jsonResponse);

    } catch (error, stackTrace) {
      rethrow;
    }
  }

  Future<String> sendRequest(String url, String prompt) async {
    try {
      final Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      };

      final response = await http
          .post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      )
          .timeout(
        const Duration(seconds: 160),
        onTimeout: () {
          throw Exception("Gemini request time out");
        },
      );

      if (response.statusCode == 200) {
        final bodyText = response.body;
        if (bodyText.trim().isEmpty) {
          throw GeminiGeneralException("Empty response body from Gemini");
        }

        final data = jsonDecode(bodyText);
        if (data is Map && data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null &&
              candidate['content']['parts'].isNotEmpty) {
            String rawText = candidate['content']['parts'][0]['text'].toString();

            String cleanedResponse = rawText.replaceAll('```json', '').replaceAll('```', '').trim();

            return cleanedResponse;
          }
        }

        throw GeminiGeneralException("Unexpected response shape from Gemini: ${response.body}");
      } else {
        _handleHttpError(response);
        throw Exception("Unreachable code");
      }
    } catch (error, stackTrace) {
      rethrow;
    }
  }

  void _handleHttpError(http.Response response) {
    Map<String, dynamic> errorBody = {};
    try {
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) errorBody = decoded;
      }
    } catch (_) {}

    final errorMessage = (errorBody.isNotEmpty && errorBody['error'] != null)
        ? (errorBody['error']['message'] ?? 'Unknown error')
        : 'Unknown error';
    final int code = response.statusCode;

    if (code == 403 || code == 400) {
      throw GeminiIncorrectTokenException("Token is incorrect");
    } else if (code == 429) {
      throw GeminiModelExpiredException('Please change a model');
    } else if (code == 500 || code == 503 || code == 504) {
      throw GeminiServerException('Server error');
    } else {
      throw GeminiGeneralException('Request failed: $errorMessage');
    }
  }
}