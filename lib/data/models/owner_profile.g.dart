// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOwnerProfileCollection on Isar {
  IsarCollection<OwnerProfile> get ownerProfiles => this.collection();
}

const OwnerProfileSchema = CollectionSchema(
  name: r'OwnerProfile',
  id: -8460503014834178897,
  properties: {
    r'accountNumber': PropertySchema(
      id: 0,
      name: r'accountNumber',
      type: IsarType.string,
    ),
    r'address': PropertySchema(
      id: 1,
      name: r'address',
      type: IsarType.string,
    ),
    r'bankName': PropertySchema(
      id: 2,
      name: r'bankName',
      type: IsarType.string,
    ),
    r'dexterity': PropertySchema(
      id: 3,
      name: r'dexterity',
      type: IsarType.double,
    ),
    r'endurance': PropertySchema(
      id: 4,
      name: r'endurance',
      type: IsarType.double,
    ),
    r'exp': PropertySchema(
      id: 5,
      name: r'exp',
      type: IsarType.long,
    ),
    r'gstin': PropertySchema(
      id: 6,
      name: r'gstin',
      type: IsarType.string,
    ),
    r'gymName': PropertySchema(
      id: 7,
      name: r'gymName',
      type: IsarType.string,
    ),
    r'hmacSignature': PropertySchema(
      id: 8,
      name: r'hmacSignature',
      type: IsarType.string,
    ),
    r'ifsc': PropertySchema(
      id: 9,
      name: r'ifsc',
      type: IsarType.string,
    ),
    r'level': PropertySchema(
      id: 10,
      name: r'level',
      type: IsarType.long,
    ),
    r'logoPath': PropertySchema(
      id: 11,
      name: r'logoPath',
      type: IsarType.string,
    ),
    r'ownerName': PropertySchema(
      id: 12,
      name: r'ownerName',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 13,
      name: r'phone',
      type: IsarType.string,
    ),
    r'selectedCharacterId': PropertySchema(
      id: 14,
      name: r'selectedCharacterId',
      type: IsarType.string,
    ),
    r'strength': PropertySchema(
      id: 15,
      name: r'strength',
      type: IsarType.double,
    ),
    r'upiId': PropertySchema(
      id: 16,
      name: r'upiId',
      type: IsarType.string,
    )
  },
  estimateSize: _ownerProfileEstimateSize,
  serialize: _ownerProfileSerialize,
  deserialize: _ownerProfileDeserialize,
  deserializeProp: _ownerProfileDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _ownerProfileGetId,
  getLinks: _ownerProfileGetLinks,
  attach: _ownerProfileAttach,
  version: '3.1.0+1',
);

