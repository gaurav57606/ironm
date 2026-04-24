// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — InventoryViewModel | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/product_repository.dart';

import '../../../core/providers/database_provider.dart';
import 'package:isar/isar.dart';

// ── Products stream ─────────────────────────────────────────────────
final productsStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) return const Stream.empty();
  return isar.products.where().watch(fireImmediately: true);
});

// Alias for compatibility with older UI
final productsProvider = Provider.autoDispose<List<Product>>((ref) {
  return ref.watch(productsStreamProvider).value ?? [];
});

// ── Inventory write notifier ─────────────────────────────────────────
class InventoryNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addProduct(Product product) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(productRepositoryProvider).save(product);
    });
  }

  Future<void> deleteProduct(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(productRepositoryProvider).delete(id);
    });
  }
}

final inventoryNotifierProvider =
    AsyncNotifierProvider<InventoryNotifier, void>(InventoryNotifier.new);
