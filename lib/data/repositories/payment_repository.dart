import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/hmac_service.dart';
import '../models/payment.dart';
import '../models/invoice_sequence.dart';

class IsarPaymentRepository {
  final Isar? _isar;
  final HmacService _hmacService;

  IsarPaymentRepository(this._isar, this._hmacService);

  Future<List<Payment>> getAll() async {
    if (_isar == null) return [];
    final payments = await _isar.payments.where().sortByDateDesc().findAll();
    final verified = <Payment>[];
    for (final p in payments) {
      if (await _hmacService.verifyInstance(p)) {
        verified.add(p);
      }
    }
    return verified;
  }

  Future<void> save(Payment payment) async {
    if (_isar == null) return;
    payment.hmacSignature = await _hmacService.signSnapshot(payment);
    await _isar.writeTxn(() async {
      await _isar.payments.put(payment);
    });
  }

  Future<InvoiceSequence> getNextInvoiceSequence(String prefix) async {
    if (_isar == null) return InvoiceSequence(prefix: prefix);
    var sequence = await _isar.invoiceSequences.where().prefixEqualTo(prefix).findFirst();
    if (sequence == null) {
      sequence = InvoiceSequence(prefix: prefix);
      await _isar.writeTxn(() async {
        await _isar.invoiceSequences.put(sequence!);
      });
    }
    return sequence;
  }

  Future<void> updateInvoiceSequence(InvoiceSequence sequence) async {
    if (_isar == null) return;
    await _isar.writeTxn(() async {
      await _isar.invoiceSequences.put(sequence);
    });
  }
}

final paymentRepositoryProvider = Provider<IsarPaymentRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final hmac = ref.watch(hmacServiceProvider);
  return IsarPaymentRepository(isar, hmac);
});
