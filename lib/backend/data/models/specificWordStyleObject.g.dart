// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specificWordStyleObject.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSpecificWordStyleObjectCollection on Isar {
  IsarCollection<SpecificWordStyleObject> get specificWordStyleObjects =>
      this.collection();
}

const SpecificWordStyleObjectSchema = CollectionSchema(
  name: r'SpecificWordStyleObject',
  id: 1833036546679528690,
  properties: {
    r'borderColorValue': PropertySchema(
      id: 0,
      name: r'borderColorValue',
      type: IsarType.long,
    ),
    r'borderSize': PropertySchema(
      id: 1,
      name: r'borderSize',
      type: IsarType.long,
    ),
    r'colorValue': PropertySchema(
      id: 2,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'fontWeightIndex': PropertySchema(
      id: 3,
      name: r'fontWeightIndex',
      type: IsarType.long,
    ),
    r'name': PropertySchema(id: 4, name: r'name', type: IsarType.string),
  },

  estimateSize: _specificWordStyleObjectEstimateSize,
  serialize: _specificWordStyleObjectSerialize,
  deserialize: _specificWordStyleObjectDeserialize,
  deserializeProp: _specificWordStyleObjectDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _specificWordStyleObjectGetId,
  getLinks: _specificWordStyleObjectGetLinks,
  attach: _specificWordStyleObjectAttach,
  version: '3.3.2',
);

int _specificWordStyleObjectEstimateSize(
  SpecificWordStyleObject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _specificWordStyleObjectSerialize(
  SpecificWordStyleObject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.borderColorValue);
  writer.writeLong(offsets[1], object.borderSize);
  writer.writeLong(offsets[2], object.colorValue);
  writer.writeLong(offsets[3], object.fontWeightIndex);
  writer.writeString(offsets[4], object.name);
}

SpecificWordStyleObject _specificWordStyleObjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SpecificWordStyleObject();
  object.borderColorValue = reader.readLong(offsets[0]);
  object.borderSize = reader.readLong(offsets[1]);
  object.colorValue = reader.readLong(offsets[2]);
  object.fontWeightIndex = reader.readLong(offsets[3]);
  object.id = id;
  object.name = reader.readStringOrNull(offsets[4]);
  return object;
}

P _specificWordStyleObjectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _specificWordStyleObjectGetId(SpecificWordStyleObject object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _specificWordStyleObjectGetLinks(
  SpecificWordStyleObject object,
) {
  return [];
}

void _specificWordStyleObjectAttach(
  IsarCollection<dynamic> col,
  Id id,
  SpecificWordStyleObject object,
) {
  object.id = id;
}

extension SpecificWordStyleObjectQueryWhereSort
    on QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QWhere> {
  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SpecificWordStyleObjectQueryWhere
    on
        QueryBuilder<
          SpecificWordStyleObject,
          SpecificWordStyleObject,
          QWhereClause
        > {
  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterWhereClause
  >
  idNotEqualTo(Id id) {
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

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterWhereClause
  >
  idBetween(
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

extension SpecificWordStyleObjectQueryFilter
    on
        QueryBuilder<
          SpecificWordStyleObject,
          SpecificWordStyleObject,
          QFilterCondition
        > {
  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  borderColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderColorValue', value: value),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  borderColorValueGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderColorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  borderColorValueLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderColorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  borderColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderColorValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  borderSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'borderSize', value: value),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  borderSizeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'borderSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  borderSizeLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'borderSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  borderSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'borderSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  colorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'colorValue', value: value),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  colorValueGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'colorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  colorValueLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'colorValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'colorValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  fontWeightIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fontWeightIndex', value: value),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  fontWeightIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fontWeightIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  fontWeightIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fontWeightIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  fontWeightIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fontWeightIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  idBetween(
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

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'name'),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'name'),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    SpecificWordStyleObject,
    SpecificWordStyleObject,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }
}

extension SpecificWordStyleObjectQueryObject
    on
        QueryBuilder<
          SpecificWordStyleObject,
          SpecificWordStyleObject,
          QFilterCondition
        > {}

extension SpecificWordStyleObjectQueryLinks
    on
        QueryBuilder<
          SpecificWordStyleObject,
          SpecificWordStyleObject,
          QFilterCondition
        > {}

extension SpecificWordStyleObjectQuerySortBy
    on QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QSortBy> {
  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByBorderColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderColorValue', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByBorderColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderColorValue', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByBorderSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderSize', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByBorderSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderSize', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByFontWeightIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontWeightIndex', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByFontWeightIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontWeightIndex', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension SpecificWordStyleObjectQuerySortThenBy
    on
        QueryBuilder<
          SpecificWordStyleObject,
          SpecificWordStyleObject,
          QSortThenBy
        > {
  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByBorderColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderColorValue', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByBorderColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderColorValue', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByBorderSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderSize', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByBorderSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'borderSize', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByFontWeightIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontWeightIndex', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByFontWeightIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontWeightIndex', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension SpecificWordStyleObjectQueryWhereDistinct
    on
        QueryBuilder<
          SpecificWordStyleObject,
          SpecificWordStyleObject,
          QDistinct
        > {
  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QDistinct>
  distinctByBorderColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'borderColorValue');
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QDistinct>
  distinctByBorderSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'borderSize');
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QDistinct>
  distinctByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorValue');
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QDistinct>
  distinctByFontWeightIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontWeightIndex');
    });
  }

  QueryBuilder<SpecificWordStyleObject, SpecificWordStyleObject, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension SpecificWordStyleObjectQueryProperty
    on
        QueryBuilder<
          SpecificWordStyleObject,
          SpecificWordStyleObject,
          QQueryProperty
        > {
  QueryBuilder<SpecificWordStyleObject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SpecificWordStyleObject, int, QQueryOperations>
  borderColorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'borderColorValue');
    });
  }

  QueryBuilder<SpecificWordStyleObject, int, QQueryOperations>
  borderSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'borderSize');
    });
  }

  QueryBuilder<SpecificWordStyleObject, int, QQueryOperations>
  colorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorValue');
    });
  }

  QueryBuilder<SpecificWordStyleObject, int, QQueryOperations>
  fontWeightIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontWeightIndex');
    });
  }

  QueryBuilder<SpecificWordStyleObject, String?, QQueryOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
