// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — PlansViewModel | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/plan.dart';
import '../../../data/repositories/plan_repository.dart';

// ── All plans stream ────────────────────────────────────────────────
final plansStreamProvider = StreamProvider.autoDispose<List<Plan>>((ref) {
  final repo = ref.watch(planRepositoryProvider);
  return repo.watchAll();
});

// Alias for compatibility with older UI
final plansProvider = Provider.autoDispose<List<Plan>>((ref) {
  return ref.watch(plansStreamProvider).value ?? [];
});


// ── Plans write notifier ────────────────────────────────────────────
class PlansNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addPlan({
    required String name,
    required int durationMonths,
    required List<PlanComponent> components,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final plan = Plan(
        id: const Uuid().v4(),
        name: name,
        durationMonths: durationMonths,
        components: components,
        active: true,
      );
      await ref.read(planRepositoryProvider).save(plan);
    });
  }

  Future<void> updatePlan(Plan plan) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(planRepositoryProvider).save(plan);
    });
  }

  Future<void> deactivatePlan(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(planRepositoryProvider);
      final plan = await repo.getById(id);
      if (plan == null) return;
      plan.active = false;
      await repo.save(plan);
    });
  }

  Future<void> deletePlan(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(planRepositoryProvider).delete(id);
    });
  }
}

final plansNotifierProvider =
    AsyncNotifierProvider<PlansNotifier, void>(PlansNotifier.new);
