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

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'totalAmount': totalAmount,
    'paymentMethod': paymentMethod,
    'items': items.map((e) => e.toJson()).toList(),
    'invoiceNumber': invoiceNumber,
    'hmacSignature': hmacSignature,
  };

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
    id: json['id'] ?? '',
    date: DateTime.parse(json['date']),
    totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    paymentMethod: json['paymentMethod'] ?? '',
    items: (json['items'] as List?)?.map((e) => SaleItem.fromJson(e)).toList() ?? [],
    invoiceNumber: json['invoiceNumber'] ?? '',
    hmacSignature: json['hmacSignature'] ?? '',
  );
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

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'price': price,
    'quantity': quantity,
  };

  factory SaleItem.fromJson(Map<String, dynamic> json) => SaleItem(
    productId: json['productId'] ?? '',
    productName: json['productName'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    quantity: json['quantity'] ?? 1,
  );
}
