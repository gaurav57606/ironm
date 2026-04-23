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
}

@embedded
class PlanComponentSnapshot {
  late String name;
  late double price;

  PlanComponentSnapshot({
    this.name = '',
    this.price = 0.0,
  });
}