int _ownerProfileEstimateSize(
  OwnerProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.accountNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.address.length * 3;
  {
    final value = object.bankName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.gstin;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.gymName.length * 3;
  bytesCount += 3 + object.hmacSignature.length * 3;
  {
    final value = object.ifsc;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.logoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.ownerName.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  bytesCount += 3 + object.selectedCharacterId.length * 3;
  {
    final value = object.upiId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _ownerProfileSerialize(
  OwnerProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountNumber);
  writer.writeString(offsets[1], object.address);
  writer.writeString(offsets[2], object.bankName);
  writer.writeDouble(offsets[3], object.dexterity);
  writer.writeDouble(offsets[4], object.endurance);
  writer.writeLong(offsets[5], object.exp);
  writer.writeString(offsets[6], object.gstin);
  writer.writeString(offsets[7], object.gymName);
  writer.writeString(offsets[8], object.hmacSignature);
  writer.writeString(offsets[9], object.ifsc);
  writer.writeLong(offsets[10], object.level);
  writer.writeString(offsets[11], object.logoPath);
  writer.writeString(offsets[12], object.ownerName);
  writer.writeString(offsets[13], object.phone);
  writer.writeString(offsets[14], object.selectedCharacterId);
  writer.writeDouble(offsets[15], object.strength);
  writer.writeString(offsets[16], object.upiId);
}

OwnerProfile _ownerProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OwnerProfile(
    accountNumber: reader.readStringOrNull(offsets[0]),
    address: reader.readStringOrNull(offsets[1]) ?? '',
    bankName: reader.readStringOrNull(offsets[2]),
    dexterity: reader.readDoubleOrNull(offsets[3]) ?? 0.5,
    endurance: reader.readDoubleOrNull(offsets[4]) ?? 0.5,
    exp: reader.readLongOrNull(offsets[5]) ?? 0,
    gstin: reader.readStringOrNull(offsets[6]),
    gymName: reader.readStringOrNull(offsets[7]) ?? '',
    hmacSignature: reader.readStringOrNull(offsets[8]) ?? '',
    ifsc: reader.readStringOrNull(offsets[9]),
    level: reader.readLongOrNull(offsets[10]) ?? 1,
    logoPath: reader.readStringOrNull(offsets[11]),
    ownerName: reader.readStringOrNull(offsets[12]) ?? '',
    phone: reader.readStringOrNull(offsets[13]) ?? '',
    selectedCharacterId: reader.readStringOrNull(offsets[14]) ?? 'warrior',
    strength: reader.readDoubleOrNull(offsets[15]) ?? 0.5,
    upiId: reader.readStringOrNull(offsets[16]),
  );
  object.isarId = id;
  return object;
}

P _ownerProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset) ?? 0.5) as P;
    case 4:
      return (reader.readDoubleOrNull(offset) ?? 0.5) as P;
    case 5:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 13:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 14:
      return (reader.readStringOrNull(offset) ?? 'warrior') as P;
    case 15:
      return (reader.readDoubleOrNull(offset) ?? 0.5) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ownerProfileGetId(OwnerProfile object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _ownerProfileGetLinks(OwnerProfile object) {
  return [];
}

void _ownerProfileAttach(
    IsarCollection<dynamic> col, Id id, OwnerProfile object) {
  object.isarId = id;
}

extension OwnerProfileQueryWhereSort
    on QueryBuilder<OwnerProfile, OwnerProfile, QWhere> {
  QueryBuilder<OwnerProfile, OwnerProfile, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension OwnerProfileQueryWhere
    on QueryBuilder<OwnerProfile, OwnerProfile, QWhereClause> {
  QueryBuilder<OwnerProfile, OwnerProfile, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterWhereClause> isarIdBetween(
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
}

extension OwnerProfileQueryFilter
    on QueryBuilder<OwnerProfile, OwnerProfile, QFilterCondition> {
  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'accountNumber',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'accountNumber',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accountNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accountNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accountNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      accountNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accountNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bankName',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bankName',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bankName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bankName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankName',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      bankNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bankName',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      dexterityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dexterity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      dexterityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dexterity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      dexterityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dexterity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      dexterityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dexterity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      enduranceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endurance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      enduranceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endurance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      enduranceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endurance',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      enduranceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endurance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> expEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exp',
        value: value,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      expGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exp',
        value: value,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> expLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exp',
        value: value,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> expBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gstinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gstin',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gstinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gstin',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> gstinEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gstinGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> gstinLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> gstinBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gstin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gstinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> gstinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> gstinContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gstin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> gstinMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gstin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gstinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gstin',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gstinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gstin',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gymName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gymName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gymName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gymName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gymName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gymName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gymName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gymName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gymName',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      gymNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gymName',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hmacSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hmacSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hmacSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hmacSignature',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hmacSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hmacSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hmacSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hmacSignature',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hmacSignature',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      hmacSignatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hmacSignature',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> ifscIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ifsc',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ifscIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ifsc',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> ifscEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ifsc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ifscGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ifsc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> ifscLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ifsc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> ifscBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ifsc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ifscStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ifsc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> ifscEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ifsc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> ifscContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ifsc',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> ifscMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ifsc',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ifscIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ifsc',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ifscIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ifsc',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> isarIdEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
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

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
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

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> levelEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> levelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'logoPath',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'logoPath',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      logoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      ownerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerName',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> phoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> phoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedCharacterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedCharacterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedCharacterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedCharacterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedCharacterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedCharacterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedCharacterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedCharacterId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedCharacterId',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      selectedCharacterIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedCharacterId',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      strengthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strength',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      strengthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'strength',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      strengthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'strength',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      strengthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'strength',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      upiIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'upiId',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      upiIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'upiId',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> upiIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      upiIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'upiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> upiIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'upiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> upiIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'upiId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      upiIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'upiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> upiIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'upiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> upiIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'upiId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition> upiIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'upiId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      upiIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'upiId',
        value: '',
      ));
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterFilterCondition>
      upiIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'upiId',
        value: '',
      ));
    });
  }
}

extension OwnerProfileQueryObject
    on QueryBuilder<OwnerProfile, OwnerProfile, QFilterCondition> {}

