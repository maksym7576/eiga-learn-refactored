// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phraseObject.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPhraseObjectCollection on Isar {
  IsarCollection<PhraseObject> get phraseObjects => this.collection();
}

const PhraseObjectSchema = CollectionSchema(
  name: r'PhraseObject',
  id: 3648591765443823481,
  properties: {
    r'endTime': PropertySchema(
      id: 0,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(
      id: 1,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isTranslated': PropertySchema(
      id: 2,
      name: r'isTranslated',
      type: IsarType.bool,
    ),
    r'originalPhrase': PropertySchema(
      id: 3,
      name: r'originalPhrase',
      type: IsarType.string,
    ),
    r'phraseOrder': PropertySchema(
      id: 4,
      name: r'phraseOrder',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 5,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'videoId': PropertySchema(
      id: 6,
      name: r'videoId',
      type: IsarType.long,
    )
  },
  estimateSize: _phraseObjectEstimateSize,
  serialize: _phraseObjectSerialize,
  deserialize: _phraseObjectDeserialize,
  deserializeProp: _phraseObjectDeserializeProp,
  idName: r'id',
  indexes: {
    r'videoId': IndexSchema(
      id: 6273887982249211799,
      name: r'videoId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'videoId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _phraseObjectGetId,
  getLinks: _phraseObjectGetLinks,
  attach: _phraseObjectAttach,
  version: '3.1.0+1',
);

int _phraseObjectEstimateSize(
  PhraseObject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.originalPhrase;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _phraseObjectSerialize(
  PhraseObject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.endTime);
  writer.writeBool(offsets[1], object.isActive);
  writer.writeBool(offsets[2], object.isTranslated);
  writer.writeString(offsets[3], object.originalPhrase);
  writer.writeLong(offsets[4], object.phraseOrder);
  writer.writeDateTime(offsets[5], object.startTime);
  writer.writeLong(offsets[6], object.videoId);
}

PhraseObject _phraseObjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PhraseObject(
    endTime: reader.readDateTimeOrNull(offsets[0]),
    originalPhrase: reader.readStringOrNull(offsets[3]),
    phraseOrder: reader.readLongOrNull(offsets[4]),
    startTime: reader.readDateTimeOrNull(offsets[5]),
    videoId: reader.readLongOrNull(offsets[6]),
  );
  object.id = id;
  object.isActive = reader.readBool(offsets[1]);
  object.isTranslated = reader.readBool(offsets[2]);
  return object;
}

P _phraseObjectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _phraseObjectGetId(PhraseObject object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _phraseObjectGetLinks(PhraseObject object) {
  return [];
}

void _phraseObjectAttach(
    IsarCollection<dynamic> col, Id id, PhraseObject object) {
  object.id = id;
}

extension PhraseObjectQueryWhereSort
    on QueryBuilder<PhraseObject, PhraseObject, QWhere> {
  QueryBuilder<PhraseObject, PhraseObject, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhere> anyVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'videoId'),
      );
    });
  }
}

extension PhraseObjectQueryWhere
    on QueryBuilder<PhraseObject, PhraseObject, QWhereClause> {
  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> idBetween(
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

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> videoIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'videoId',
        value: [null],
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause>
      videoIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'videoId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> videoIdEqualTo(
      int? videoId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'videoId',
        value: [videoId],
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> videoIdNotEqualTo(
      int? videoId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'videoId',
              lower: [],
              upper: [videoId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'videoId',
              lower: [videoId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'videoId',
              lower: [videoId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'videoId',
              lower: [],
              upper: [videoId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause>
      videoIdGreaterThan(
    int? videoId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'videoId',
        lower: [videoId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> videoIdLessThan(
    int? videoId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'videoId',
        lower: [],
        upper: [videoId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterWhereClause> videoIdBetween(
    int? lowerVideoId,
    int? upperVideoId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'videoId',
        lower: [lowerVideoId],
        includeLower: includeLower,
        upper: [upperVideoId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PhraseObjectQueryFilter
    on QueryBuilder<PhraseObject, PhraseObject, QFilterCondition> {
  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endTime',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      endTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      endTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      endTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      isTranslatedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTranslated',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'originalPhrase',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'originalPhrase',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPhrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalPhrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalPhrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalPhrase',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'originalPhrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'originalPhrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'originalPhrase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'originalPhrase',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPhrase',
        value: '',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      originalPhraseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'originalPhrase',
        value: '',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      phraseOrderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phraseOrder',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      phraseOrderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phraseOrder',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      phraseOrderEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phraseOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      phraseOrderGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phraseOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      phraseOrderLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phraseOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      phraseOrderBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phraseOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startTime',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      startTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      startTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      startTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      videoIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'videoId',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      videoIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'videoId',
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      videoIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoId',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      videoIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoId',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      videoIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoId',
        value: value,
      ));
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterFilterCondition>
      videoIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PhraseObjectQueryObject
    on QueryBuilder<PhraseObject, PhraseObject, QFilterCondition> {}

extension PhraseObjectQueryLinks
    on QueryBuilder<PhraseObject, PhraseObject, QFilterCondition> {}

extension PhraseObjectQuerySortBy
    on QueryBuilder<PhraseObject, PhraseObject, QSortBy> {
  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByIsTranslated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslated', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy>
      sortByIsTranslatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslated', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy>
      sortByOriginalPhrase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPhrase', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy>
      sortByOriginalPhraseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPhrase', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByPhraseOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseOrder', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy>
      sortByPhraseOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseOrder', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> sortByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension PhraseObjectQuerySortThenBy
    on QueryBuilder<PhraseObject, PhraseObject, QSortThenBy> {
  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByIsTranslated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslated', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy>
      thenByIsTranslatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTranslated', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy>
      thenByOriginalPhrase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPhrase', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy>
      thenByOriginalPhraseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPhrase', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByPhraseOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseOrder', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy>
      thenByPhraseOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseOrder', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QAfterSortBy> thenByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension PhraseObjectQueryWhereDistinct
    on QueryBuilder<PhraseObject, PhraseObject, QDistinct> {
  QueryBuilder<PhraseObject, PhraseObject, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QDistinct> distinctByIsTranslated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTranslated');
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QDistinct> distinctByOriginalPhrase(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalPhrase',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QDistinct> distinctByPhraseOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phraseOrder');
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<PhraseObject, PhraseObject, QDistinct> distinctByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoId');
    });
  }
}

extension PhraseObjectQueryProperty
    on QueryBuilder<PhraseObject, PhraseObject, QQueryProperty> {
  QueryBuilder<PhraseObject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PhraseObject, DateTime?, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<PhraseObject, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<PhraseObject, bool, QQueryOperations> isTranslatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTranslated');
    });
  }

  QueryBuilder<PhraseObject, String?, QQueryOperations>
      originalPhraseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalPhrase');
    });
  }

  QueryBuilder<PhraseObject, int?, QQueryOperations> phraseOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phraseOrder');
    });
  }

  QueryBuilder<PhraseObject, DateTime?, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<PhraseObject, int?, QQueryOperations> videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoId');
    });
  }
}
