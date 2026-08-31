import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

part 'videoObject.g.dart';

@collection
class VideoObject {
  Id id = Isar.autoIncrement;

  List<AiRequestEntry>? aiHistory;

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

  //Pepeline
  String? pepelineIndetificator;

      //peleline 1
  bool? isResearchDone = false;
  String? researchInformation;

  @ignore
  Color? get colorTheme {
    if (colorThemeValue == null) return null;
    return Color(colorThemeValue!);
  }

  @ignore
  set colorTheme(Color? color) {
    colorThemeValue = color?.toARGB32();
  }

  VideoObject copyWith({
    Id? id,
    String? originalLanguage,
    String? translatedLanguage,
    String? textFormat,
    String? pathSubtitle,
    String? videoPath,
    DateTime? createdAt,
    String? videoName,
    String? episode,
    String? season,
    String? nameJumaku,
    String? englishName,
    String? japaneseName,
    String? nameFileJumaku,
    int? anilistId,
    String? tmdbId,
    bool? isAnime,
    bool? isMovie,
    bool? isAdult,
    bool? isUnverified,
    String? coverImagePath,
    String? description,
    String? bannerImage,
    List<String>? genres,
    int? colorThemeValue,
    String? pepelineIndetificator,
    bool? isResearchDone,
    String? researchInformation,
    List<AiRequestEntry>? aiHistory,
  }) {
    return VideoObject()
      ..id = id ?? this.id
      ..originalLanguage = originalLanguage ?? this.originalLanguage
      ..translatedLanguage = translatedLanguage ?? this.translatedLanguage
      ..textFormat = textFormat ?? this.textFormat
      ..pathSubtitle = pathSubtitle ?? this.pathSubtitle
      ..videoPath = videoPath ?? this.videoPath
      ..createdAt = createdAt ?? this.createdAt
      ..videoName = videoName ?? this.videoName
      ..episode = episode ?? this.episode
      ..season = season ?? this.season
      ..nameJumaku = nameJumaku ?? this.nameJumaku
      ..englishName = englishName ?? this.englishName
      ..japaneseName = japaneseName ?? this.japaneseName
      ..nameFileJumaku = nameFileJumaku ?? this.nameFileJumaku
      ..anilistId = anilistId ?? this.anilistId
      ..tmdbId = tmdbId ?? this.tmdbId
      ..isAnime = isAnime ?? this.isAnime
      ..isMovie = isMovie ?? this.isMovie
      ..isAdult = isAdult ?? this.isAdult
      ..isUnverified = isUnverified ?? this.isUnverified
      ..coverImagePath = coverImagePath ?? this.coverImagePath
      ..description = description ?? this.description
      ..bannerImage = bannerImage ?? this.bannerImage
      ..genres = genres ?? this.genres
      ..colorThemeValue = colorThemeValue ?? this.colorThemeValue
      ..pepelineIndetificator = pepelineIndetificator ?? this.pepelineIndetificator
      ..isResearchDone = isResearchDone ?? this.isResearchDone
      ..researchInformation = researchInformation ?? this.researchInformation
      ..aiHistory = aiHistory ?? this.aiHistory;
  }
}

@embedded
class AiRequestEntry {
  String? id; // Unique ID for tracking active requests
  String? modelName;
  String? phase; // mapping to AiRequestPhase
  DateTime? startTime;
  DateTime? endTime;
  String? requestType;
  String? errorMessage;
  List<int>? failedIds;

  AiRequestEntry({
    this.id,
    this.modelName,
    this.phase,
    this.startTime,
    this.endTime,
    this.requestType,
    this.errorMessage,
    this.failedIds,
  });
}
