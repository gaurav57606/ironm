import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/hmac_service.dart';
import '../models/sale.dart';
import '../models/invoice_sequence.dart';

abstract class ISaleRepository {
  Future<List<Sale>> getAll();
  Future<void> save(Sale sale);
  Future<List<Sale>> getByDateRange(DateTime start, DateTime end);
  Future<InvoiceSequence> getNextInvoiceSequence(String prefix);
  Future<void> updateInvoiceSequence(InvoiceSequence sequence);
}

class IsarSaleRepository implements ISaleRepository {
  final Isar? _isar;
  final HmacService _hmacService;

  IsarSaleRepository(this._isar, this._hmacService);

  @override
  Future<List<Sale>> getAll() async {
    if (_isar == null) return [];
    final sales = await _isar.sales.where().sortByDateDesc().findAll();
    final verified = <Sale>[];
    for (final s in sales) {
      if (await _hmacService.verifyInstance(s)) {
        verified.add(s);
      }
    }
    return verified;
  }

  @override
  Future<void> save(Sale sale) async {
    if (_isar == null) return;
    sale.hmacSignature = await _hmacService.signSnapshot(sale);
    await _isar.writeTxn(() async {
      await _isar.sales.put(sale);
    });
  }

  @override
  Future<List<Sale>> getByDateRange(DateTime start, DateTime end) async {
    if (_isar == null) return [];
    final sales = await _isar.sales
        .filter()
        .dateBetween(start, end)
        .sortByDateDesc()
        .findAll();
    
    final verified = <Sale>[];
    for (final s in sales) {
      if (await _hmacService.verifyInstance(s)) {
        verified.add(s);
      }
    }
    return verified;
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

final saleRepositoryProvider = Provider<ISaleRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final hmac = ref.watch(hmacServiceProvider);
  return IsarSaleRepository(isar, hmac);
});
