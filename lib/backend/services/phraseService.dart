import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:isar/isar.dart';

class PhraseService {
  final Isar db;

  PhraseService(this.db);


  Stream<List<PhraseObject>> watchPhrasesByVideoId(int videoId) {
    return db.phraseObjects
        .filter()
        .videoIdEqualTo(videoId)
        .sortByPhraseOrder()
        .watch(fireImmediately: true);
  }

  Future<List<PhraseObject>> getPhrasesByVideoId(int videoId) async {
    return await db.phraseObjects
        .where()
        .filter()
        .videoIdEqualTo(videoId)
        .findAll();
  }

  Future<PhraseObject?> getPhraseById(int id) async {
    return await db.phraseObjects.get(id);
  }

  Future<void> addPhrase(PhraseObject phraseObject) async {
    await db.writeTxn(() async {
      await db.phraseObjects.put(phraseObject);
    });
    await getPhrasesByVideoId(phraseObject.videoId!);
  }

  Future<void> markAsTranslatedAndMarkNotTranslating(int phraseId) async {
    await db.writeTxn(() async {
      final phrase = await db.phraseObjects.get(phraseId);
      if(phrase != null) {
        phrase.isTranslated = true;
        phrase.isTranslating = false;
        await db.phraseObjects.put(phrase);
      }
    });
  }

  Future<void> resetAllTranslatingStatuses() async {
    await db.writeTxn(() async {
      final stuckPhrases = await db.phraseObjects
          .filter()
          .isTranslatingEqualTo(true)
          .findAll();
      for (var phrase in stuckPhrases) {
        phrase.isTranslating = false;
        await db.phraseObjects.put(phrase);
      }
    });
  }

  Future<void> markPhrasesAsTranslatingByPhraseList(List<PhraseObject> phrases) async {
    await db.writeTxn(() async {
      for (var phrase in phrases) {
        phrase.isTranslating = true;
      }
      await db.phraseObjects.putAll(phrases);
    });
  }
}