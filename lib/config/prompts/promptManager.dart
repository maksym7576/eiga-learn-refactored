


import 'package:eiga/config/prompts/defaultPrompt.dart';
import 'package:eiga/config/prompts/japanesePrompt.dart';

class PromptManager {
  static String getPromptByLanguage(String sourceLanguage, String targetLanguage) {
    String template;

    switch (sourceLanguage.toLowerCase()) {
      case 'japanese':
        template = japanesePrompt;
        print('prompt japanese');
        break;
      default:
        template = defaultPrompt;
        print('prompt default');
        break;
    }

    return template
        .replaceAll('{SOURCE_LANGUAGE}', sourceLanguage)
        .replaceAll('{TARGET_LANGUAGE', targetLanguage);
  }
}