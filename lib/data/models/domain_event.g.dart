// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDomainEventCollection on Isar {
  IsarCollection<DomainEvent> get domainEvents => this.collection();
}

const DomainEventSchema = CollectionSchema(
  name: r'DomainEvent',
  id: 123436891674528,
  properties: {
    r'deviceId': PropertySchema(
      id: 0,
      name: r'deviceId',
      type: IsarType.string,
    ),
    r'deviceTimestamp': PropertySchema(
      id: 1,
      name: r'deviceTimestamp',
      type: IsarType.dateTime,
    ),
    r'entityId': PropertySchema(
      id: 2,
      name: r'entityId',
      type: IsarType.string,
    ),
    r'eventType': PropertySchema(
      id: 3,
      name: r'eventType',
      type: IsarType.byte,
      enumMap: _DomainEventeventTypeEnumValueMap,
    ),
    r'hmacSignature': PropertySchema(
      id: 4,
      name: r'hmacSignature',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 5,
      name: r'id',
      type: IsarType.string,
    ),
    r'payloadJson': PropertySchema(
      id: 6,
      name: r'payloadJson',
      type: IsarType.string,
    ),
    r'synced': PropertySchema(
      id: 7,
      name: r'synced',
      type: IsarType.bool,
    )
  },
  estimateSize: _domainEventEstimateSize,
  serialize: _domainEventSerialize,
  deserialize: _domainEventDeserialize,
  deserializeProp: _domainEventDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -326840167399347,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'entityId': IndexSchema(
      id: 745355021660786,
      name: r'entityId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entityId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'deviceTimestamp': IndexSchema(
      id: 313892984313766,
      name: r'deviceTimestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deviceTimestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'synced': IndexSchema(
      id: -483266325641842,
      name: r'synced',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'synced',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _domainEventGetId,
  getLinks: _domainEventGetLinks,
  attach: _domainEventAttach,
  version: '3.1.0+1',
);

int _domainEventEstimateSize(
  DomainEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.deviceId.length * 3;
  bytesCount += 3 + object.entityId.length * 3;
  bytesCount += 3 + object.hmacSignature.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.payloadJson.length * 3;
  return bytesCount;
}

void _domainEventSerialize(
  DomainEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.deviceId);
  writer.writeDateTime(offsets[1], object.deviceTimestamp);
  writer.writeString(offsets[2], object.entityId);
  writer.writeByte(offsets[3], object.eventType.index);
  writer.writeString(offsets[4], object.hmacSignature);
  writer.writeString(offsets[5], object.id);
  writer.writeString(offsets[6], object.payloadJson);
  writer.writeBool(offsets[7], object.synced);
}

DomainEvent _domainEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DomainEvent(
    deviceId: reader.readString(offsets[0]),
    deviceTimestamp: reader.readDateTime(offsets[1]),
    entityId: reader.readString(offsets[2]),
    eventType:
        _DomainEventeventTypeValueEnumMap[reader.readByteOrNull(offsets[3])] ??
            EventType.memberCreated,
    hmacSignature: reader.readStringOrNull(offsets[4]) ?? '',
    id: reader.readStringOrNull(offsets[5]) ?? '',
    payloadJson: reader.readString(offsets[6]),
    synced: reader.readBoolOrNull(offsets[7]) ?? false,
  );
  object.isarId = id;
  return object;
}

P _domainEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_DomainEventeventTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          EventType.memberCreated) as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DomainEventeventTypeEnumValueMap = {
  'memberCreated': 0,
  'planAssigned': 1,
  'paymentAdded': 2,
  'membershipExtended': 3,
  'joinDateEdited': 4,
  'invoiceGenerated': 5,
  'settingsChanged': 6,
  'ownerProfileCreated': 7,
  'ownerProfileUpdated': 8,
  'plansUpdated': 9,
  'memberArchived': 10,
  'memberUpdated': 11,
  'membershipRenewed': 12,
  'paymentRecorded': 13,
  'checkInRecorded': 14,
  'ownershipTransferred': 15,
};
const _DomainEventeventTypeValueEnumMap = {
  0: EventType.memberCreated,
  1: EventType.planAssigned,
  2: EventType.paymentAdded,
  3: EventType.membershipExtended,
  4: EventType.joinDateEdited,
  5: EventType.invoiceGenerated,
  6: EventType.settingsChanged,
  7: EventType.ownerProfileCreated,
  8: EventType.ownerProfileUpdated,
  9: EventType.plansUpdated,
  10: EventType.memberArchived,
  11: EventType.memberUpdated,
  12: EventType.membershipRenewed,
  13: EventType.paymentRecorded,
  14: EventType.checkInRecorded,
  15: EventType.ownershipTransferred,
};

Id _domainEventGetId(DomainEvent object) {
  return object.isarId ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _domainEventGetLinks(DomainEvent object) {
  return [];
}

void _domainEventAttach(
    IsarCollection<dynamic> col, Id id, DomainEvent object) {
  object.isarId = id;
}

extension DomainEventByIndex on IsarCollection<DomainEvent> {
  Future<DomainEvent?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  DomainEvent? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<DomainEvent?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<DomainEvent?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(DomainEvent object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(DomainEvent object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<DomainEvent> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<DomainEvent> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension DomainEventQueryWhereSort
    on QueryBuilder<DomainEvent, DomainEvent, QWhere> {
  QueryBuilder<DomainEvent, DomainEvent, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhere> anyDeviceTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'deviceTimestamp'),
      );
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhere> anySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'synced'),
      );
    });
  }
}

