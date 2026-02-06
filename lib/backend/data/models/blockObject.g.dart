// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blockObject.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBlockObjectCollection on Isar {
  IsarCollection<BlockObject> get blockObjects => this.collection();
}

const BlockObjectSchema = CollectionSchema(
  name: r'BlockObject',
  id: 5859615813996755603,
  properties: {
    r'blockTranslation': PropertySchema(
      id: 0,
      name: r'blockTranslation',
      type: IsarType.string,
    ),
    r'colorHex': PropertySchema(
      id: 1,
      name: r'colorHex',
      type: IsarType.string,
    ),
    r'contentSignature': PropertySchema(
      id: 2,
      name: r'contentSignature',
      type: IsarType.string,
    ),
    r'originalPositionIndex': PropertySchema(
      id: 3,
      name: r'originalPositionIndex',
      type: IsarType.long,
    ),
    r'phraseId': PropertySchema(
      id: 4,
      name: r'phraseId',
      type: IsarType.long,
    ),
    r'translatedPositionIndex': PropertySchema(
      id: 5,
      name: r'translatedPositionIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _blockObjectEstimateSize,
  serialize: _blockObjectSerialize,
  deserialize: _blockObjectDeserialize,
  deserializeProp: _blockObjectDeserializeProp,
  idName: r'id',
  indexes: {
    r'phraseId': IndexSchema(
      id: -1936705100628921048,
      name: r'phraseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'phraseId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'contentSignature': IndexSchema(
      id: 9220733410883987810,
      name: r'contentSignature',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'contentSignature',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _blockObjectGetId,
  getLinks: _blockObjectGetLinks,
  attach: _blockObjectAttach,
  version: '3.1.0+1',
);

int _blockObjectEstimateSize(
  BlockObject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.blockTranslation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.colorHex;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.contentSignature;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _blockObjectSerialize(
  BlockObject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.blockTranslation);
  writer.writeString(offsets[1], object.colorHex);
  writer.writeString(offsets[2], object.contentSignature);
  writer.writeLong(offsets[3], object.originalPositionIndex);
  writer.writeLong(offsets[4], object.phraseId);
  writer.writeLong(offsets[5], object.translatedPositionIndex);
}

BlockObject _blockObjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BlockObject();
  object.blockTranslation = reader.readStringOrNull(offsets[0]);
  object.colorHex = reader.readStringOrNull(offsets[1]);
  object.contentSignature = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.originalPositionIndex = reader.readLongOrNull(offsets[3]);
  object.phraseId = reader.readLongOrNull(offsets[4]);
  object.translatedPositionIndex = reader.readLongOrNull(offsets[5]);
  return object;
}

P _blockObjectDeserializeProp<P>(
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
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _blockObjectGetId(BlockObject object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _blockObjectGetLinks(BlockObject object) {
  return [];
}

void _blockObjectAttach(
    IsarCollection<dynamic> col, Id id, BlockObject object) {
  object.id = id;
}

extension BlockObjectQueryWhereSort
    on QueryBuilder<BlockObject, BlockObject, QWhere> {
  QueryBuilder<BlockObject, BlockObject, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhere> anyPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'phraseId'),
      );
    });
  }
}

extension BlockObjectQueryWhere
    on QueryBuilder<BlockObject, BlockObject, QWhereClause> {
  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> idBetween(
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

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> phraseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'phraseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause>
      phraseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phraseId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> phraseIdEqualTo(
      int? phraseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'phraseId',
        value: [phraseId],
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> phraseIdNotEqualTo(
      int? phraseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phraseId',
              lower: [],
              upper: [phraseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phraseId',
              lower: [phraseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phraseId',
              lower: [phraseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phraseId',
              lower: [],
              upper: [phraseId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> phraseIdGreaterThan(
    int? phraseId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phraseId',
        lower: [phraseId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> phraseIdLessThan(
    int? phraseId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phraseId',
        lower: [],
        upper: [phraseId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause> phraseIdBetween(
    int? lowerPhraseId,
    int? upperPhraseId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phraseId',
        lower: [lowerPhraseId],
        includeLower: includeLower,
        upper: [upperPhraseId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause>
      contentSignatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'contentSignature',
        value: [null],
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause>
      contentSignatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'contentSignature',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause>
      contentSignatureEqualTo(String? contentSignature) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'contentSignature',
        value: [contentSignature],
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterWhereClause>
      contentSignatureNotEqualTo(String? contentSignature) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentSignature',
              lower: [],
              upper: [contentSignature],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentSignature',
              lower: [contentSignature],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentSignature',
              lower: [contentSignature],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'contentSignature',
              lower: [],
              upper: [contentSignature],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BlockObjectQueryFilter
    on QueryBuilder<BlockObject, BlockObject, QFilterCondition> {
  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blockTranslation',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blockTranslation',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blockTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blockTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blockTranslation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'blockTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'blockTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'blockTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'blockTranslation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blockTranslation',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      blockTranslationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'blockTranslation',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      colorHexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'colorHex',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      colorHexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'colorHex',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition> colorHexEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      colorHexGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      colorHexLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition> colorHexBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorHex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      colorHexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      colorHexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      colorHexContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition> colorHexMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'colorHex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      colorHexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      colorHexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contentSignature',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contentSignature',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentSignature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentSignature',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentSignature',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      contentSignatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentSignature',
        value: '',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      originalPositionIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'originalPositionIndex',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      originalPositionIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'originalPositionIndex',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      originalPositionIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'originalPositionIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      originalPositionIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'originalPositionIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      originalPositionIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'originalPositionIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      originalPositionIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'originalPositionIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      phraseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phraseId',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      phraseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phraseId',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition> phraseIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phraseId',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      phraseIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phraseId',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      phraseIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phraseId',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition> phraseIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phraseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      translatedPositionIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'translatedPositionIndex',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      translatedPositionIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'translatedPositionIndex',
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      translatedPositionIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translatedPositionIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      translatedPositionIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translatedPositionIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      translatedPositionIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translatedPositionIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterFilterCondition>
      translatedPositionIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translatedPositionIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BlockObjectQueryObject
    on QueryBuilder<BlockObject, BlockObject, QFilterCondition> {}

extension BlockObjectQueryLinks
    on QueryBuilder<BlockObject, BlockObject, QFilterCondition> {}

extension BlockObjectQuerySortBy
    on QueryBuilder<BlockObject, BlockObject, QSortBy> {
  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      sortByBlockTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockTranslation', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      sortByBlockTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockTranslation', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> sortByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> sortByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      sortByContentSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentSignature', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      sortByContentSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentSignature', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      sortByOriginalPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPositionIndex', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      sortByOriginalPositionIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPositionIndex', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> sortByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> sortByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      sortByTranslatedPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedPositionIndex', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      sortByTranslatedPositionIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedPositionIndex', Sort.desc);
    });
  }
}

extension BlockObjectQuerySortThenBy
    on QueryBuilder<BlockObject, BlockObject, QSortThenBy> {
  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      thenByBlockTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockTranslation', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      thenByBlockTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blockTranslation', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> thenByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> thenByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      thenByContentSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentSignature', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      thenByContentSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentSignature', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      thenByOriginalPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPositionIndex', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      thenByOriginalPositionIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'originalPositionIndex', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> thenByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy> thenByPhraseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phraseId', Sort.desc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      thenByTranslatedPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedPositionIndex', Sort.asc);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QAfterSortBy>
      thenByTranslatedPositionIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translatedPositionIndex', Sort.desc);
    });
  }
}

extension BlockObjectQueryWhereDistinct
    on QueryBuilder<BlockObject, BlockObject, QDistinct> {
  QueryBuilder<BlockObject, BlockObject, QDistinct> distinctByBlockTranslation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blockTranslation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QDistinct> distinctByColorHex(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorHex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QDistinct> distinctByContentSignature(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentSignature',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BlockObject, BlockObject, QDistinct>
      distinctByOriginalPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'originalPositionIndex');
    });
  }

  QueryBuilder<BlockObject, BlockObject, QDistinct> distinctByPhraseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phraseId');
    });
  }

  QueryBuilder<BlockObject, BlockObject, QDistinct>
      distinctByTranslatedPositionIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translatedPositionIndex');
    });
  }
}

extension BlockObjectQueryProperty
    on QueryBuilder<BlockObject, BlockObject, QQueryProperty> {
  QueryBuilder<BlockObject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BlockObject, String?, QQueryOperations>
      blockTranslationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blockTranslation');
    });
  }

  QueryBuilder<BlockObject, String?, QQueryOperations> colorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorHex');
    });
  }

  QueryBuilder<BlockObject, String?, QQueryOperations>
      contentSignatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentSignature');
    });
  }

  QueryBuilder<BlockObject, int?, QQueryOperations>
      originalPositionIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'originalPositionIndex');
    });
  }

  QueryBuilder<BlockObject, int?, QQueryOperations> phraseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phraseId');
    });
  }

  QueryBuilder<BlockObject, int?, QQueryOperations>
      translatedPositionIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translatedPositionIndex');
    });
  }
}
