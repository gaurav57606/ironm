import 'package:isar/isar.dart';

part 'invoice_sequence.g.dart';

@collection
class InvoiceSequence {
  Id? isarId;

  @Index(unique: true)
  late String prefix; // e.g. "INV-2026-"

  late int nextNumber;

  InvoiceSequence({
    required this.prefix,
    this.nextNumber = 1,
  });

  @ignore
  String get nextInvoiceId {
    return '$prefix${nextNumber.toString().padLeft(4, '0')}';
  }
}
