import 'package:isar/isar.dart';

part 'product.g.dart';

@collection
class Product {
  Id? isarId;

  @Index(unique: true)
  late String id;

  late String name;
  late double price;
  
  @Index()
  late String category;
  
  late int iconCodePoint;
  late int stock;
  late int minStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.iconCodePoint = 0xe547,
    this.stock = 0,
    this.minStock = 5,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'category': category,
    'iconCodePoint': iconCodePoint,
    'stock': stock,
    'minStock': minStock,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    category: json['category'] ?? '',
    iconCodePoint: json['iconCodePoint'] ?? 0xe547,
    stock: json['stock'] ?? 0,
    minStock: json['minStock'] ?? 5,
  );
}
