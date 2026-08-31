import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:isar_community/isar.dart';

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
  }

  Future<void> addPhrasesList(List<PhraseObject> phraseList) async {
    await db.writeTxn(() async {
      await db.phraseObjects.putAll(phraseList);
    });
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

  Future<void> shiftPhrasesTimeByVideoId(int videoId, Duration millisecondsOffset) async {
    await db.writeTxn(() async {
      final phrases = await db.phraseObjects
          .filter()
          .videoIdEqualTo(videoId)
          .findAll();

      if (phrases.isNotEmpty) {
        for (var phrase in phrases) {
          if (phrase.startTime != null) {
            phrase.startTime = phrase.startTime!.add(millisecondsOffset);
          }
          if (phrase.endTime != null) {
            phrase.endTime = phrase.endTime!.add(millisecondsOffset);
          }
        }
        await db.phraseObjects.putAll(phrases);
      }
    });
  }

  Future<void> shiftPhraseTimeById(int phraseId, Duration millisecondsOffset) async {
    await db.writeTxn(() async {
      final phrase = await db.phraseObjects.get(phraseId);
      if (phrase != null) {
        if (phrase.startTime != null) {
          phrase.startTime = phrase.startTime!.add(millisecondsOffset);
        }
        if (phrase.endTime != null) {
          phrase.endTime = phrase.endTime!.add(millisecondsOffset);
        }
        await db.phraseObjects.put(phrase);
      }
    });
  }

  Future<void> updateTranslatedPhraseText(int phraseId, String translatedText) async {
    await db.writeTxn(() async {
      final phrase = await db.phraseObjects.get(phraseId);
      if (phrase != null) {
        phrase.translatedPhrase = translatedText;
        phrase.isTranslated = false;
        phrase.isTranslating = true;
        await db.phraseObjects.put(phrase);
      }
    });
  }

  Future<void> resetPhrasesTranslationStatus(List<PhraseObject> phrases) async {
    await db.writeTxn(() async {
      for (var phrase in phrases) {
        phrase.isTranslating = false;
        phrase.translatedPhrase = null;
        phrase.isTranslated = false;
      }
      await db.phraseObjects.putAll(phrases);
    });
  }

  Future<void> resetPhrasesTranslationStatusByIds(List<int> phraseIds) async {
    await db.writeTxn(() async {
      for (var id in phraseIds) {
        final phrase = await db.phraseObjects.get(id);
        if (phrase != null) {
          phrase.isTranslating = false;
          phrase.translatedPhrase = null;
          phrase.isTranslated = false;
          await db.phraseObjects.put(phrase);
        }
      }
    });
  }

}
