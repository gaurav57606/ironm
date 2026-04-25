import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/hmac_service.dart';
import '../models/payment.dart';
import '../models/invoice_sequence.dart';
import 'dart:async' show unawaited;
import '../../core/sync/sync_queue.dart';
import '../../core/sync/sync_providers.dart';
import '../../data/models/sync_job.dart';
// import 'web/web_payment_repository.dart';
// import '../../core/providers/web_data_store.dart';

abstract class IPaymentRepository {
  Future<List<Payment>> getAll();
  Stream<List<Payment>> watchAll();
  Future<void> save(Payment payment);
  Future<InvoiceSequence> getNextInvoiceSequence(String prefix);
  Future<void> updateInvoiceSequence(InvoiceSequence sequence);
}

class IsarPaymentRepository implements IPaymentRepository {
  final Isar? _isar;
  final HmacService _hmacService;
  final SyncQueue? _syncQueue;

  IsarPaymentRepository(this._isar, this._hmacService, [this._syncQueue]);

  @override
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

  @override
  Stream<List<Payment>> watchAll() {
    if (_isar == null) return const Stream.empty();
    return _isar.payments.where().sortByDateDesc().watch(fireImmediately: true);
  }

  @override
  Future<void> save(Payment payment) async {
    if (_isar == null) return;
    payment.hmacSignature = await _hmacService.signSnapshot(payment);
    await _isar.writeTxn(() async {
      await _isar.payments.put(payment);
    });
    unawaited(_syncQueue?.enqueueUpsert(
      collection: SyncCollection.payments,
      docId: payment.id,
      payload: payment.toJson(),
    ));
  }

  @override
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

  @override
  Future<void> updateInvoiceSequence(InvoiceSequence sequence) async {
    if (_isar == null) return;
    await _isar.writeTxn(() async {
      await _isar.invoiceSequences.put(sequence);
    });
  }
}

final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) {
    final webStore = ref.watch(webDataStoreProvider);
    if (webStore != null) {
      // return WebPaymentRepository(webStore);
    }
  }
  final hmac      = ref.watch(hmacServiceProvider);
  final syncQueue = ref.watch(syncQueueProvider);
  return IsarPaymentRepository(isar, hmac, syncQueue);
});
