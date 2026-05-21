import 'dart:convert';
import 'dart:io';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/exeption/geminiException.dart';
import 'package:eiga/backend/services/models_services/blockService.dart';
import 'package:eiga/backend/services/models_services/phraseService.dart';
import 'package:eiga/backend/services/models_services/wordService.dart';
import 'package:http/http.dart' as http;
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/config/modelsUrl/aiModelManager.dart';
import 'package:eiga/config/prompts/promptManager.dart';
import 'package:eiga/config/secureStorage.dart';

class GeminiService {
  final PhraseService phraseService;
  final BlockService blockService;
  final WordService wordService;

  GeminiService({
    required this.phraseService,
    required this.blockService,
    required this.wordService,
  });

  Future<String> _formToken() async {
    final aiModelManager = AiModelManager();
    final model = await aiModelManager.getCurrentModel();
    final baseUrl = model.url;
    final token = await SecureTokenStorage.getToken();

    return '$baseUrl?key=$token';
  }

  Future<String> _formPrompt(
    List<PhraseObject> phraseObjectsList,
    String originalLanguage,
    String translationLanguage,
  ) async {
    final String prompt = PromptManager.getPromptByLanguage(
      originalLanguage,
      translationLanguage,
    );
    print('languange $originalLanguage');
    print('prompt $prompt');
    final sortPhraseList = List<PhraseObject>.from(phraseObjectsList)
      ..sort((a, b) => (a.phraseOrder ?? 0).compareTo(b.phraseOrder ?? 0));
    final simplifiedPhrasesList = sortPhraseList
        .map((phrase) => {'id': phrase.id, 'text': phrase.originalPhrase ?? ''})
        .toList();

    final String jsonData = jsonEncode(simplifiedPhrasesList);

    return """
    $prompt
    INPUT DATA (JSON Format):
    $jsonData
    """;
  }

  Future<String> _sendGeminiRequest(String url, String prompt) async {
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
          Duration(seconds: 160),
          onTimeout: () {
            throw Exception("Gemini request time out");
          },
        );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null &&
          data['candidates'][0]['content'] != null) {
        String cleanedResponse =
            data['candidates'][0]['content']['parts'][0]['text']
                .toString()
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();

        return cleanedResponse;
      } else {
        throw GeminiGeneralException("Empty response from Gemini");
      }
    } else {
      final errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error']['message'] ?? 'Unknown error';
      final int code = response.statusCode;

      if (code == 403 || code == 400) {
        throw GeminiIncorrectTokenException("Token does not correct");
      }

      if (code == 429) {
        throw GeminiModelExpiredException('Please change a model');
      }

      if (code == 500 || code == 503 || code == 504) {
        throw GeminiServerException('Server error');
      }

      throw GeminiGeneralException('Request failed $errorMessage');
    }
  }

  Future<void> translatePhraseList({
    required List<PhraseObject> phraseObjectsList,
    required originalLanguage,
    required String translationLanguage,
  }) async {
    int attempts = 0;
    const int maxRetries = 1;

    while (true) {
      try {
        attempts++;
        final String fullUrl = await _formToken();
        final String promptWithPhrases = await _formPrompt(
          phraseObjectsList,
          originalLanguage,
          translationLanguage,
        );
        final result = await _sendGeminiRequest(fullUrl, promptWithPhrases);
        await geminiResponseParse(result);
      } catch (error) {
        if (error is GeminiGeneralException ||
            error is GeminiModelExpiredException ||
            error is GeminiIncorrectTokenException) {
          rethrow;
        }

        bool isRetryable =
            error is GeminiServerException || error is http.ClientException;

        if (isRetryable && attempts <= maxRetries) {
          await Future.delayed(Duration(seconds: 2));
        } else {
          throw Exception("Failed after $attempts");
        }
      }
    }
  }

  List<BlockObject> deduplicateBlocks(List<dynamic> rawBlocks) {
    final Map<int, BlockObject> unique = {};

    for (var block in rawBlocks) {
      final phraseId = block['phraseId'] as int;
      final bPos = block['blockPositionIndex'] as int;
      final signature = block['contentSignature'] as String;

      final key = phraseId * 1000 + bPos;

      if (!unique.containsKey(key)) {
        unique[key] = BlockObject(
          phraseId: phraseId,
          blockPositionIndex: bPos,
          blockTranslation: block['blockTranslation'],
          translatedPositionIndex: List<int>.from(
            block['translatedPositionIndex'],
          ),
          contentSignature: signature,
          colorHex: block['colorHex'],
        );
      }
    }

    return unique.values.toList()..sort(
      (a, b) => a.phraseId!.compareTo(b.phraseId!) != 0
          ? a.phraseId!.compareTo(b.phraseId!)
          : a.blockPositionIndex!.compareTo(b.blockPositionIndex!),
    );
  }

  Future<void> geminiResponseParse(String jsonResponse) async {
    print('response $jsonResponse');
    final List<dynamic> phrasesJsonData = jsonDecode(jsonResponse);

    final allRawBlocks = <dynamic>[];
    for (var phrasesData in phrasesJsonData) {
      allRawBlocks.addAll(phrasesData['blocks'] as List<dynamic>);
    }

    final cleanedBlocks = deduplicateBlocks(allRawBlocks);

    final Map<int, List<BlockObject>> blocksByPhrase = {};
    for (var block in cleanedBlocks) {
      blocksByPhrase.putIfAbsent(block.phraseId!, () => []).add(block);
    }
    for (var phraseId in blocksByPhrase.keys) {
      final phrase = await phraseService.getPhraseById(phraseId);
      if (phrase == null) continue;

      final blocksDataJson = blocksByPhrase[phraseId]!;

      for (var blockData in blocksDataJson) {
        final newBlock = BlockObject(
          phraseId: phraseId,
          blockTranslation: blockData.blockTranslation,
          translatedPositionIndex: blockData.translatedPositionIndex!,
          blockPositionIndex: blockData.blockPositionIndex,
          contentSignature: blockData.contentSignature,
          colorHex: "#FFFFFF",
        );
        final blockId = await blockService.createBlock(blockObject: newBlock);
      }

      await phraseService.markAsTranslatedAndMarkNotTranslating(phraseId);
    }
  }
}
