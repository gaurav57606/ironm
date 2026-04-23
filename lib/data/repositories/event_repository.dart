import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/hmac_service.dart';
import '../../core/utils/event_bus.dart';
import '../models/domain_event.dart';
import 'i_event_repository.dart';

class IsarEventRepository implements IEventRepository {
  final Isar? _isar;
  final EventBus _eventBus;
  final HmacService _hmacService;

  IsarEventRepository(this._isar, this._eventBus, this._hmacService);

  @override
  Future<void> persist(DomainEvent event) async {
    // 1. Sign (Security Enforcement)
    event.hmacSignature = await _hmacService.signEvent(event);

    if (_isar != null) {
      // 2. Persist to Isar
      await _isar!.writeTxn(() async {
        await _isar!.domainEvents.put(event);
      });
    }

    // 3. Dispatch
    _eventBus.publish(event);
  }

  @override
  Future<List<DomainEvent>> getAll() async {
    if (_isar == null) return [];
    final events = await _isar!.domainEvents.where().sortByDeviceTimestamp().findAll();
    return _verifyEvents(events);
  }

  @override
  Future<List<DomainEvent>> getAllUnsynced() async {
    if (_isar == null) return [];
    final events = await _isar!.domainEvents.where().syncedEqualTo(false).sortByDeviceTimestamp().findAll();
    return _verifyEvents(events);
  }

  @override
  Future<DomainEvent?> getById(String id) async {
    if (_isar == null) return null;
    final event = await _isar!.domainEvents.where().idEqualTo(id).findFirst();
    if (event != null && await _hmacService.verifyInstance(event)) {
      return event;
    }
    return null;
  }

  @override
  Future<List<DomainEvent>> getByEntityId(String entityId) async {
    if (_isar == null) return [];
    final events = await _isar!.domainEvents.where().entityIdEqualTo(entityId).sortByDeviceTimestamp().findAll();
    return _verifyEvents(events);
  }

  @override
  Future<void> markAsSynced(String eventId) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      final event = await _isar!.domainEvents.where().idEqualTo(eventId).findFirst();
      if (event != null) {
        event.synced = true;
        await _isar!.domainEvents.put(event);
      }
    });
  }

  @override
  Future<void> persistSynced(DomainEvent event) async {
    if (event.hmacSignature.isEmpty) {
      event.hmacSignature = await _hmacService.signEvent(event);
    }
    if (_isar != null) {
      await _isar!.writeTxn(() async {
        await _isar!.domainEvents.put(event);
      });
    }
    _eventBus.publish(event);
  }

  @override
  Stream<DomainEvent> watch() => _eventBus.stream;

  Future<List<DomainEvent>> _verifyEvents(List<DomainEvent> events) async {
    final verified = <DomainEvent>[];
    for (final e in events) {
      if (await _hmacService.verifyInstance(e)) {
        verified.add(e);
      } else {
        debugPrint('TAMPER DETECTED for event ${e.id}. Skipping.');
      }
    }
    return verified;
  }
}

final eventRepositoryProvider = Provider<IEventRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final bus = ref.watch(eventBusProvider);
  final hmac = ref.watch(hmacServiceProvider);
  return IsarEventRepository(isar, bus, hmac);
});
