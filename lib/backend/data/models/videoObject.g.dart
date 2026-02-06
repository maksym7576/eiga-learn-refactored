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
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'originalLanguage': PropertySchema(
      id: 1,
      name: r'originalLanguage',
      type: IsarType.string,
    ),
    r'srtPath': PropertySchema(
      id: 2,
      name: r'srtPath',
      type: IsarType.string,
    ),
    r'thumbnailPath': PropertySchema(
      id: 3,
      name: r'thumbnailPath',
      type: IsarType.string,
    ),
    r'translatedLanguage': PropertySchema(
      id: 4,
      name: r'translatedLanguage',
      type: IsarType.string,
    ),
    r'videoName': PropertySchema(
      id: 5,
      name: r'videoName',
      type: IsarType.string,
    ),
    r'videoPath': PropertySchema(
      id: 6,
      name: r'videoPath',
      type: IsarType.string,
    )
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
  version: '3.1.0+1',
);

int _videoObjectEstimateSize(
  VideoObject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.originalLanguage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.srtPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.thumbnailPath;
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
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.originalLanguage);
  writer.writeString(offsets[2], object.srtPath);
  writer.writeString(offsets[3], object.thumbnailPath);
  writer.writeString(offsets[4], object.translatedLanguage);
  writer.writeString(offsets[5], object.videoName);
  writer.writeString(offsets[6], object.videoPath);
}

VideoObject _videoObjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VideoObject();
  object.createdAt = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.originalLanguage = reader.readStringOrNull(offsets[1]);
  object.srtPath = reader.readStringOrNull(offsets[2]);
  object.thumbnailPath = reader.readStringOrNull(offsets[3]);
  object.translatedLanguage = reader.readStringOrNull(offsets[4]);
  object.videoName = reader.readStringOrNull(offsets[5]);
  object.videoPath = reader.readStringOrNull(offsets[6]);
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
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
    IsarCollection<dynamic> col, Id id, VideoObject object) {
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
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<VideoObject, VideoObject, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
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
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VideoObjectQueryFilter
    on QueryBuilder<VideoObject, VideoObject, QFilterCondition> {
  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
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
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'originalLanguage',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'originalLanguage',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
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
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalLanguage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalLanguage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      originalLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      srtPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'srtPath',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      srtPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'srtPath',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> srtPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'srtPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      srtPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'srtPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> srtPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'srtPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> srtPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'srtPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      srtPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'srtPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> srtPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'srtPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> srtPathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'srtPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition> srtPathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'srtPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      srtPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'srtPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      srtPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'srtPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'thumbnailPath',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'thumbnailPath',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'thumbnailPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'thumbnailPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'thumbnailPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnailPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      thumbnailPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'thumbnailPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'translatedLanguage',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'translatedLanguage',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translatedLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translatedLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translatedLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
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
      return query.addFilterCondition(FilterCondition.between(
        property: r'translatedLanguage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translatedLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translatedLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translatedLanguage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translatedLanguage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translatedLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      translatedLanguageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translatedLanguage',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'videoName',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'videoName',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoName',
        value: value,
        caseSensitive: caseSensitive,
      ));
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
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videoName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videoName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videoName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videoName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoName',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videoName',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'videoPath',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'videoPath',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
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
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterFilterCondition>
      videoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videoPath',
        value: '',
      ));
    });
  }
}

extension VideoObjectQueryObject
    on QueryBuilder<VideoObject, VideoObject, QFilterCondition> {}

extension VideoObjectQueryLinks
    on QueryBuilder<VideoObject, VideoObject, QFilterCondition> {}

extension VideoObjectQuerySortBy
    on QueryBuilder<VideoObject, VideoObject, QSortBy> {
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

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortBySrtPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'srtPath', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortBySrtPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'srtPath', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> sortByThumbnailPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
      sortByThumbnailPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.desc);
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

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenBySrtPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'srtPath', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenBySrtPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'srtPath', Sort.desc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy> thenByThumbnailPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.asc);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QAfterSortBy>
      thenByThumbnailPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailPath', Sort.desc);
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
  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByOriginalLanguage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalLanguage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctBySrtPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'srtPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByThumbnailPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thumbnailPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct>
      distinctByTranslatedLanguage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translatedLanguage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByVideoName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoObject, VideoObject, QDistinct> distinctByVideoPath(
      {bool caseSensitive = true}) {
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

  QueryBuilder<VideoObject, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations>
      originalLanguageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalLanguage');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> srtPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'srtPath');
    });
  }

  QueryBuilder<VideoObject, String?, QQueryOperations> thumbnailPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thumbnailPath');
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
