import '../../data/models/domain_event.dart';

abstract class IEventRepository {
  Future<void> persist(DomainEvent event);
  Future<List<DomainEvent>> getAll();
  Future<List<DomainEvent>> getAllUnsynced();
  Future<DomainEvent?> getById(String id);
  Future<List<DomainEvent>> getByEntityId(String entityId);
  Future<void> markAsSynced(String eventId);
  Future<void> persistSynced(DomainEvent event);
  Stream<DomainEvent> watch();
}
