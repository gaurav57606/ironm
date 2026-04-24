// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — SalesViewModel | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/providers/database_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/sale.dart';
import '../../../data/repositories/sale_repository.dart';

// ── Sales Notifier ──────────────────────────────────────────────────
class SalesNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> recordSale({
    required List<SaleItem> items,
    required String paymentMethod,
    required double totalAmount,
  }) async {
    final repo = ref.read(saleRepositoryProvider);
    
    // 1. Generate invoice number
    final seq = await repo.getNextInvoiceSequence('SALE');
    seq.lastNumber += 1;
    final invoiceNum = '${seq.prefix}-${seq.lastNumber.toString().padLeft(5, '0')}';
    await repo.updateInvoiceSequence(seq);

    final sale = Sale(
      id: const Uuid().v4(),
      date: DateTime.now(),
      items: items,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      invoiceNumber: invoiceNum,
    );
    await repo.save(sale);
  }
}

// Legacy name for compatibility with POSScreen
final salesProvider = NotifierProvider<SalesNotifier, void>(SalesNotifier.new);

// ── All sales stream ───────────────────────────────────────────────
final salesStreamProvider = StreamProvider.autoDispose<List<Sale>>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) return const Stream.empty();
  return isar.sales.where().watch(fireImmediately: true);
});
