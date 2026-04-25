// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMemberCollection on Isar {
  IsarCollection<Member> get members => this.collection();
}

const MemberSchema = CollectionSchema(
  name: r'Member',
  id: -635267144951875289,
  properties: {
    r'age': PropertySchema(
      id: 0,
      name: r'age',
      type: IsarType.long,
    ),
    r'archived': PropertySchema(
      id: 1,
      name: r'archived',
      type: IsarType.bool,
    ),
    r'checkInPin': PropertySchema(
      id: 2,
      name: r'checkInPin',
      type: IsarType.string,
    ),
    r'expiryDate': PropertySchema(
      id: 3,
      name: r'expiryDate',
      type: IsarType.dateTime,
    ),
    r'gender': PropertySchema(
      id: 4,
      name: r'gender',
      type: IsarType.string,
    ),
    r'hmacSignature': PropertySchema(
      id: 5,
      name: r'hmacSignature',
      type: IsarType.string,
    ),
    r'joinDate': PropertySchema(
      id: 6,
      name: r'joinDate',
      type: IsarType.dateTime,
    ),
    r'joinDateHistory': PropertySchema(
      id: 7,
      name: r'joinDateHistory',
      type: IsarType.objectList,
      target: r'JoinDateChange',
    ),
    r'lastCheckIn': PropertySchema(
      id: 8,
      name: r'lastCheckIn',
      type: IsarType.dateTime,
    ),
    r'lastCheckInDevice': PropertySchema(
      id: 9,
      name: r'lastCheckInDevice',
      type: IsarType.string,
    ),
    r'lastUpdated': PropertySchema(
      id: 10,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'memberId': PropertySchema(
      id: 11,
      name: r'memberId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 12,
      name: r'name',
      type: IsarType.string,
    ),
    r'paymentIds': PropertySchema(
      id: 13,
      name: r'paymentIds',
      type: IsarType.stringList,
    ),
    r'phone': PropertySchema(
      id: 14,
      name: r'phone',
      type: IsarType.string,
    ),
    r'planId': PropertySchema(
      id: 15,
      name: r'planId',
      type: IsarType.string,
    ),
    r'planName': PropertySchema(
      id: 16,
      name: r'planName',
      type: IsarType.string,
    ),
    r'planPrice': PropertySchema(
      id: 17,
      name: r'planPrice',
      type: IsarType.double,
    ),
    r'profileImageUrl': PropertySchema(
      id: 18,
      name: r'profileImageUrl',
      type: IsarType.string,
    ),
    r'totalPaid': PropertySchema(
      id: 19,
      name: r'totalPaid',
      type: IsarType.long,
    )
  },
  estimateSize: _memberEstimateSize,
  serialize: _memberSerialize,
  deserialize: _memberDeserialize,
  deserializeProp: _memberDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'memberId': IndexSchema(
      id: 5707689632932325803,
      name: r'memberId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'memberId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'phone': IndexSchema(
      id: -6308098324157559207,
      name: r'phone',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'phone',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'archived': IndexSchema(
      id: 1684088774236579907,
      name: r'archived',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'archived',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'JoinDateChange': JoinDateChangeSchema},
  getId: _memberGetId,
  getLinks: _memberGetLinks,
  attach: _memberAttach,
  version: '3.1.0+1',
);

int _memberEstimateSize(
  Member object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.checkInPin;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.gender;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.hmacSignature.length * 3;
  bytesCount += 3 + object.joinDateHistory.length * 3;
  {
    final offsets = allOffsets[JoinDateChange]!;
    for (var i = 0; i < object.joinDateHistory.length; i++) {
      final value = object.joinDateHistory[i];
      bytesCount +=
          JoinDateChangeSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.lastCheckInDevice;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.memberId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.paymentIds.length * 3;
  {
    for (var i = 0; i < object.paymentIds.length; i++) {
      final value = object.paymentIds[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.phone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.planId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.planName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.profileImageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _memberSerialize(
  Member object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.age);
  writer.writeBool(offsets[1], object.archived);
  writer.writeString(offsets[2], object.checkInPin);
  writer.writeDateTime(offsets[3], object.expiryDate);
  writer.writeString(offsets[4], object.gender);
  writer.writeString(offsets[5], object.hmacSignature);
  writer.writeDateTime(offsets[6], object.joinDate);
  writer.writeObjectList<JoinDateChange>(
    offsets[7],
    allOffsets,
    JoinDateChangeSchema.serialize,
    object.joinDateHistory,
  );
  writer.writeDateTime(offsets[8], object.lastCheckIn);
  writer.writeString(offsets[9], object.lastCheckInDevice);
  writer.writeDateTime(offsets[10], object.lastUpdated);
  writer.writeString(offsets[11], object.memberId);
  writer.writeString(offsets[12], object.name);
  writer.writeStringList(offsets[13], object.paymentIds);
  writer.writeString(offsets[14], object.phone);
  writer.writeString(offsets[15], object.planId);
  writer.writeString(offsets[16], object.planName);
  writer.writeDouble(offsets[17], object.planPrice);
  writer.writeString(offsets[18], object.profileImageUrl);
  writer.writeLong(offsets[19], object.totalPaid);
}

Member _memberDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Member(
    age: reader.readLongOrNull(offsets[0]),
    archived: reader.readBoolOrNull(offsets[1]) ?? false,
    checkInPin: reader.readStringOrNull(offsets[2]),
    expiryDate: reader.readDateTimeOrNull(offsets[3]),
    gender: reader.readStringOrNull(offsets[4]),
    hmacSignature: reader.readStringOrNull(offsets[5]) ?? '',
    joinDate: reader.readDateTime(offsets[6]),
    joinDateHistory: reader.readObjectList<JoinDateChange>(
          offsets[7],
          JoinDateChangeSchema.deserialize,
          allOffsets,
          JoinDateChange(),
        ) ??
        const [],
    lastCheckIn: reader.readDateTimeOrNull(offsets[8]),
    lastCheckInDevice: reader.readStringOrNull(offsets[9]),
    lastUpdated: reader.readDateTime(offsets[10]),
    memberId: reader.readString(offsets[11]),
    name: reader.readString(offsets[12]),
    paymentIds: reader.readStringList(offsets[13]) ?? const [],
    phone: reader.readStringOrNull(offsets[14]),
    planId: reader.readStringOrNull(offsets[15]),
    planName: reader.readStringOrNull(offsets[16]),
    planPrice: reader.readDoubleOrNull(offsets[17]),
    profileImageUrl: reader.readStringOrNull(offsets[18]),
    totalPaid: reader.readLongOrNull(offsets[19]) ?? 0,
  );
  object.isarId = id;
  return object;
}

P _memberDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readObjectList<JoinDateChange>(
            offset,
            JoinDateChangeSchema.deserialize,
            allOffsets,
            JoinDateChange(),
          ) ??
          const []) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringList(offset) ?? const []) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readDoubleOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _memberGetId(Member object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _memberGetLinks(Member object) {
  return [];
}

void _memberAttach(IsarCollection<dynamic> col, Id id, Member object) {
  object.isarId = id;
}

extension MemberByIndex on IsarCollection<Member> {
  Future<Member?> getByMemberId(String memberId) {
    return getByIndex(r'memberId', [memberId]);
  }

  Member? getByMemberIdSync(String memberId) {
    return getByIndexSync(r'memberId', [memberId]);
  }

  Future<bool> deleteByMemberId(String memberId) {
    return deleteByIndex(r'memberId', [memberId]);
  }

  bool deleteByMemberIdSync(String memberId) {
    return deleteByIndexSync(r'memberId', [memberId]);
  }

  Future<List<Member?>> getAllByMemberId(List<String> memberIdValues) {
    final values = memberIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'memberId', values);
  }

  List<Member?> getAllByMemberIdSync(List<String> memberIdValues) {
    final values = memberIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'memberId', values);
  }

  Future<int> deleteAllByMemberId(List<String> memberIdValues) {
    final values = memberIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'memberId', values);
  }

  int deleteAllByMemberIdSync(List<String> memberIdValues) {
    final values = memberIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'memberId', values);
  }

  Future<Id> putByMemberId(Member object) {
    return putByIndex(r'memberId', object);
  }

  Id putByMemberIdSync(Member object, {bool saveLinks = true}) {
    return putByIndexSync(r'memberId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMemberId(List<Member> objects) {
    return putAllByIndex(r'memberId', objects);
  }

  List<Id> putAllByMemberIdSync(List<Member> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'memberId', objects, saveLinks: saveLinks);
  }
}

extension MemberQueryWhereSort on QueryBuilder<Member, Member, QWhere> {
  QueryBuilder<Member, Member, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Member, Member, QAfterWhere> anyArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'archived'),
      );
    });
  }
}

