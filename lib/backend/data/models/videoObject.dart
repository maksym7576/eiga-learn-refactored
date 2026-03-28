import 'package:isar_community/isar.dart';

part 'videoObject.g.dart';

@collection
class VideoObject {
  Id id = Isar.autoIncrement;

  String? originalLanguage;
  String? translatedLanguage;
  String? videoName;
  String? textFormat;
  String? pathSubtitle;
  String? videoPath;
  String? thumbnailPath;
  DateTime? createdAt;
}