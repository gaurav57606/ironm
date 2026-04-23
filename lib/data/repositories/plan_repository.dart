import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../models/plan.dart';

class PlanRepository {
  Future<List<Plan>> getAllPlans() async {
    return isar.plans.where().findAll();
  }

  Future<int> addPlan(Plan plan) async {
    return isar.writeTxn(() => isar.plans.put(plan));
  }

  Future<void> deletePlan(int id) async {
    await isar.writeTxn(() => isar.plans.delete(id));
  }
}

final planRepositoryProvider = Provider<PlanRepository>((ref) {
  return PlanRepository();
});
