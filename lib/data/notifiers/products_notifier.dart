import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductsNotifier extends StateNotifier<List<Product>> {
  final IProductRepository _repo;

  ProductsNotifier(this._repo) : super([]) {
    refresh();
  }

  Future<void> refresh() async {
    final products = await _repo.getAll();
    state = products;
  }

  Future<void> addProduct(Product product) async {
    await _repo.save(product);
    await refresh();
  }

  Future<void> deleteProduct(String id) async {
    await _repo.delete(id);
    await refresh();
  }
}

final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return ProductsNotifier(repo);
});
