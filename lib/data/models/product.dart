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

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.iconCodePoint,
  });
}
