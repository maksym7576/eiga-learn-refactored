

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../data/models/wordObject.dart';

class WordService extends StateNotifier<List<WordObject>> {
  final Isar db;

  WordService(this.db) : super([]);

  Future<void> createWord({required WordObject wordObject}) async {
    await db.writeTxn(() async {
      await db.wordObjects.put(wordObject);
      });
  }

  Future<List<WordObject>> getWordsBlocks(List<int> blockIds) async {
    return await db.wordObjects
        .filter()
        .anyOf(blockIds, (q, int id) => q.blockIdEqualTo(id))
        .findAll();
  }
}