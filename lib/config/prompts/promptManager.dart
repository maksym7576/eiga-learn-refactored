


import 'package:eiga/config/prompts/defaultPrompt.dart';
import 'package:eiga/config/prompts/japanesePrompt.dart';

class PromptManager {
  static String getPromptByLanguage(String sourceLanguage, String targetLanguage) {
    String template;

    switch (targetLanguage.toLowerCase()) {
      case 'japanese':
        template = japanesePrompt;
        break;
      default:
        template = defaultPrompt;
        break;
    }

    return template
        .replaceAll('{SOURCE_LANGUAGE}', sourceLanguage)
        .replaceAll('{TARGET_LANGUAGE', targetLanguage);
  }
}