extension MemberQueryWhere on QueryBuilder<Member, Member, QWhereClause> {
  QueryBuilder<Member, Member, QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<Member, Member, QAfterWhereClause> isarIdGreaterThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> isarIdLessThan(Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<Member, Member, QAfterWhereClause> memberIdEqualTo(
      String memberId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'memberId',
        value: [memberId],
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> memberIdNotEqualTo(
      String memberId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'memberId',
              lower: [],
              upper: [memberId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'memberId',
              lower: [memberId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'memberId',
              lower: [memberId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'memberId',
              lower: [],
              upper: [memberId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> nameEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> nameNotEqualTo(String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'phone',
        value: [null],
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'phone',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> phoneEqualTo(String? phone) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'phone',
        value: [phone],
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> phoneNotEqualTo(
      String? phone) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phone',
              lower: [],
              upper: [phone],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phone',
              lower: [phone],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phone',
              lower: [phone],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'phone',
              lower: [],
              upper: [phone],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> archivedEqualTo(
      bool archived) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'archived',
        value: [archived],
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterWhereClause> archivedNotEqualTo(
      bool archived) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'archived',
              lower: [],
              upper: [archived],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'archived',
              lower: [archived],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'archived',
              lower: [archived],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'archived',
              lower: [],
              upper: [archived],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MemberQueryFilter on QueryBuilder<Member, Member, QFilterCondition> {
  QueryBuilder<Member, Member, QAfterFilterCondition> ageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'age',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> ageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'age',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> ageEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> ageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> ageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'age',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> ageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'age',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> archivedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'archived',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checkInPin',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checkInPin',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkInPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkInPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkInPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkInPin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checkInPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checkInPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checkInPin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checkInPin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkInPin',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> checkInPinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checkInPin',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> expiryDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expiryDate',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> expiryDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expiryDate',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> expiryDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> expiryDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> expiryDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expiryDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> expiryDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expiryDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> hmacSignatureEqualTo(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> hmacSignatureGreaterThan(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> hmacSignatureLessThan(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> hmacSignatureBetween(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> hmacSignatureStartsWith(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> hmacSignatureEndsWith(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> hmacSignatureContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hmacSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> hmacSignatureMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hmacSignature',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> hmacSignatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hmacSignature',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      hmacSignatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hmacSignature',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> isarIdEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> joinDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'joinDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> joinDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'joinDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> joinDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'joinDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> joinDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'joinDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      joinDateHistoryLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinDateHistory',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> joinDateHistoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinDateHistory',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      joinDateHistoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinDateHistory',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      joinDateHistoryLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinDateHistory',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      joinDateHistoryLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinDateHistory',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      joinDateHistoryLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'joinDateHistory',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCheckIn',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCheckIn',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCheckIn',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCheckIn',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCheckIn',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCheckIn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      lastCheckInDeviceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCheckInDevice',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      lastCheckInDeviceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCheckInDevice',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInDeviceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCheckInDevice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      lastCheckInDeviceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCheckInDevice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInDeviceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCheckInDevice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInDeviceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCheckInDevice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      lastCheckInDeviceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastCheckInDevice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInDeviceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastCheckInDevice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInDeviceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastCheckInDevice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastCheckInDeviceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastCheckInDevice',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      lastCheckInDeviceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCheckInDevice',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      lastCheckInDeviceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastCheckInDevice',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastUpdatedEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memberId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'memberId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'memberId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'memberId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'memberId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'memberId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'memberId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'memberId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'memberId',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> memberIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'memberId',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      paymentIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      paymentIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsElementContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      paymentIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentIds',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      paymentIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentIds',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paymentIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paymentIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paymentIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paymentIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      paymentIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paymentIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> paymentIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paymentIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneEqualTo(
    String? value, {
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

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneGreaterThan(
    String? value, {
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

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneLessThan(
    String? value, {
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

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneStartsWith(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneEndsWith(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneContains(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneMatches(
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

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'planId',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'planId',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'planName',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'planName',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planName',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planName',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'planPrice',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planPriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'planPrice',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planPriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planPriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planPriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> planPriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> profileImageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profileImageUrl',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      profileImageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profileImageUrl',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> profileImageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      profileImageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profileImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> profileImageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profileImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> profileImageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profileImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> profileImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profileImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> profileImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profileImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> profileImageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profileImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> profileImageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profileImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> profileImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition>
      profileImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profileImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> totalPaidEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalPaid',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> totalPaidGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalPaid',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> totalPaidLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalPaid',
        value: value,
      ));
    });
  }

  QueryBuilder<Member, Member, QAfterFilterCondition> totalPaidBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalPaid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MemberQueryObject on QueryBuilder<Member, Member, QFilterCondition> {
  QueryBuilder<Member, Member, QAfterFilterCondition> joinDateHistoryElement(
      FilterQuery<JoinDateChange> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'joinDateHistory');
    });
  }
}

extension MemberQueryLinks on QueryBuilder<Member, Member, QFilterCondition> {}

extension MemberQuerySortBy on QueryBuilder<Member, Member, QSortBy> {
  QueryBuilder<Member, Member, QAfterSortBy> sortByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archived', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archived', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByCheckInPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInPin', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByCheckInPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInPin', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByHmacSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByHmacSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByJoinDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'joinDate', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByJoinDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'joinDate', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByLastCheckIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckIn', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByLastCheckInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckIn', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByLastCheckInDevice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInDevice', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByLastCheckInDeviceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInDevice', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByMemberId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByMemberIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByPlanName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByPlanNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByPlanPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planPrice', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByPlanPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planPrice', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByProfileImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileImageUrl', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByProfileImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileImageUrl', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByTotalPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPaid', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> sortByTotalPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPaid', Sort.desc);
    });
  }
}

extension MemberQuerySortThenBy on QueryBuilder<Member, Member, QSortThenBy> {
  QueryBuilder<Member, Member, QAfterSortBy> thenByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByAgeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'age', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archived', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archived', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByCheckInPin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInPin', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByCheckInPinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInPin', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByExpiryDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expiryDate', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByHmacSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByHmacSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByJoinDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'joinDate', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByJoinDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'joinDate', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByLastCheckIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckIn', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByLastCheckInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckIn', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByLastCheckInDevice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInDevice', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByLastCheckInDeviceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInDevice', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByMemberId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByMemberIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'memberId', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByPlanName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByPlanNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planName', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByPlanPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planPrice', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByPlanPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planPrice', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByProfileImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileImageUrl', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByProfileImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileImageUrl', Sort.desc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByTotalPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPaid', Sort.asc);
    });
  }

  QueryBuilder<Member, Member, QAfterSortBy> thenByTotalPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPaid', Sort.desc);
    });
  }
}

extension MemberQueryWhereDistinct on QueryBuilder<Member, Member, QDistinct> {
  QueryBuilder<Member, Member, QDistinct> distinctByAge() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'age');
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'archived');
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByCheckInPin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkInPin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByExpiryDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expiryDate');
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByGender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByHmacSignature(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hmacSignature',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByJoinDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'joinDate');
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByLastCheckIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCheckIn');
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByLastCheckInDevice(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCheckInDevice',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByMemberId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'memberId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByPaymentIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentIds');
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByPlanId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByPlanName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByPlanPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planPrice');
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByProfileImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Member, Member, QDistinct> distinctByTotalPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPaid');
    });
  }
}

extension MemberQueryProperty on QueryBuilder<Member, Member, QQueryProperty> {
  QueryBuilder<Member, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<Member, int?, QQueryOperations> ageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'age');
    });
  }

