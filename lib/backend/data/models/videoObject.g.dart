// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videoObject.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVideoObjectCollection on Isar {
  IsarCollection<VideoObject> get videoObjects => this.collection();
}

const VideoObjectSchema = CollectionSchema(
  name: r'VideoObject',
  id: -4838623918200537773,
  properties: {
    r'anilistId': PropertySchema(
      id: 0,
      name: r'anilistId',
      type: IsarType.long,
    ),
    r'bannerImage': PropertySchema(
      id: 1,
      name: r'bannerImage',
      type: IsarType.string,
    ),
    r'colorThemeValue': PropertySchema(
      id: 2,
      name: r'colorThemeValue',
      type: IsarType.long,
    ),
    r'coverImagePath': PropertySchema(
      id: 3,
      name: r'coverImagePath',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 5,
      name: r'description',
      type: IsarType.string,
    ),
    r'englishName': PropertySchema(
      id: 6,
      name: r'englishName',
      type: IsarType.string,
    ),
    r'episode': PropertySchema(id: 7, name: r'episode', type: IsarType.string),
    r'genres': PropertySchema(
      id: 8,
      name: r'genres',
      type: IsarType.stringList,
    ),
    r'isAdult': PropertySchema(id: 9, name: r'isAdult', type: IsarType.bool),
    r'isAnime': PropertySchema(id: 10, name: r'isAnime', type: IsarType.bool),
    r'isMovie': PropertySchema(id: 11, name: r'isMovie', type: IsarType.bool),
    r'isResearchDone': PropertySchema(
      id: 12,
      name: r'isResearchDone',
      type: IsarType.bool,
    ),
    r'isUnverified': PropertySchema(
      id: 13,
      name: r'isUnverified',
      type: IsarType.bool,
    ),
    r'japaneseName': PropertySchema(
      id: 14,
      name: r'japaneseName',
      type: IsarType.string,
    ),
    r'nameFileJumaku': PropertySchema(
      id: 15,
      name: r'nameFileJumaku',
      type: IsarType.string,
    ),
    r'nameJumaku': PropertySchema(
      id: 16,
      name: r'nameJumaku',
      type: IsarType.string,
    ),
    r'originalLanguage': PropertySchema(
      id: 17,
      name: r'originalLanguage',
      type: IsarType.string,
    ),
    r'pathSubtitle': PropertySchema(
      id: 18,
      name: r'pathSubtitle',
      type: IsarType.string,
    ),
    r'pepelineIndetificator': PropertySchema(
      id: 19,
      name: r'pepelineIndetificator',
      type: IsarType.string,
    ),
    r'researchInformation': PropertySchema(
      id: 20,
      name: r'researchInformation',
      type: IsarType.string,
    ),
    r'season': PropertySchema(id: 21, name: r'season', type: IsarType.string),
    r'textFormat': PropertySchema(
      id: 22,
      name: r'textFormat',
      type: IsarType.string,
    ),
    r'tmdbId': PropertySchema(id: 23, name: r'tmdbId', type: IsarType.string),
    r'translatedLanguage': PropertySchema(
      id: 24,
      name: r'translatedLanguage',
      type: IsarType.string,
    ),
    r'videoName': PropertySchema(
      id: 25,
      name: r'videoName',
      type: IsarType.string,
    ),
    r'videoPath': PropertySchema(
      id: 26,
      name: r'videoPath',
      type: IsarType.string,
    ),
  },

  estimateSize: _videoObjectEstimateSize,
  serialize: _videoObjectSerialize,
  deserialize: _videoObjectDeserialize,
  deserializeProp: _videoObjectDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _videoObjectGetId,
  getLinks: _videoObjectGetLinks,
  attach: _videoObjectAttach,
  version: '3.3.2',
);

int _videoObjectEstimateSize(
  VideoObject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bannerImage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.coverImagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.englishName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.episode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.genres;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.japaneseName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nameFileJumaku;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nameJumaku;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.originalLanguage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pathSubtitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pepelineIndetificator;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.researchInformation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.season;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.textFormat;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.tmdbId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.translatedLanguage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.videoName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.videoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _videoObjectSerialize(
  VideoObject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.anilistId);
  writer.writeString(offsets[1], object.bannerImage);
  writer.writeLong(offsets[2], object.colorThemeValue);
  writer.writeString(offsets[3], object.coverImagePath);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.description);
  writer.writeString(offsets[6], object.englishName);
  writer.writeString(offsets[7], object.episode);
  writer.writeStringList(offsets[8], object.genres);
  writer.writeBool(offsets[9], object.isAdult);
  writer.writeBool(offsets[10], object.isAnime);
  writer.writeBool(offsets[11], object.isMovie);
  writer.writeBool(offsets[12], object.isResearchDone);
  writer.writeBool(offsets[13], object.isUnverified);
  writer.writeString(offsets[14], object.japaneseName);
  writer.writeString(offsets[15], object.nameFileJumaku);
  writer.writeString(offsets[16], object.nameJumaku);
  writer.writeString(offsets[17], object.originalLanguage);
  writer.writeString(offsets[18], object.pathSubtitle);
  writer.writeString(offsets[19], object.pepelineIndetificator);
  writer.writeString(offsets[20], object.researchInformation);
  writer.writeString(offsets[21], object.season);
  writer.writeString(offsets[22], object.textFormat);
  writer.writeString(offsets[23], object.tmdbId);
  writer.writeString(offsets[24], object.translatedLanguage);
  writer.writeString(offsets[25], object.videoName);
  writer.writeString(offsets[26], object.videoPath);
}

