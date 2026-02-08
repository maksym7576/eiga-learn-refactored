// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wordObject.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWordObjectCollection on Isar {
  IsarCollection<WordObject> get wordObjects => this.collection();
}

const WordObjectSchema = CollectionSchema(
  name: r'WordObject',
  id: 8451125353585486498,
  properties: {
    r'blockId': PropertySchema(
      id: 0,
      name: r'blockId',
      type: IsarType.long,
    ),
    r'mainText': PropertySchema(
      id: 1,
      name: r'mainText',
      type: IsarType.string,
    ),
    r'versions': PropertySchema(
      id: 2,
      name: r'versions',
      type: IsarType.objectList,
      target: r'ReadingItem',
    ),
    r'wordPosition': PropertySchema(
      id: 3,
      name: r'wordPosition',
      type: IsarType.long,
    )
  },
  estimateSize: _wordObjectEstimateSize,
  serialize: _wordObjectSerialize,
  deserialize: _wordObjectDeserialize,
  deserializeProp: _wordObjectDeserializeProp,
  idName: r'id',
  indexes: {
    r'blockId': IndexSchema(
      id: -413886092950911832,
      name: r'blockId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'blockId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'ReadingItem': ReadingItemSchema},
  getId: _wordObjectGetId,
  getLinks: _wordObjectGetLinks,
  attach: _wordObjectAttach,
  version: '3.1.0+1',
);

int _wordObjectEstimateSize(
  WordObject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.mainText;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.versions.length * 3;
  {
    final offsets = allOffsets[ReadingItem]!;
    for (var i = 0; i < object.versions.length; i++) {
      final value = object.versions[i];
      bytesCount += ReadingItemSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _wordObjectSerialize(
  WordObject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.blockId);
  writer.writeString(offsets[1], object.mainText);
  writer.writeObjectList<ReadingItem>(
    offsets[2],
    allOffsets,
    ReadingItemSchema.serialize,
    object.versions,
  );
  writer.writeLong(offsets[3], object.wordPosition);
}

WordObject _wordObjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WordObject(
    blockId: reader.readLongOrNull(offsets[0]),
  );
  object.id = id;
  object.versions = reader.readObjectList<ReadingItem>(
        offsets[2],
        ReadingItemSchema.deserialize,
        allOffsets,
        ReadingItem(),
      ) ??
      [];
  object.wordPosition = reader.readLongOrNull(offsets[3]);
  return object;
}

P _wordObjectDeserializeProp<P>(
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
      return (reader.readObjectList<ReadingItem>(
            offset,
            ReadingItemSchema.deserialize,
            allOffsets,
            ReadingItem(),
          ) ??
          []) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _wordObjectGetId(WordObject object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wordObjectGetLinks(WordObject object) {
  return [];
}

void _wordObjectAttach(IsarCollection<dynamic> col, Id id, WordObject object) {
  object.id = id;
}

extension WordObjectQueryWhereSort
    on QueryBuilder<WordObject, WordObject, QWhere> {
  QueryBuilder<WordObject, WordObject, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhere> anyBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'blockId'),
      );
    });
  }
}