  QueryBuilder<Member, bool, QQueryOperations> archivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'archived');
    });
  }

  QueryBuilder<Member, String?, QQueryOperations> checkInPinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkInPin');
    });
  }

  QueryBuilder<Member, DateTime?, QQueryOperations> expiryDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expiryDate');
    });
  }

  QueryBuilder<Member, String?, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<Member, String, QQueryOperations> hmacSignatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hmacSignature');
    });
  }

  QueryBuilder<Member, DateTime, QQueryOperations> joinDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'joinDate');
    });
  }

  QueryBuilder<Member, List<JoinDateChange>, QQueryOperations>
      joinDateHistoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'joinDateHistory');
    });
  }

  QueryBuilder<Member, DateTime?, QQueryOperations> lastCheckInProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCheckIn');
    });
  }

  QueryBuilder<Member, String?, QQueryOperations> lastCheckInDeviceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCheckInDevice');
    });
  }

  QueryBuilder<Member, DateTime, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<Member, String, QQueryOperations> memberIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'memberId');
    });
  }

  QueryBuilder<Member, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Member, List<String>, QQueryOperations> paymentIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentIds');
    });
  }

  QueryBuilder<Member, String?, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }

  QueryBuilder<Member, String?, QQueryOperations> planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<Member, String?, QQueryOperations> planNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planName');
    });
  }

  QueryBuilder<Member, double?, QQueryOperations> planPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planPrice');
    });
  }

  QueryBuilder<Member, String?, QQueryOperations> profileImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileImageUrl');
    });
  }

  QueryBuilder<Member, int, QQueryOperations> totalPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPaid');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const JoinDateChangeSchema = Schema(
  name: r'JoinDateChange',
  id: 5353334090935177677,
  properties: {
    r'changedAt': PropertySchema(
      id: 0,
      name: r'changedAt',
      type: IsarType.dateTime,
    ),
    r'newDate': PropertySchema(
      id: 1,
      name: r'newDate',
      type: IsarType.dateTime,
    ),
    r'previousDate': PropertySchema(
      id: 2,
      name: r'previousDate',
      type: IsarType.dateTime,
    ),
    r'reason': PropertySchema(
      id: 3,
      name: r'reason',
      type: IsarType.string,
    )
  },
  estimateSize: _joinDateChangeEstimateSize,
  serialize: _joinDateChangeSerialize,
  deserialize: _joinDateChangeDeserialize,
  deserializeProp: _joinDateChangeDeserializeProp,
);