VideoObject _videoObjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VideoObject();
  object.anilistId = reader.readLongOrNull(offsets[0]);
  object.bannerImage = reader.readStringOrNull(offsets[1]);
  object.colorThemeValue = reader.readLongOrNull(offsets[2]);
  object.coverImagePath = reader.readStringOrNull(offsets[3]);
  object.createdAt = reader.readDateTimeOrNull(offsets[4]);
  object.description = reader.readStringOrNull(offsets[5]);
  object.englishName = reader.readStringOrNull(offsets[6]);
  object.episode = reader.readStringOrNull(offsets[7]);
  object.genres = reader.readStringList(offsets[8]);
  object.id = id;
  object.isAdult = reader.readBoolOrNull(offsets[9]);
  object.isAnime = reader.readBoolOrNull(offsets[10]);
  object.isMovie = reader.readBoolOrNull(offsets[11]);
  object.isResearchDone = reader.readBoolOrNull(offsets[12]);
  object.isUnverified = reader.readBoolOrNull(offsets[13]);
  object.japaneseName = reader.readStringOrNull(offsets[14]);
  object.nameFileJumaku = reader.readStringOrNull(offsets[15]);
  object.nameJumaku = reader.readStringOrNull(offsets[16]);
  object.originalLanguage = reader.readStringOrNull(offsets[17]);
  object.pathSubtitle = reader.readStringOrNull(offsets[18]);
  object.pepelineIndetificator = reader.readStringOrNull(offsets[19]);
  object.researchInformation = reader.readStringOrNull(offsets[20]);
  object.season = reader.readStringOrNull(offsets[21]);
  object.textFormat = reader.readStringOrNull(offsets[22]);
  object.tmdbId = reader.readStringOrNull(offsets[23]);
  object.translatedLanguage = reader.readStringOrNull(offsets[24]);
  object.videoName = reader.readStringOrNull(offsets[25]);
  object.videoPath = reader.readStringOrNull(offsets[26]);
  return object;
}

