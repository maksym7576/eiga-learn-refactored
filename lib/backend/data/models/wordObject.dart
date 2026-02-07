import 'package:isar/isar.dart';

part 'wordObject.g.dart';

@collection
class WordObject {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  int? blockId;

  List<ReadingItem> versions = [];

  String? get mainText => versions.isNotEmpty ? versions.first.text : '';

  WordObject({this.blockId});

}

@embedded
class ReadingItem {
  String? key;
  String? text;

  ReadingItem({this.key, this.text});
}