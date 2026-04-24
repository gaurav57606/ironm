import 'package:rxdart/rxdart.dart';
import '../../../core/providers/web_data_store.dart';
import '../../models/product.dart';
import '../product_repository.dart';

class WebProductRepository implements IProductRepository {
  final WebDataStore _store;
  static const String _collection = 'products';
  final _subject = BehaviorSubject<List<Product>>();

  WebProductRepository(this._store) {
    _init();
  }

  Future<void> _init() async {
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<List<Product>> getAll() async {
    final data = await _store.getAll(_collection);
    if (data.isEmpty) {
      final defaults = _getDefaultProducts();
      for (final p in defaults) {
        await save(p);
      }
      return defaults;
    }
    return data.map((e) => Product.fromJson(e)).toList();
  }

  @override
  Stream<List<Product>> watchAll() => _subject.stream;

  @override
  Future<Product?> getById(String id) async {
    final data = await _store.get(_collection, id);
    if (data == null) return null;
    return Product.fromJson(data);
  }

  @override
  Future<void> save(Product product) async {
    await _store.save(_collection, product.id, product.toJson());
    final list = await getAll();
    _subject.add(list);
  }

  @override
  Future<void> delete(String id) async {
    await _store.delete(_collection, id);
    final list = await getAll();
    _subject.add(list);
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