P _videoObjectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringList(offset)) as P;
    case 9:
      return (reader.readBoolOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset)) as P;
    case 13:
      return (reader.readBoolOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _videoObjectGetId(VideoObject object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _videoObjectGetLinks(VideoObject object) {
  return [];
}

void _videoObjectAttach(
  IsarCollection<dynamic> col,
  Id id,
  VideoObject object,
) {
  object.id = id;
}

extension VideoObjectQueryWhereSort
    on QueryBuilder<VideoObject, VideoObject, QWhere> {
  QueryBuilder<VideoObject, VideoObject, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VideoObjectQueryWhere
    on QueryBuilder<VideoObject, VideoObject, QWhereClause> {
  QueryBuilder<VideoObject, VideoObject, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension VideoObjectQueryFilter
    on QueryBuilder<VideoObject, VideoObject, QFilterCondition> {
  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  anilistIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'anilistId'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  anilistIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'anilistId'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  anilistIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'anilistId', value: value),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  anilistIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'anilistId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  anilistIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'anilistId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  anilistIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'anilistId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'bannerImage'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'bannerImage'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bannerImage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'bannerImage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'bannerImage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bannerImage', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  bannerImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'bannerImage', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  colorThemeValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'colorThemeValue'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  colorThemeValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'colorThemeValue'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  colorThemeValueEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'colorThemeValue', value: value),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  colorThemeValueGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'colorThemeValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  colorThemeValueLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'colorThemeValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  colorThemeValueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'colorThemeValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'coverImagePath'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'coverImagePath'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coverImagePath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coverImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coverImagePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coverImagePath', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  coverImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'coverImagePath', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  createdAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  createdAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'description'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'description'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'englishName'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'englishName'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'englishName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'englishName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'englishName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'englishName', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  englishNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'englishName', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  episodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'episode'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  episodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'episode'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> episodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  episodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> episodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> episodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'episode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  episodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> episodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> episodeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'episode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> episodeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'episode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  episodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'episode', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  episodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'episode', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> genresIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'genres'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'genres'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'genres',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'genres',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'genres',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'genres', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'genres', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, true, length, true);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, 0, true);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, false, 999999, true);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', 0, true, length, include);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'genres', length, include, 999999, true);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  genresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'genres',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isAdultIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isAdult'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isAdultIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isAdult'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> isAdultEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isAdult', value: value),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isAnimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isAnime'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isAnimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isAnime'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> isAnimeEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isAnime', value: value),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isMovieIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isMovie'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isMovieIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isMovie'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> isMovieEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isMovie', value: value),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isResearchDoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isResearchDone'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isResearchDoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isResearchDone'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isResearchDoneEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isResearchDone', value: value),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isUnverifiedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'isUnverified'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isUnverifiedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'isUnverified'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  isUnverifiedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isUnverified', value: value),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'japaneseName'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'japaneseName'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'japaneseName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'japaneseName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'japaneseName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'japaneseName', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  japaneseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'japaneseName', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nameFileJumaku'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nameFileJumaku'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nameFileJumaku',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nameFileJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nameFileJumaku',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nameFileJumaku', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameFileJumakuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nameFileJumaku', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'nameJumaku'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'nameJumaku'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nameJumaku',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nameJumaku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nameJumaku',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nameJumaku', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  nameJumakuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nameJumaku', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'originalLanguage'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'originalLanguage'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'originalLanguage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'originalLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'originalLanguage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'originalLanguage', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  originalLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'originalLanguage', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pathSubtitle'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pathSubtitle'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pathSubtitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pathSubtitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pathSubtitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pathSubtitle', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pathSubtitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'pathSubtitle', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'pepelineIndetificator'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'pepelineIndetificator'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'pepelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'pepelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'pepelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'pepelineIndetificator',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'pepelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'pepelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'pepelineIndetificator',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'pepelineIndetificator',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pepelineIndetificator', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  pepelineIndetificatorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'pepelineIndetificator',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'researchInformation'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'researchInformation'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'researchInformation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'researchInformation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'researchInformation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'researchInformation', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  researchInformationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'researchInformation',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> seasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'season'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  seasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'season'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> seasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  seasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> seasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> seasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'season',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  seasonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> seasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> seasonContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'season',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> seasonMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'season',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  seasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'season', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  seasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'season', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'textFormat'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'textFormat'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textFormat',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'textFormat',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'textFormat',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textFormat', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  textFormatIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'textFormat', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> tmdbIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'tmdbId'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  tmdbIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'tmdbId'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> tmdbIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  tmdbIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> tmdbIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> tmdbIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tmdbId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  tmdbIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> tmdbIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> tmdbIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tmdbId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> tmdbIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tmdbId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  tmdbIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tmdbId', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  tmdbIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tmdbId', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'translatedLanguage'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'translatedLanguage'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'translatedLanguage',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'translatedLanguage',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'translatedLanguage',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'translatedLanguage', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  translatedLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'translatedLanguage', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'videoName'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'videoName'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videoName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'videoName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'videoName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoName', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'videoName', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'videoPath'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'videoPath'),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'videoPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'videoPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'videoPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'videoPath', value: ''),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
  videoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'videoPath', value: ''),
      );
    });
  }
}

extension VideoObjectQueryObject
    on QueryBuilder<VideoObject, VideoObject, QFilterCondition> {}

extension VideoObjectQueryLinks
    on QueryBuilder<VideoObject, VideoObject, QFilterCondition> {}

extension VideoObjectQuerySortBy
    on QueryBuilder<VideoObject, VideoObject, QSortBy> {
  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByAnilistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anilistId', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByAnilistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anilistId', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByColorThemeValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorThemeValue', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByColorThemeValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorThemeValue', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByCoverImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImagePath', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByCoverImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImagePath', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByEnglishName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishName', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByEnglishNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishName', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episode', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByEpisodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episode', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByIsAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdult', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByIsAdultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdult', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByIsAnime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnime', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByIsAnimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnime', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByIsMovieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByIsResearchDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResearchDone', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByIsResearchDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResearchDone', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByIsUnverified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUnverified', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByIsUnverifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUnverified', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByJapaneseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'japaneseName', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByJapaneseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'japaneseName', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByNameFileJumaku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameFileJumaku', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByNameFileJumakuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameFileJumaku', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByNameJumaku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameJumaku', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByNameJumakuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameJumaku', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByPathSubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathSubtitle', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByPathSubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathSubtitle', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByPepelineIndetificator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pepelineIndetificator', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByPepelineIndetificatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pepelineIndetificator', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByResearchInformation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'researchInformation', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByResearchInformationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'researchInformation', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortBySeason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortBySeasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByTextFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textFormat', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByTextFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textFormat', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByTranslatedLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedLanguage', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  sortByTranslatedLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedLanguage', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByVideoName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoName', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByVideoNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoName', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }
}

