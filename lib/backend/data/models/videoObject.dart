import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

part 'videoObject.g.dart';

@collection
class VideoObject {
  Id id = Isar.autoIncrement;

  String? originalLanguage;
  String? translatedLanguage;
  String? textFormat;
  String? pathSubtitle;
  String? videoPath;
  DateTime? createdAt;
  String? videoName;
  String? episode;
  String? season;

  //Jumaku data
  String? nameJumaku;
  String? englishName;
  String? japaneseName;
  String? nameFileJumaku;
  int? anilistId;
  String? tmdbId;
  bool? isAnime;
  bool? isMovie;
  bool? isAdult;
  bool? isUnverified;

  //AnilistData
  String? coverImagePath;
  String? description;
  String? bannerImage;
  List<String>? genres;

  int? colorThemeValue;

  @ignore
  Color? get colorTheme {
    if (colorThemeValue == null) return null;
    return Color(colorThemeValue!);
  }

  @ignore
  set colorTheme(Color? color) {
    colorThemeValue = color?.value;
  }
}