extension DomainEventQueryWhere
    on QueryBuilder<DomainEvent, DomainEvent, QWhereClause> {
  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> entityIdEqualTo(
      String entityId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entityId',
        value: [entityId],
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> entityIdNotEqualTo(
      String entityId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [entityId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entityId',
              lower: [],
              upper: [entityId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause>
      deviceTimestampEqualTo(DateTime deviceTimestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deviceTimestamp',
        value: [deviceTimestamp],
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause>
      deviceTimestampNotEqualTo(DateTime deviceTimestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceTimestamp',
              lower: [],
              upper: [deviceTimestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceTimestamp',
              lower: [deviceTimestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceTimestamp',
              lower: [deviceTimestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deviceTimestamp',
              lower: [],
              upper: [deviceTimestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause>
      deviceTimestampGreaterThan(
    DateTime deviceTimestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deviceTimestamp',
        lower: [deviceTimestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause>
      deviceTimestampLessThan(
    DateTime deviceTimestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deviceTimestamp',
        lower: [],
        upper: [deviceTimestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause>
      deviceTimestampBetween(
    DateTime lowerDeviceTimestamp,
    DateTime upperDeviceTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deviceTimestamp',
        lower: [lowerDeviceTimestamp],
        includeLower: includeLower,
        upper: [upperDeviceTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> syncedEqualTo(
      bool synced) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'synced',
        value: [synced],
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterWhereClause> syncedNotEqualTo(
      bool synced) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'synced',
              lower: [],
              upper: [synced],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'synced',
              lower: [synced],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'synced',
              lower: [synced],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'synced',
              lower: [],
              upper: [synced],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DomainEventQueryFilter
    on QueryBuilder<DomainEvent, DomainEvent, QFilterCondition> {
  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> deviceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> deviceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> deviceIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceTimestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceTimestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceTimestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceTimestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      deviceTimestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceTimestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> entityIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      entityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      entityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> entityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entityId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      entityIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      entityIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      entityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entityId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> entityIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entityId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      entityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      entityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entityId',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      eventTypeEqualTo(EventType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eventType',
        value: value,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      eventTypeGreaterThan(
    EventType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eventType',
        value: value,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      eventTypeLessThan(
    EventType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eventType',
        value: value,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      eventTypeBetween(
    EventType lower,
    EventType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eventType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      hmacSignatureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hmacSignature',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      hmacSignatureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hmacSignature',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      hmacSignatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hmacSignature',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      hmacSignatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hmacSignature',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> isarIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      isarIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isarId',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> isarIdEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payloadJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'payloadJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition>
      payloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterFilterCondition> syncedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'synced',
        value: value,
      ));
    });
  }
}

extension DomainEventQueryObject
    on QueryBuilder<DomainEvent, DomainEvent, QFilterCondition> {}

extension DomainEventQueryLinks
    on QueryBuilder<DomainEvent, DomainEvent, QFilterCondition> {}

extension DomainEventQuerySortBy
    on QueryBuilder<DomainEvent, DomainEvent, QSortBy> {
  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByDeviceTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceTimestamp', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy>
      sortByDeviceTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceTimestamp', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByEventType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByEventTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByHmacSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy>
      sortByHmacSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> sortBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }
}

extension DomainEventQuerySortThenBy
    on QueryBuilder<DomainEvent, DomainEvent, QSortThenBy> {
  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByDeviceTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceTimestamp', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy>
      thenByDeviceTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceTimestamp', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByEventType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByEventTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventType', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByHmacSignature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy>
      thenByHmacSignatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hmacSignature', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.asc);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QAfterSortBy> thenBySyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'synced', Sort.desc);
    });
  }
}

extension DomainEventQueryWhereDistinct
    on QueryBuilder<DomainEvent, DomainEvent, QDistinct> {
  QueryBuilder<DomainEvent, DomainEvent, QDistinct> distinctByDeviceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QDistinct>
      distinctByDeviceTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceTimestamp');
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QDistinct> distinctByEntityId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QDistinct> distinctByEventType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventType');
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QDistinct> distinctByHmacSignature(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hmacSignature',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QDistinct> distinctByPayloadJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DomainEvent, DomainEvent, QDistinct> distinctBySynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'synced');
    });
  }
}

extension DomainEventQueryProperty
    on QueryBuilder<DomainEvent, DomainEvent, QQueryProperty> {
  QueryBuilder<DomainEvent, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<DomainEvent, String, QQueryOperations> deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceId');
    });
  }

  QueryBuilder<DomainEvent, DateTime, QQueryOperations>
      deviceTimestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceTimestamp');
    });
  }

  QueryBuilder<DomainEvent, String, QQueryOperations> entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<DomainEvent, EventType, QQueryOperations> eventTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventType');
    });
  }

  QueryBuilder<DomainEvent, String, QQueryOperations> hmacSignatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hmacSignature');
    });
  }

  QueryBuilder<DomainEvent, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DomainEvent, String, QQueryOperations> payloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadJson');
    });
  }

  QueryBuilder<DomainEvent, bool, QQueryOperations> syncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'synced');
    });
  }
}
