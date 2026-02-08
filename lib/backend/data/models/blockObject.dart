import 'package:isar/isar.dart';

part 'blockObject.g.dart';

@collection
class BlockObject {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  int? phraseId;

  int? blockPositionIndex;

  List<int> translatedPositionIndex = [];

  String? blockTranslation;

  @Index(type: IndexType.hash)
  String? contentSignature;

  String? colorHex;

  BlockObject({
    this.phraseId,
    this.blockPositionIndex,
    List<int> translatedPositionIndex = const [],
    this.blockTranslation,
    this.contentSignature,
    this.colorHex,
});

}