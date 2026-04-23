import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../models/plan.dart';

class PlansNotifier extends StateNotifier<List<Plan>> {
  final Isar? _isar;

  PlansNotifier(this._isar) : super([]) {
    _init();
  }

  Future<void> _init() async {
    final defaultPlans = [
      Plan(id: 'p1', name: 'Monthly Basic', durationMonths: 1, components: [PlanComponent(id: 'c1', name: 'Base Fee', price: 1000)]),
      Plan(id: 'p2', name: 'Quarterly Pro', durationMonths: 3, components: [PlanComponent(id: 'c2', name: 'Base Fee', price: 2500)]),
      Plan(id: 'p3', name: 'Yearly Elite', durationMonths: 12, components: [PlanComponent(id: 'c3', name: 'Base Fee', price: 8000)]),
    ];

    if (_isar == null) {
      state = defaultPlans;
      return;
    }

    final plans = await _isar!.plans.where().findAll();
    if (plans.isEmpty) {
      // Seed default plans if empty
      await _isar!.writeTxn(() async {
        await _isar!.plans.putAll(defaultPlans);
      });
      state = defaultPlans;
    } else {
      state = plans;
    }
  }

  Future<void> addPlan(Plan plan) async {
    if (_isar != null) {
      await _isar!.writeTxn(() async {
        await _isar!.plans.put(plan);
      });
    }
    state = [...state, plan];
  }

  Future<void> deletePlan(int id) async {
    if (_isar != null) {
      await _isar!.writeTxn(() async {
        await _isar!.plans.delete(id);
      });
    }
    state = state.where((p) => p.isarId != id).toList();
  }
}

final plansProvider = StateNotifierProvider<PlansNotifier, List<Plan>>((ref) {
  final isar = ref.watch(isarProvider);
  return PlansNotifier(isar);
});
