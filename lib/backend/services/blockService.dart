


import 'package:eiga/backend/data/models/blockObject.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

class BlockService extends StateNotifier<List<BlockObject>> {
  final Isar db;

  BlockService(this.db) : super ([]);

  Future<int> createBlock({required BlockObject blockObject}) {
    return db.writeTxn(() => db.blockObjects.put(blockObject));
  }

  Future<List<BlockObject>> getBlocksForPhrase(int phraseId) async {
    return await db.blockObjects
        .filter()
        .phraseIdEqualTo(phraseId)
        .findAll();
  }

  Future<void> updateColorDirectly({required String contentSignature, required String newColorHex,}) async {
    await db.writeTxn(() async {
      final ids = await db.blockObjects
          .filter()
          .contentSignatureEqualTo(contentSignature)
          .idProperty()
          .findAll();

      if (ids.isEmpty) return;

    await db.blockObjects.putAll(
      ids.map((id) => BlockObject()..id = id..colorHex = newColorHex).toList(),
    );
    });
  }
}