extension OwnerProfileQueryLinks
    on QueryBuilder<OwnerProfile, OwnerProfile, QFilterCondition> {}

extension OwnerProfileQuerySortBy
    on QueryBuilder<OwnerProfile, OwnerProfile, QSortBy> {
  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy>
      sortByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByBankName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByBankNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByDexterity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dexterity', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByDexterityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dexterity', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByEndurance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endurance', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByEnduranceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endurance', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByExp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exp', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByExpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exp', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByGstin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstin', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByGstinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstin', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByGymName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gymName', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByGymNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gymName', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByHmacSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy>
      sortByHmacSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByIfsc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ifsc', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByIfscDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ifsc', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy>
      sortBySelectedCharacterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedCharacterId', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy>
      sortBySelectedCharacterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedCharacterId', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByStrength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strength', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByStrengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strength', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByUpiId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upiId', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> sortByUpiIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upiId', Sort.desc);
    });
  }
}

extension OwnerProfileQuerySortThenBy
    on QueryBuilder<OwnerProfile, OwnerProfile, QSortThenBy> {
  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy>
      thenByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByBankName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByBankNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByDexterity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dexterity', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByDexterityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dexterity', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByEndurance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endurance', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByEnduranceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endurance', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByExp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exp', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByExpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exp', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByGstin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstin', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByGstinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstin', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByGymName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gymName', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByGymNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gymName', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByHmacSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy>
      thenByHmacSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByIfsc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ifsc', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByIfscDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ifsc', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByOwnerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByOwnerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerName', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy>
      thenBySelectedCharacterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedCharacterId', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy>
      thenBySelectedCharacterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedCharacterId', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByStrength() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strength', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByStrengthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'strength', Sort.desc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByUpiId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upiId', Sort.asc);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QAfterSortBy> thenByUpiIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'upiId', Sort.desc);
    });
  }
}

extension OwnerProfileQueryWhereDistinct
    on QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> {
  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByAccountNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByBankName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByDexterity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dexterity');
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByEndurance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endurance');
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByExp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exp');
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByGstin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gstin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByGymName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gymName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByHmacSignature(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hmacSignature',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByIfsc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ifsc', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByLogoPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoPath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByOwnerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct>
      distinctBySelectedCharacterId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedCharacterId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByStrength() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'strength');
    });
  }

  QueryBuilder<OwnerProfile, OwnerProfile, QDistinct> distinctByUpiId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'upiId', caseSensitive: caseSensitive);
    });
  }
}

extension OwnerProfileQueryProperty
    on QueryBuilder<OwnerProfile, OwnerProfile, QQueryProperty> {
  QueryBuilder<OwnerProfile, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<OwnerProfile, String?, QQueryOperations>
      accountNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountNumber');
    });
  }

  QueryBuilder<OwnerProfile, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<OwnerProfile, String?, QQueryOperations> bankNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankName');
    });
  }

  QueryBuilder<OwnerProfile, double, QQueryOperations> dexterityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dexterity');
    });
  }

  QueryBuilder<OwnerProfile, double, QQueryOperations> enduranceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endurance');
    });
  }

  QueryBuilder<OwnerProfile, int, QQueryOperations> expProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exp');
    });
  }

  QueryBuilder<OwnerProfile, String?, QQueryOperations> gstinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gstin');
    });
  }

  QueryBuilder<OwnerProfile, String, QQueryOperations> gymNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gymName');
    });
  }

  QueryBuilder<OwnerProfile, String, QQueryOperations> hmacSignatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hmacSignature');
    });
  }

  QueryBuilder<OwnerProfile, String?, QQueryOperations> ifscProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ifsc');
    });
  }

  QueryBuilder<OwnerProfile, int, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<OwnerProfile, String?, QQueryOperations> logoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoPath');
    });
  }

  QueryBuilder<OwnerProfile, String, QQueryOperations> ownerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerName');
    });
  }

  QueryBuilder<OwnerProfile, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<OwnerProfile, String, QQueryOperations>
      selectedCharacterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedCharacterId');
    });
  }

  QueryBuilder<OwnerProfile, double, QQueryOperations> strengthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'strength');
    });
  }

  QueryBuilder<OwnerProfile, String?, QQueryOperations> upiIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'upiId');
    });
  }
}