extension WordObjectQueryWhere
    on QueryBuilder<WordObject, WordObject, QWhereClause> {
  QueryBuilder<WordObject, WordObject, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> idBetween(
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

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> blockIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'blockId',
        value: [null],
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> blockIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'blockId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> blockIdEqualTo(
      int? blockId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'blockId',
        value: [blockId],
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> blockIdNotEqualTo(
      int? blockId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'blockId',
              lower: [],
              upper: [blockId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'blockId',
              lower: [blockId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'blockId',
              lower: [blockId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'blockId',
              lower: [],
              upper: [blockId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> blockIdGreaterThan(
    int? blockId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'blockId',
        lower: [blockId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> blockIdLessThan(
    int? blockId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'blockId',
        lower: [],
        upper: [blockId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterWhereClause> blockIdBetween(
    int? lowerBlockId,
    int? upperBlockId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'blockId',
        lower: [lowerBlockId],
        includeLower: includeLower,
        upper: [upperBlockId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WordObjectQueryFilter
    on QueryBuilder<WordObject, WordObject, QFilterCondition> {
  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> blockIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blockId',
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      blockIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blockId',
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> blockIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockId',
        value: value,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      blockIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blockId',
        value: value,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> blockIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blockId',
        value: value,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> blockIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blockId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> mainTextIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mainText',
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      mainTextIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mainText',
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> mainTextEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      mainTextGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> mainTextLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> mainTextBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mainText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      mainTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> mainTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> mainTextContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mainText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> mainTextMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mainText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      mainTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mainText',
        value: '',
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      mainTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mainText',
        value: '',
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      versionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'versions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      versionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'versions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      versionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'versions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      versionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'versions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      versionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'versions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      versionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'versions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      wordPositionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wordPosition',
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      wordPositionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wordPosition',
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      wordPositionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      wordPositionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      wordPositionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordPosition',
        value: value,
      ));
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterFilterCondition>
      wordPositionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordPosition',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WordObjectQueryObject
    on QueryBuilder<WordObject, WordObject, QFilterCondition> {
  QueryBuilder<WordObject, WordObject, QAfterFilterCondition> versionsElement(
      FilterQuery<ReadingItem> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'versions');
    });
  }
}

extension WordObjectQueryLinks
    on QueryBuilder<WordObject, WordObject, QFilterCondition> {}

extension WordObjectQuerySortBy
    on QueryBuilder<WordObject, WordObject, QSortBy> {
  QueryBuilder<WordObject, WordObject, QAfterSortBy> sortByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> sortByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> sortByMainText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainText', Sort.asc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> sortByMainTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainText', Sort.desc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> sortByWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.asc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> sortByWordPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.desc);
    });
  }
}

extension WordObjectQuerySortThenBy
    on QueryBuilder<WordObject, WordObject, QSortThenBy> {
  QueryBuilder<WordObject, WordObject, QAfterSortBy> thenByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.asc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> thenByBlockIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockId', Sort.desc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> thenByMainText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainText', Sort.asc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> thenByMainTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mainText', Sort.desc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> thenByWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.asc);
    });
  }

  QueryBuilder<WordObject, WordObject, QAfterSortBy> thenByWordPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordPosition', Sort.desc);
    });
  }
}

extension WordObjectQueryWhereDistinct
    on QueryBuilder<WordObject, WordObject, QDistinct> {
  QueryBuilder<WordObject, WordObject, QDistinct> distinctByBlockId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockId');
    });
  }

  QueryBuilder<WordObject, WordObject, QDistinct> distinctByMainText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mainText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WordObject, WordObject, QDistinct> distinctByWordPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordPosition');
    });
  }
}

extension WordObjectQueryProperty
    on QueryBuilder<WordObject, WordObject, QQueryProperty> {
  QueryBuilder<WordObject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WordObject, int?, QQueryOperations> blockIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockId');
    });
  }

  QueryBuilder<WordObject, String?, QQueryOperations> mainTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mainText');
    });
  }

  QueryBuilder<WordObject, List<ReadingItem>, QQueryOperations>
      versionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'versions');
    });
  }

  QueryBuilder<WordObject, int?, QQueryOperations> wordPositionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordPosition');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ReadingItemSchema = Schema(
  name: r'ReadingItem',
  id: 710003338608000221,
  properties: {
    r'key': PropertySchema(
      id: 0,
      name: r'key',
      type: IsarType.string,
    ),
    r'text': PropertySchema(
      id: 1,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _readingItemEstimateSize,
  serialize: _readingItemSerialize,
  deserialize: _readingItemDeserialize,
  deserializeProp: _readingItemDeserializeProp,
);

int _readingItemEstimateSize(
  ReadingItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.key;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _readingItemSerialize(
  ReadingItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeString(offsets[1], object.text);
}

ReadingItem _readingItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReadingItem(
    key: reader.readStringOrNull(offsets[0]),
    text: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _readingItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ReadingItemQueryFilter
    on QueryBuilder<ReadingItem, ReadingItem, QFilterCondition> {
  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'key',
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition>
      textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<ReadingItem, ReadingItem, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension ReadingItemQueryObject
    on QueryBuilder<ReadingItem, ReadingItem, QFilterCondition> {}
