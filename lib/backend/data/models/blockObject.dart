import 'package:isar/isar.dart';

part 'blockObject.g.dart';

@collection
class BlockObject {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  int? phraseId;

  int? originalPositionIndex;

  int? translatedPositionIndex;

  String? blockTranslation;

  @Index(type: IndexType.hash)
  String? contentSignature;

  String? colorHex;
}