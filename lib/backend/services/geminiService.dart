import 'dart:convert';
import 'dart:io';
import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:eiga/backend/data/models/wordObject.dart';
import 'package:eiga/backend/exeption/geminiException.dart';
import 'package:eiga/backend/services/blockService.dart';
import 'package:eiga/backend/services/phraseService.dart';
import 'package:eiga/backend/services/wordService.dart';
import 'package:http/http.dart' as http;
import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:eiga/config/modelsUrl/geminiApiUrls.dart';
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
    final baseUrl = await GeminiApiUrls.getUrl();
    final token = await SecureTokenStorage.getToken();

    return '$baseUrl?key=$token';
  }

  Future<String> _formPrompt(List<PhraseObject> phraseObjectsList,
      String originalLanguage, String translationLanguage) async {
    final String prompt = PromptManager.getPromptByLanguage(
        originalLanguage, translationLanguage);
    final sortPhraseList = List<PhraseObject>.from(phraseObjectsList)
      ..sort((a, b) => (a.phraseOrder ?? 0).compareTo(b.phraseOrder ?? 0));
    final simplifiedPhrasesList = sortPhraseList.map((phrase) =>
    {
      'id': phrase.id,
      'text': phrase.originalPhrase ?? '',
    }).toList();

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
            {"text": prompt}
          ]
        }
      ],
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null &&
          data['candidates'][0]['content'] != null) {
        return data['candidates'][0]['content']['parts'][0]['text'];
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

  Future<void> translatePhraseList({required List<PhraseObject> phraseObjectsList, required originalLanguage, required String translationLanguage}) async {
    int attempts = 0;
    const int maxRetries = 1;

    while (true) {
      try {
        attempts++;
        final String fullUrl = await _formToken();
        final String promptWithPhrases = await _formPrompt(
            phraseObjectsList, originalLanguage, translationLanguage);
        final result = await _sendGeminiRequest(fullUrl, promptWithPhrases);
        await geminiResponseParse(result);
      } catch (error) {
        if (error is GeminiGeneralException ||
            error is GeminiModelExpiredException ||
            error is GeminiIncorrectTokenException) {
          rethrow;
        }

        bool isRetryable = error is GeminiServerException ||
            error is http.ClientException;

        if (isRetryable && attempts <= maxRetries) {
          await Future.delayed(Duration(seconds: 2));
        } else {
          throw Exception("Failed after $attempts");
        }
      }
    }
  }

  Future<void> geminiResponseParse(String jsonResponse) async {
     final List<dynamic> phrasesJsonData = jsonDecode(jsonResponse);

     for (var phrasesData in phrasesJsonData) {
       final int phraseIdFromGemini = phrasesData['phraseId'];
       final phrase = await phraseService.getPhraseById(phraseIdFromGemini);

       if (phrase == null) continue;

       final List<dynamic> blocksDataJson = phrasesData['blocks'];

     for (var blockData in blocksDataJson) {
       final newBlock = BlockObject(
         phraseId: phraseIdFromGemini,
         blockTranslation: blockData['tr'],
         translatedPositionIndex: List<int>.from(blockData['tr_pos']),
         blockPositionIndex: blockData['b_pos'],
         contentSignature: blockData['tr'].hashCode.toString(),
         colorHex: "#FFFFFF",
       );
       final blockId = await blockService.createBlock(blockObject: newBlock);

       final List<dynamic> wordDataJson = blockData['word'];

       for (var wordData in wordDataJson) {
        final Map<String, dynamic> map = Map<String, dynamic>.from(wordData);
        
        final newWord = WordObject(blockId: blockId)
        ..wordPosition = map['w_pos'] as int?
        ..versions = map.entries
        .where((entries) => entries.key != 'w_pos')
        .where((entries) => entries.value != null && entries.value.toString().isNotEmpty)
        .map((entries) => ReadingItem(
            key: entries.key,
            text: entries.value.toString(),
        ))
        .toList();
        
        await wordService.createWord(wordObject: newWord);
       }
     }
     await phraseService.markAsTranslated(phraseIdFromGemini);
     }
  }
}