import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/clock.dart';
import '../models/sale.dart';
import '../repositories/sale_repository.dart';
import '../repositories/payment_repository.dart';

class SalesNotifier extends StateNotifier<List<Sale>> {
  final ISaleRepository _repo;
  final IsarPaymentRepository _paymentRepo; // For invoice sequence
  final IClock _clock;

  SalesNotifier(this._repo, this._paymentRepo, this._clock) : super([]) {
    refresh();
  }

  Future<void> refresh() async {
    final sales = await _repo.getAll();
    state = sales;
  }

  Future<void> recordSale({
    required List<SaleItem> items,
    required String paymentMethod,
    required double totalAmount,
  }) async {
    final now = _clock.now;
    
    // Get next invoice number for POS
    final prefix = 'POS-${now.year}-';
    final sequence = await _paymentRepo.getNextInvoiceSequence(prefix);
    final invoiceNumber = sequence.nextInvoiceId;
    sequence.nextNumber++;
    await _paymentRepo.updateInvoiceSequence(sequence);

    final sale = Sale(
      id: const Uuid().v4(),
      date: now,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      items: items,
      invoiceNumber: invoiceNumber,
    );

    await _repo.save(sale);
    await refresh();
  }
}

final salesProvider = StateNotifierProvider<SalesNotifier, List<Sale>>((ref) {
  final repo = ref.watch(saleRepositoryProvider);
  final paymentRepo = ref.watch(paymentRepositoryProvider);
  final clock = ref.watch(clockProvider);
  return SalesNotifier(repo, paymentRepo, clock);
});
