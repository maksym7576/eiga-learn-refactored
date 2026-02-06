import 'package:isar/isar.dart';

part 'languageObject.g.dart';

@collection
class LanguageObject {
  Id id = Isar.autoIncrement;

  String? language;
  bool? isSupported;
}