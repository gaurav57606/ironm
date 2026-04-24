import 'package:isar/isar.dart';

part 'invoice_sequence.g.dart';

@collection
class InvoiceSequence {
  Id? isarId;

  @Index(unique: true)
  late String prefix; // e.g. "INV-2026-"

  late int lastNumber;

  InvoiceSequence({
    required this.prefix,
    this.lastNumber = 0,
  });

  Map<String, dynamic> toJson() => {
    'prefix': prefix,
    'lastNumber': lastNumber,
  };

  factory InvoiceSequence.fromJson(Map<String, dynamic> json) => InvoiceSequence(
    prefix: json['prefix'] ?? '',
    lastNumber: json['lastNumber'] ?? 0,
  );
}
