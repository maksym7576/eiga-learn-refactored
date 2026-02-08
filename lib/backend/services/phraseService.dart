

import 'package:eiga/backend/data/models/phraseObject.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

class PhraseService extends StateNotifier<List<PhraseObject>> {
  final Isar db;

  PhraseService(this.db) : super ([]);

  Future<void> getPhrasesByVideoId(int videoId) async {
    final phrases = await db.phraseObjects
        .where()
        .filter()
        .videoIdEqualTo(videoId)
        .findAll();

    state = phrases;
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

  Future<void> markAsTranslated(int phraseId) async {
    await db.writeTxn(() async {
      final phrase = await db.phraseObjects.get(phraseId);
      if(phrase != null) {
        phrase.isTranslated = true;
        await db.phraseObjects.put(phrase);
      }
    });
  }
}