int _joinDateChangeEstimateSize(
  JoinDateChange object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.reason;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _joinDateChangeSerialize(
  JoinDateChange object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.changedAt);
  writer.writeDateTime(offsets[1], object.newDate);
  writer.writeDateTime(offsets[2], object.previousDate);
  writer.writeString(offsets[3], object.reason);
}

JoinDateChange _joinDateChangeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = JoinDateChange(
    changedAt: reader.readDateTimeOrNull(offsets[0]),
    newDate: reader.readDateTimeOrNull(offsets[1]),
    previousDate: reader.readDateTimeOrNull(offsets[2]),
    reason: reader.readStringOrNull(offsets[3]),
  );
  return object;
}

P _joinDateChangeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension JoinDateChangeQueryFilter
    on QueryBuilder<JoinDateChange, JoinDateChange, QFilterCondition> {
  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      changedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'changedAt',
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      changedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'changedAt',
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      changedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'changedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      changedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'changedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      changedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'changedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      changedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'changedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      newDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'newDate',
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      newDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'newDate',
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      newDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'newDate',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      newDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'newDate',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      newDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'newDate',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      newDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'newDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      previousDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'previousDate',
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      previousDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'previousDate',
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      previousDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previousDate',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      previousDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previousDate',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      previousDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previousDate',
        value: value,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      previousDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previousDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reason',
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reason',
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reason',
        value: '',
      ));
    });
  }

  QueryBuilder<JoinDateChange, JoinDateChange, QAfterFilterCondition>
      reasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reason',
        value: '',
      ));
    });
  }
}

extension JoinDateChangeQueryObject
    on QueryBuilder<JoinDateChange, JoinDateChange, QFilterCondition> {}
