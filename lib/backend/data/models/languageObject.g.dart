// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'languageObject.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLanguageObjectCollection on Isar {
  IsarCollection<LanguageObject> get languageObjects => this.collection();
}

const LanguageObjectSchema = CollectionSchema(
  name: r'LanguageObject',
  id: 1948920522814031798,
  properties: {
    r'isSupported': PropertySchema(
      id: 0,
      name: r'isSupported',
      type: IsarType.bool,
    ),
    r'language': PropertySchema(
      id: 1,
      name: r'language',
      type: IsarType.string,
    )
  },
  estimateSize: _languageObjectEstimateSize,
  serialize: _languageObjectSerialize,
  deserialize: _languageObjectDeserialize,
  deserializeProp: _languageObjectDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _languageObjectGetId,
  getLinks: _languageObjectGetLinks,
  attach: _languageObjectAttach,
  version: '3.1.0+1',
);

int _languageObjectEstimateSize(
  LanguageObject object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.language;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _languageObjectSerialize(
  LanguageObject object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isSupported);
  writer.writeString(offsets[1], object.language);
}

LanguageObject _languageObjectDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LanguageObject();
  object.id = id;
  object.isSupported = reader.readBoolOrNull(offsets[0]);
  object.language = reader.readStringOrNull(offsets[1]);
  return object;
}

P _languageObjectDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _languageObjectGetId(LanguageObject object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _languageObjectGetLinks(LanguageObject object) {
  return [];
}

void _languageObjectAttach(
    IsarCollection<dynamic> col, Id id, LanguageObject object) {
  object.id = id;
}

extension LanguageObjectQueryWhereSort
    on QueryBuilder<LanguageObject, LanguageObject, QWhere> {
  QueryBuilder<LanguageObject, LanguageObject, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LanguageObjectQueryWhere
    on QueryBuilder<LanguageObject, LanguageObject, QWhereClause> {
  QueryBuilder<LanguageObject, LanguageObject, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<LanguageObject, LanguageObject, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterWhereClause> idBetween(
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

extension LanguageObjectQueryFilter
    on QueryBuilder<LanguageObject, LanguageObject, QFilterCondition> {
  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      isSupportedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isSupported',
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      isSupportedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isSupported',
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      isSupportedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSupported',
        value: value,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'language',
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'language',
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'language',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'language',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'language',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'language',
        value: '',
      ));
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterFilterCondition>
      languageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'language',
        value: '',
      ));
    });
  }
}

extension LanguageObjectQueryObject
    on QueryBuilder<LanguageObject, LanguageObject, QFilterCondition> {}

extension LanguageObjectQueryLinks
    on QueryBuilder<LanguageObject, LanguageObject, QFilterCondition> {}

extension LanguageObjectQuerySortBy
    on QueryBuilder<LanguageObject, LanguageObject, QSortBy> {
  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy>
      sortByIsSupported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.asc);
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy>
      sortByIsSupportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.desc);
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy> sortByLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.asc);
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy>
      sortByLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.desc);
    });
  }
}

extension LanguageObjectQuerySortThenBy
    on QueryBuilder<LanguageObject, LanguageObject, QSortThenBy> {
  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy>
      thenByIsSupported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.asc);
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy>
      thenByIsSupportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSupported', Sort.desc);
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy> thenByLanguage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.asc);
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QAfterSortBy>
      thenByLanguageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'language', Sort.desc);
    });
  }
}

extension LanguageObjectQueryWhereDistinct
    on QueryBuilder<LanguageObject, LanguageObject, QDistinct> {
  QueryBuilder<LanguageObject, LanguageObject, QDistinct>
      distinctByIsSupported() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSupported');
    });
  }

  QueryBuilder<LanguageObject, LanguageObject, QDistinct> distinctByLanguage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'language', caseSensitive: caseSensitive);
    });
  }
}

extension LanguageObjectQueryProperty
    on QueryBuilder<LanguageObject, LanguageObject, QQueryProperty> {
  QueryBuilder<LanguageObject, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LanguageObject, bool?, QQueryOperations> isSupportedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSupported');
    });
  }

  QueryBuilder<LanguageObject, String?, QQueryOperations> languageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'language');
    });
  }
}
