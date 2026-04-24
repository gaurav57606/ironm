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
}
