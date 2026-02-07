import 'package:eiga/backend/data/models/languageObject.dart';
import 'package:eiga/backend/data/seeds/langeageSeeds.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

class LanguageService extends StateNotifier<List<LanguageObject>> {
  final Isar db;

  LanguageService(this.db) : super([]);

  Future<void> loadLanguages() async {
    state = await standardLanguages();
  }

  Future<List<LanguageObject>> findLanguagesByName(String languageName) async {
    final lowerCase = languageName.toLowerCase();
    final languages = await standardLanguages();

    return languages
        .where(
          (language) =>
              language.language != null &&
              language.language.toLowerCase().contains(lowerCase),
        )
        .toList();
  }
}
