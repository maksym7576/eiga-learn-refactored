import 'package:isar/isar.dart';

part 'phraseObject.g.dart';

@collection
class PhraseObject {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  int? videoId;

  int? phraseOrder;

  String? originalPhrase;

  DateTime? startTime;

  DateTime? endTime;

  bool isTranslated = false;

  bool isActive = false;
}