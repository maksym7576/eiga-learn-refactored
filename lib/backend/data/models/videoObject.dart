import 'package:isar/isar.dart';

part 'videoObject.g.dart';

@collection
class VideoObject {
  Id id = Isar.autoIncrement;

  String? originalLanguage;
  String? translatedLanguage;
  String? videoName;
  String? srtPath;
  String? videoPath;
  String? thumbnailPath;
  DateTime? createdAt;
}