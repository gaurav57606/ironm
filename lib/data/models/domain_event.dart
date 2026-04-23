import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

part 'domain_event.g.dart';

@collection
class DomainEvent {
  Id? isarId; // Internal Isar ID

  @Index(unique: true)
  late String id; // uuid v4

  @Index()
  late String entityId; // memberId or 'owner' or 'settings'

  @enumerated
  late EventType eventType;

  late String payloadJson;

  @Index()
  late DateTime deviceTimestamp;

  @Index()
  late bool synced;

  late String hmacSignature;

  late String deviceId;

  DomainEvent({
    this.id = '',
    required this.entityId,
    required this.eventType,
    required this.payloadJson,
    required this.deviceTimestamp,
    this.synced = false,
    this.hmacSignature = '',
    required this.deviceId,
  });

  @ignore
  Map<String, dynamic> get payload => jsonDecode(payloadJson);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entityId': entityId,
      'eventType': eventType.name,
      'payload': payload,
      'deviceTimestamp': deviceTimestamp.toUtc().toIso8601String(),
      'synced': synced,
      'hmacSignature': hmacSignature,
      'deviceId': deviceId,
    };
  }

  factory DomainEvent.fromJson(Map<String, dynamic> data) {
    return DomainEvent(
      id: data['id'],
      entityId: data['entityId'],
      eventType: EventType.values.byName(data['eventType']),
      payloadJson: jsonEncode(data['payload']),
      deviceTimestamp: DateTime.parse(data['deviceTimestamp']).toLocal(),
      synced: data['synced'] ?? false,
      hmacSignature: data['hmacSignature'] ?? '',
      deviceId: data['deviceId'],
    );
  }
}

enum EventType {
  memberCreated,
  planAssigned,
  paymentAdded,
  membershipExtended,
  joinDateEdited,
  invoiceGenerated,
  settingsChanged,
  ownerProfileCreated,
  ownerProfileUpdated,
  plansUpdated,
  memberArchived,
  memberUpdated,
  membershipRenewed,
  paymentRecorded,
  checkInRecorded,
  ownershipTransferred,
}
