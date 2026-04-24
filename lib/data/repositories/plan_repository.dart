// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — PlanRepository | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/hmac_service.dart';
import '../models/plan.dart';

abstract class IPlanRepository {
  Future<List<Plan>> getAll();
  Future<Plan?> getById(String id);
  Future<void> save(Plan plan);
  Future<void> delete(String id);
  Stream<List<Plan>> watchAll();
}

class IsarPlanRepository implements IPlanRepository {
  final Isar? _isar;
  final HmacService _hmacService;

  IsarPlanRepository(this._isar, this._hmacService);

  @override
  Future<List<Plan>> getAll() async {
    if (_isar == null) return [];
    return _isar.plans.where().findAll();
  }

  @override
  Future<Plan?> getById(String id) async {
    if (_isar == null) return null;
    return _isar.plans.filter().idEqualTo(id).findFirst();
  }

  @override
  Future<void> save(Plan plan) async {
    if (_isar == null) return;
    plan.hmacSignature = await _hmacService.signSnapshot(plan);
    await _isar.writeTxn(() async {
      await _isar.plans.put(plan);
    });
  }

  @override
  Future<void> delete(String id) async {
    if (_isar == null) return;
    await _isar.writeTxn(() async {
      await _isar.plans.filter().idEqualTo(id).deleteAll();
    });
  }

  @override
  Stream<List<Plan>> watchAll() {
    if (_isar == null) return const Stream.empty();
    return _isar.plans.where().watch(fireImmediately: true);
  }
}

final planRepositoryProvider = Provider<IPlanRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final hmac = ref.watch(hmacServiceProvider);
  return IsarPlanRepository(isar, hmac);
});