extension VideoObjectQuerySortThenBy
    on QueryBuilder<VideoObject, VideoObject, QSortThenBy> {
  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByAnilistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anilistId', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByAnilistIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'anilistId', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByBannerImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByBannerImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bannerImage', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByColorThemeValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorThemeValue', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByColorThemeValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorThemeValue', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByCoverImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImagePath', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByCoverImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverImagePath', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByEnglishName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishName', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByEnglishNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'englishName', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByEpisode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episode', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByEpisodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episode', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByIsAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdult', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByIsAdultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAdult', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByIsAnime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnime', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByIsAnimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAnime', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByIsMovieDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMovie', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByIsResearchDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResearchDone', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByIsResearchDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResearchDone', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByIsUnverified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUnverified', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByIsUnverifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUnverified', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByJapaneseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'japaneseName', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByJapaneseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'japaneseName', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByNameFileJumaku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameFileJumaku', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByNameFileJumakuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameFileJumaku', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByNameJumaku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameJumaku', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByNameJumakuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameJumaku', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByOriginalLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByOriginalLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalLanguage', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByPathSubtitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathSubtitle', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByPathSubtitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pathSubtitle', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByPepelineIndetificator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pepelineIndetificator', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByPepelineIndetificatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pepelineIndetificator', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByResearchInformation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'researchInformation', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByResearchInformationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'researchInformation', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenBySeason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenBySeasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'season', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByTextFormat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textFormat', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByTextFormatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textFormat', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByTmdbId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByTmdbIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tmdbId', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByTranslatedLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedLanguage', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
  thenByTranslatedLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedLanguage', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByVideoName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoName', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByVideoNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoName', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByVideoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByVideoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoPath', Sort.desc);
    });
  }
}

extension VideoObjectQueryWhereDistinct
    on QueryBuilder<VideoObject, VideoObject, QDistinct> {
  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByAnilistId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'anilistId');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByBannerImage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bannerImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct>
  distinctByColorThemeValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorThemeValue');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByCoverImagePath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'coverImagePath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByEnglishName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'englishName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByEpisode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByGenres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'genres');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByIsAdult() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAdult');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByIsAnime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAnime');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByIsMovie() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMovie');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByIsResearchDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isResearchDone');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByIsUnverified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isUnverified');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByJapaneseName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'japaneseName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByNameFileJumaku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'nameFileJumaku',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByNameJumaku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameJumaku', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByOriginalLanguage({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'originalLanguage',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByPathSubtitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pathSubtitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct>
  distinctByPepelineIndetificator({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'pepelineIndetificator',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct>
  distinctByResearchInformation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'researchInformation',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctBySeason({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'season', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByTextFormat({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textFormat', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByTmdbId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tmdbId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct>
  distinctByTranslatedLanguage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'translatedLanguage',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByVideoName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByVideoPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoPath', caseSensitive: caseSensitive);
    });
  }
}

extension VideoObjectQueryProperty
    on QueryBuilder<VideoObject, VideoObject, QQueryProperty> {
  QueryBuilder<VideoObject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VideoObject, int?, QQueryOperations> anilistIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'anilistId');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> bannerImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bannerImage');
    });
  }

  QueryBuilder<VideoObject, int?, QQueryOperations> colorThemeValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorThemeValue');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations>
  coverImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverImagePath');
    });
  }

  QueryBuilder<VideoObject, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> englishNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'englishName');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> episodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episode');
    });
  }

  QueryBuilder<VideoObject, List<String>?, QQueryOperations> genresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'genres');
    });
  }

  QueryBuilder<VideoObject, bool?, QQueryOperations> isAdultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAdult');
    });
  }

  QueryBuilder<VideoObject, bool?, QQueryOperations> isAnimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAnime');
    });
  }

  QueryBuilder<VideoObject, bool?, QQueryOperations> isMovieProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMovie');
    });
  }

  QueryBuilder<VideoObject, bool?, QQueryOperations> isResearchDoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isResearchDone');
    });
  }

  QueryBuilder<VideoObject, bool?, QQueryOperations> isUnverifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isUnverified');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> japaneseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'japaneseName');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations>
  nameFileJumakuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameFileJumaku');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> nameJumakuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameJumaku');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations>
  originalLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalLanguage');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> pathSubtitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pathSubtitle');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations>
  pepelineIndetificatorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pepelineIndetificator');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations>
  researchInformationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'researchInformation');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> seasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'season');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> textFormatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textFormat');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> tmdbIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tmdbId');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations>
  translatedLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedLanguage');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> videoNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoName');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> videoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoPath');
    });
  }
}
