import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/hmac_service.dart';
import '../models/member.dart';
import '../models/domain_event.dart';
import '../services/snapshot_builder.dart';
import 'event_repository.dart';
import 'i_event_repository.dart';

abstract class IMemberRepository {
  Future<List<Member>> getAll();
  Future<Member?> getById(String memberId);
  Future<void> save(Member member);
  Future<void> delete(String memberId);
  Future<void> reconcile(String memberId);
}

class IsarMemberRepository implements IMemberRepository {
  final Isar? _isar;
  final IEventRepository _eventRepo;
  final HmacService _hmacService;

  IsarMemberRepository(this._isar, this._eventRepo, this._hmacService);

  @override
  Future<List<Member>> getAll() async {
    if (_isar == null) return [];
    final members = await _isar!.members.where().findAll();
    final verified = <Member>[];
    for (final m in members) {
      if (await _hmacService.verifyInstance(m)) {
        verified.add(m);
      }
    }
    return verified;
  }

  @override
  Future<Member?> getById(String memberId) async {
    if (_isar == null) return null;
    final member = await _isar!.members.where().memberIdEqualTo(memberId).findFirst();
    if (member != null && await _hmacService.verifyInstance(member)) {
      return member;
    }
    return null;
  }

  @override
  Future<void> save(Member member) async {
    if (_isar == null) return;
    member.hmacSignature = await _hmacService.signSnapshot(member);
    await _isar!.writeTxn(() async {
      await _isar!.members.put(member);
    });
  }

  @override
  Future<void> delete(String memberId) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.members.where().memberIdEqualTo(memberId).deleteAll();
    });
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
  final eventRepo = ref.watch(eventRepositoryProvider);
  final hmac = ref.watch(hmacServiceProvider);
  return IsarMemberRepository(isar, eventRepo, hmac);
});
