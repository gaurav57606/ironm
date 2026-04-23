import 'package:flutter/foundation.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/domain_event.dart';
import 'package:ironm/core/constants/event_payload_keys.dart';

/// Aggregator logic to apply events to Member snapshots (Event Sourcing).
class SnapshotBuilder {
  /// Applies a single event to a member and returns the new state.
  static Member? apply(Member? current, DomainEvent event) {
    final payload = event.payload;
    final type = event.eventType;

    if (type == EventType.memberCreated) {
      final joinDateStr = payload[EventPayloadKeys.joinDate] as String?;
      final joinDate = joinDateStr != null ? DateTime.parse(joinDateStr) : event.deviceTimestamp;
      
      return Member(
        memberId: event.entityId,
        name: payload[EventPayloadKeys.name] ?? '',
        phone: payload[EventPayloadKeys.phone] ?? '',
        joinDate: joinDate,
        lastUpdated: event.deviceTimestamp,
      );
    }

    if (current == null) return null;

    if (type == EventType.paymentRecorded || 
        type == EventType.membershipExtended || 
        type == EventType.membershipRenewed) {
      
      final amount = payload[EventPayloadKeys.amount] as num?;
      final newExpiryStr = payload[EventPayloadKeys.newExpiry] as String?;
      final newExpiry = newExpiryStr != null ? DateTime.parse(newExpiryStr) : null;
      
      current.totalPaid += (amount?.toInt() ?? 0);
      if (newExpiry != null) {
        current.expiryDate = newExpiry;
      }
      
      final paymentId = payload[EventPayloadKeys.paymentId] ?? event.id;
      if (!current.paymentIds.contains(paymentId)) {
        current.paymentIds = [...current.paymentIds, paymentId];
      }
      
      current.lastUpdated = event.deviceTimestamp;
      return current;
    }

    if (type == EventType.planAssigned) {
      current.planId = payload[EventPayloadKeys.planId];
      current.planName = payload[EventPayloadKeys.planName];
      current.lastUpdated = event.deviceTimestamp;
      return current;
    }

    if (type == EventType.checkInRecorded) {
      current.lastCheckIn = event.deviceTimestamp;
      current.lastCheckInDevice = event.deviceId;
      current.lastUpdated = event.deviceTimestamp;
      return current;
    }

    if (type == EventType.memberArchived) {
      current.archived = true;
      current.lastUpdated = event.deviceTimestamp;
      return current;
    }

    if (type == EventType.memberUpdated) {
      current.name = payload[EventPayloadKeys.name] ?? current.name;
      current.phone = payload[EventPayloadKeys.phone] ?? current.phone;
      current.profileImageUrl = payload[EventPayloadKeys.profileImageUrl] ?? current.profileImageUrl;
      current.lastUpdated = event.deviceTimestamp;
      return current;
    }

    return current;
  }

  /// Rebuilds a member from a full list of events.
  static Member? rebuild(List<DomainEvent> events) {
    if (events.isEmpty) return null;
    
    // Ensure chronological order
    final sortedEvents = List<DomainEvent>.from(events)
      ..sort((a, b) => a.deviceTimestamp.compareTo(b.deviceTimestamp));
    
    Member? state;
    for (final event in sortedEvents) {
      try {
        state = apply(state, event);
      } catch (e) {
        debugPrint('SnapshotBuilder: Error applying event ${event.id}: $e');
      }
    }
    return state;
  }
}
