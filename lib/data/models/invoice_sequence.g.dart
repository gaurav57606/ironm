// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_sequence.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInvoiceSequenceCollection on Isar {
  IsarCollection<InvoiceSequence> get invoiceSequences => this.collection();
}

const InvoiceSequenceSchema = CollectionSchema(
  name: r'InvoiceSequence',
  id: -8769776883567169139,
  properties: {
    r'lastNumber': PropertySchema(
      id: 0,
      name: r'lastNumber',
      type: IsarType.long,
    ),
    r'prefix': PropertySchema(
      id: 1,
      name: r'prefix',
      type: IsarType.string,
    )
  },
  estimateSize: _invoiceSequenceEstimateSize,
  serialize: _invoiceSequenceSerialize,
  deserialize: _invoiceSequenceDeserialize,
  deserializeProp: _invoiceSequenceDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'prefix': IndexSchema(
      id: -5274940836489658534,
      name: r'prefix',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'prefix',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _invoiceSequenceGetId,
  getLinks: _invoiceSequenceGetLinks,
  attach: _invoiceSequenceAttach,
  version: '3.1.0+1',
);

int _invoiceSequenceEstimateSize(
  InvoiceSequence object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.prefix.length * 3;
  return bytesCount;
}

void _invoiceSequenceSerialize(
  InvoiceSequence object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.lastNumber);
  writer.writeString(offsets[1], object.prefix);
}

InvoiceSequence _invoiceSequenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InvoiceSequence(
    lastNumber: reader.readLongOrNull(offsets[0]) ?? 0,
    prefix: reader.readString(offsets[1]),
  );
  object.isarId = id;
  return object;
}

P _invoiceSequenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _invoiceSequenceGetId(InvoiceSequence object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _invoiceSequenceGetLinks(InvoiceSequence object) {
  return [];
}

void _invoiceSequenceAttach(
    IsarCollection<dynamic> col, Id id, InvoiceSequence object) {
  object.isarId = id;
}

extension InvoiceSequenceByIndex on IsarCollection<InvoiceSequence> {
  Future<InvoiceSequence?> getByPrefix(String prefix) {
    return getByIndex(r'prefix', [prefix]);
  }

  InvoiceSequence? getByPrefixSync(String prefix) {
    return getByIndexSync(r'prefix', [prefix]);
  }

  Future<bool> deleteByPrefix(String prefix) {
    return deleteByIndex(r'prefix', [prefix]);
  }

  bool deleteByPrefixSync(String prefix) {
    return deleteByIndexSync(r'prefix', [prefix]);
  }

  Future<List<InvoiceSequence?>> getAllByPrefix(List<String> prefixValues) {
    final values = prefixValues.map((e) => [e]).toList();
    return getAllByIndex(r'prefix', values);
  }

  List<InvoiceSequence?> getAllByPrefixSync(List<String> prefixValues) {
    final values = prefixValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'prefix', values);
  }

  Future<int> deleteAllByPrefix(List<String> prefixValues) {
    final values = prefixValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'prefix', values);
  }

  int deleteAllByPrefixSync(List<String> prefixValues) {
    final values = prefixValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'prefix', values);
  }

  Future<Id> putByPrefix(InvoiceSequence object) {
    return putByIndex(r'prefix', object);
  }

  Id putByPrefixSync(InvoiceSequence object, {bool saveLinks = true}) {
    return putByIndexSync(r'prefix', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPrefix(List<InvoiceSequence> objects) {
    return putAllByIndex(r'prefix', objects);
  }

  List<Id> putAllByPrefixSync(List<InvoiceSequence> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'prefix', objects, saveLinks: saveLinks);
  }
}

extension InvoiceSequenceQueryWhereSort
    on QueryBuilder<InvoiceSequence, InvoiceSequence, QWhere> {
  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InvoiceSequenceQueryWhere
    on QueryBuilder<InvoiceSequence, InvoiceSequence, QWhereClause> {
  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterWhereClause>
      prefixEqualTo(String prefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'prefix',
        value: [prefix],
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterWhereClause>
      prefixNotEqualTo(String prefix) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'prefix',
              lower: [],
              upper: [prefix],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'prefix',
              lower: [prefix],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'prefix',
              lower: [prefix],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'prefix',
              lower: [],
              upper: [prefix],
              includeUpper: false,
            ));
      }
    });
  }
}

extension InvoiceSequenceQueryFilter
    on QueryBuilder<InvoiceSequence, InvoiceSequence, QFilterCondition> {
  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      isarIdGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      isarIdLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      isarIdBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      lastNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      lastNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      lastNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      lastNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prefix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prefix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prefix',
        value: '',
      ));
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterFilterCondition>
      prefixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prefix',
        value: '',
      ));
    });
  }
}

extension InvoiceSequenceQueryObject
    on QueryBuilder<InvoiceSequence, InvoiceSequence, QFilterCondition> {}

extension InvoiceSequenceQueryLinks
    on QueryBuilder<InvoiceSequence, InvoiceSequence, QFilterCondition> {}

extension InvoiceSequenceQuerySortBy
    on QueryBuilder<InvoiceSequence, InvoiceSequence, QSortBy> {
  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy>
      sortByLastNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNumber', Sort.asc);
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy>
      sortByLastNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNumber', Sort.desc);
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy> sortByPrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefix', Sort.asc);
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy>
      sortByPrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefix', Sort.desc);
    });
  }
}

extension InvoiceSequenceQuerySortThenBy
    on QueryBuilder<InvoiceSequence, InvoiceSequence, QSortThenBy> {
  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy>
      thenByLastNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNumber', Sort.asc);
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy>
      thenByLastNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastNumber', Sort.desc);
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy> thenByPrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefix', Sort.asc);
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QAfterSortBy>
      thenByPrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prefix', Sort.desc);
    });
  }
}

extension InvoiceSequenceQueryWhereDistinct
    on QueryBuilder<InvoiceSequence, InvoiceSequence, QDistinct> {
  QueryBuilder<InvoiceSequence, InvoiceSequence, QDistinct>
      distinctByLastNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastNumber');
    });
  }

  QueryBuilder<InvoiceSequence, InvoiceSequence, QDistinct> distinctByPrefix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prefix', caseSensitive: caseSensitive);
    });
  }
}

extension InvoiceSequenceQueryProperty
    on QueryBuilder<InvoiceSequence, InvoiceSequence, QQueryProperty> {
  QueryBuilder<InvoiceSequence, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<InvoiceSequence, int, QQueryOperations> lastNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastNumber');
    });
  }

  QueryBuilder<InvoiceSequence, String, QQueryOperations> prefixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prefix');
    });
  }
}
