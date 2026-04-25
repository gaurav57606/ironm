import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/hmac_service.dart';
import '../models/member.dart';
import '../../core/services/snapshot_builder.dart';
import 'event_repository.dart';
import 'i_event_repository.dart';
import 'dart:async' show unawaited;
import '../../core/sync/sync_queue.dart';
import '../../core/sync/sync_providers.dart';
import '../../data/models/sync_job.dart';
// import 'web/web_member_repository.dart';
// import '../../core/providers/web_data_store.dart';

abstract class IMemberRepository {
  Future<List<Member>> getAll();
  Stream<List<Member>> watchAll();
  Future<Member?> getById(String memberId);
  Future<void> save(Member member);
  Future<void> delete(String memberId);
  Future<void> reconcile(String memberId);
}

class IsarMemberRepository implements IMemberRepository {
  final Isar? _isar;
  final IEventRepository _eventRepo;
  final HmacService _hmacService;
  final SyncQueue? _syncQueue;

  IsarMemberRepository(this._isar, this._eventRepo, this._hmacService,
      [this._syncQueue]);

  @override
  Future<List<Member>> getAll() async {
    if (_isar == null) return [];
    final members = await _isar.members.where().findAll();
    final verified = <Member>[];
    for (final m in members) {
      if (await _hmacService.verifyInstance(m)) {
        verified.add(m);
      }
    }
    return verified;
  }

  @override
  Stream<List<Member>> watchAll() {
    if (_isar == null) return const Stream.empty();
    return _isar!.members.where().watch(fireImmediately: true);
  }

  @override
  Future<Member?> getById(String memberId) async {
    if (_isar == null) return null;
    final member = await _isar.members.filter().memberIdEqualTo(memberId).findFirst();
    if (member != null && await _hmacService.verifyInstance(member)) {
      return member;
    }
    return null;
  }

  @override
  Future<void> save(Member member) async {
    if (_isar == null) return;
    member.hmacSignature = await _hmacService.signSnapshot(member);
    await _isar.writeTxn(() async {
      await _isar.members.put(member);
    });
    // Fire-and-forget cloud mirror — never blocks UI
    unawaited(_syncQueue?.enqueueUpsert(
      collection: SyncCollection.members,
      docId: member.memberId,
      payload: member.toJson(),
    ));
  }

  @override
  Future<void> delete(String memberId) async {
    if (_isar == null) return;
    await _isar.writeTxn(() async {
      await _isar.members.filter().memberIdEqualTo(memberId).deleteAll();
    });
    unawaited(_syncQueue?.enqueueDelete(
      collection: SyncCollection.members,
      docId: memberId,
    ));
  }

  @override
  Future<void> reconcile(String memberId) async {
    if (_isar == null) return;
    final events = await _eventRepo.getByEntityId(memberId);
    final currentMember = await getById(memberId);
    
    final rebuilt = SnapshotBuilder.rebuild(events);
    if (rebuilt != null) {
      // Preserve isarId if existing
      if (currentMember != null) {
        rebuilt.isarId = currentMember.isarId;
      }
      await save(rebuilt);
    }
  }
}

final memberRepositoryProvider = Provider<IMemberRepository>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) {
    final webStore = ref.watch(webDataStoreProvider);
    if (webStore != null) {
      // return WebMemberRepository(webStore);
    }
  }
  
  final eventRepo  = ref.watch(eventRepositoryProvider);
  final hmac       = ref.watch(hmacServiceProvider);
  final syncQueue  = ref.watch(syncQueueProvider);
  return IsarMemberRepository(isar, eventRepo, hmac, syncQueue);
});
