import 'package:isar/isar.dart';

part 'payment.g.dart';

@collection
class Payment {
  Id? isarId;

  @Index(unique: true)
  late String id;

  @Index()
  late String memberId;

  @Index()
  late DateTime date;

  late double amount;
  late String method; // Cash, UPI, Card, etc.
  String? reference;

  late String planId;
  late String planName;
  
  late List<PlanComponentSnapshot> components;

  @Index()
  late String invoiceNumber;

  late double subtotal;
  late double gstAmount;
  late double gstRate;
  late int durationMonths;

  late String hmacSignature;

  Payment({
    required this.id,
    required this.memberId,
    required this.date,
    required this.amount,
    required this.method,
    this.reference,
    required this.planId,
    required this.planName,
    this.components = const [],
    required this.invoiceNumber,
    required this.subtotal,
    required this.gstAmount,
    required this.gstRate,
    required this.durationMonths,
    this.hmacSignature = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'memberId': memberId,
    'date': date.toIso8601String(),
    'amount': amount,
    'method': method,
    'reference': reference,
    'planId': planId,
    'planName': planName,
    'components': components.map((e) => e.toJson()).toList(),
    'invoiceNumber': invoiceNumber,
    'subtotal': subtotal,
    'gstAmount': gstAmount,
    'gstRate': gstRate,
    'durationMonths': durationMonths,
    'hmacSignature': hmacSignature,
  };

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'] ?? '',
    memberId: json['memberId'] ?? '',
    date: DateTime.parse(json['date']),
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    method: json['method'] ?? '',
    reference: json['reference'],
    planId: json['planId'] ?? '',
    planName: json['planName'] ?? '',
    components: (json['components'] as List?)?.map((e) => PlanComponentSnapshot.fromJson(e)).toList() ?? [],
    invoiceNumber: json['invoiceNumber'] ?? '',
    subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    gstAmount: (json['gstAmount'] as num?)?.toDouble() ?? 0.0,
    gstRate: (json['gstRate'] as num?)?.toDouble() ?? 0.0,
    durationMonths: json['durationMonths'] ?? 0,
    hmacSignature: json['hmacSignature'] ?? '',
  );
}

@embedded
class PlanComponentSnapshot {
  late String name;
  late double price;

  PlanComponentSnapshot({
    this.name = '',
    this.price = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
  };

  factory PlanComponentSnapshot.fromJson(Map<String, dynamic> json) => PlanComponentSnapshot(
    name: json['name'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
  );
}
