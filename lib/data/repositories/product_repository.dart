import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../models/product.dart';

abstract class IProductRepository {
  Future<List<Product>> getAll();
  Future<Product?> getById(String id);
  Future<void> save(Product product);
  Future<void> delete(String id);
}

class IsarProductRepository implements IProductRepository {
  final Isar? _isar;

  IsarProductRepository(this._isar);

  @override
  Future<List<Product>> getAll() async {
    if (_isar == null) {
      // Return default products if no database (demo mode)
      return _getDefaultProducts();
    }
    final products = await _isar.products.where().findAll();
    if (products.isEmpty) {
      // Seed defaults
      for (final p in _getDefaultProducts()) {
        await save(p);
      }
      return _isar.products.where().findAll();
    }
    return products;
  }

  @override
  Future<Product?> getById(String id) async {
    if (_isar == null) return null;
    return await _isar.products.where().idEqualTo(id).findFirst();
  }

  @override
  Future<void> save(Product product) async {
    if (_isar == null) return;
    await _isar.writeTxn(() async {
      await _isar.products.put(product);
    });
  }

  @override
  Future<void> delete(String id) async {
    if (_isar == null) return;
    await _isar.writeTxn(() async {
      await _isar.products.where().idEqualTo(id).deleteAll();
    });
  }

  List<Product> _getDefaultProducts() {
    return [
      Product(id: '1', name: 'Whey Protein (1kg)', price: 2499, category: 'Supplements', iconCodePoint: 0xe293),
      Product(id: '2', name: 'Creatine (250g)', price: 899, category: 'Supplements', iconCodePoint: 0xe463),
      Product(id: '3', name: 'BCAA (30 servings)', price: 1599, category: 'Supplements', iconCodePoint: 0xe107),
      Product(id: '4', name: 'Gym T-Shirt', price: 799, category: 'Merch', iconCodePoint: 0xe153),
      Product(id: '5', name: 'Shaker Bottle', price: 399, category: 'Merch', iconCodePoint: 0xe395),
      Product(id: '6', name: 'Wrist Wraps', price: 599, category: 'Merch', iconCodePoint: 0xe5ea),
    ];
  }
}

final productRepositoryProvider = Provider<IProductRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return IsarProductRepository(isar);
});
