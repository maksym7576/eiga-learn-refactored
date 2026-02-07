

import 'package:eiga/backend/data/models/languageObject.dart';

Future<List<LanguageObject>> standardLanguages() async {
  return [
    LanguageObject(id: 1, language: 'English', isSupported: true),
    LanguageObject(id: 2, language: 'Japanese', isSupported: true),
    LanguageObject(id: 3, language: 'Spanish', isSupported: false),
  ];
}
