import 'package:isar/isar.dart';

part 'sale.g.dart';

@collection
class Sale {
  Id? isarId;

  @Index(unique: true)
  late String id;

  @Index()
  late DateTime date;

  late double totalAmount;
  late String paymentMethod;
  
  late List<SaleItem> items;
  
  @Index()
  late String invoiceNumber;

  late String hmacSignature;

  Sale({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.paymentMethod,
    this.items = const [],
    required this.invoiceNumber,
    this.hmacSignature = '',
  });
}

@embedded
class SaleItem {
  late String productId;
  late String productName;
  late double price;
  late int quantity;

  SaleItem({
    this.productId = '',
    this.productName = '',
    this.price = 0.0,
    this.quantity = 1,
  });
}
