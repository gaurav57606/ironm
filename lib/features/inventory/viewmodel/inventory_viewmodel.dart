// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — InventoryViewModel | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/product_repository.dart';

// ── Products stream ─────────────────────────────────────────────────
final productsStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) async* {
  final repo = ref.watch(productRepositoryProvider);
  // IsarProductRepository.getAll() returns Future<List<Product>>
  // We can convert it to a stream or just use a FutureProvider
  yield await repo.getAll();
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
