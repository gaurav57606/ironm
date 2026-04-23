// ═══════════════════════════════════════════════════════════════════
// 🔒 LOCKED — PaymentsViewModel | Verified: 2026-04-24 | DO NOT EDIT
// ═══════════════════════════════════════════════════════════════════
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/payment.dart';
import '../../../data/models/plan.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../core/providers/database_provider.dart';

// ── All payments stream ─────────────────────────────────────────────
final paymentsStreamProvider = StreamProvider.autoDispose<List<Payment>>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) return const Stream.empty();
  return isar.payments.where().watch(fireImmediately: true);
});

// ── Payments for a single member ───────────────────────────────────
final memberPaymentsProvider =
    Provider.autoDispose.family<List<Payment>, String>((ref, memberId) {
  final all = ref.watch(paymentsStreamProvider).value ?? [];
  return all.where((p) => p.memberId == memberId).toList();
});


// ── Record Payment Notifier ─────────────────────────────────────────
class RecordPaymentNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Records a payment and updates the member's totalPaid + expiryDate.
  Future<void> recordPayment({
    required String memberId,
    required double amount,
    required String method,
    required String planId,
    required String planName,
    required int durationMonths,
    required double subtotal,
    required double gstAmount,
    required double gstRate,
    String? reference,
    List<PlanComponentSnapshot> components = const [],
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final paymentRepo = ref.read(paymentRepositoryProvider);
      final memberRepo  = ref.read(memberRepositoryProvider);

      // 1. Build invoice number
      final seq = await paymentRepo.getNextInvoiceSequence('INV');
      final invoiceNum = seq.nextInvoiceId;
      seq.nextNumber += 1;
      await paymentRepo.updateInvoiceSequence(seq);

      // 2. Create payment record
      final payment = Payment(
        id: const Uuid().v4(),
        memberId: memberId,
        date: DateTime.now(),
        amount: amount,
        method: method,
        reference: reference,
        planId: planId,
        planName: planName,
        components: components,
        invoiceNumber: invoiceNum,
        subtotal: subtotal,
        gstAmount: gstAmount,
        gstRate: gstRate,
        durationMonths: durationMonths,
      );
      await paymentRepo.save(payment);

      // 3. Update member totalPaid + expiryDate
      final member = await memberRepo.getById(memberId);
      if (member != null) {
        member.totalPaid += (amount * 100).round(); // stored in paise
        final base = (member.expiryDate != null && member.expiryDate!.isAfter(DateTime.now()))
            ? member.expiryDate!
            : DateTime.now();
        member.expiryDate = DateTime(
          base.year, base.month + durationMonths, base.day,
        );
        member.planId   = planId;
        member.planName = planName;
        member.lastUpdated = DateTime.now();
        await memberRepo.save(member);
      }
    });
  }
  /// Records a member renewal payment.
  Future<void> recordMemberPayment({
    required String memberId,
    required Plan plan,
    required String method,
  }) async {
    final subtotal = plan.totalPrice / 1.18;
    final gstAmount = plan.totalPrice - subtotal;
    
    await recordPayment(
      memberId: memberId,
      amount: plan.totalPrice,
      method: method,
      planId: plan.id,
      planName: plan.name,
      durationMonths: plan.durationMonths,
      subtotal: subtotal,
      gstAmount: gstAmount,
      gstRate: 18.0,
      components: plan.components.map((c) => PlanComponentSnapshot(
        name: c.name,
        price: c.price,
      )).toList(),
    );
  }
}


final recordPaymentNotifierProvider =
    AsyncNotifierProvider<RecordPaymentNotifier, void>(RecordPaymentNotifier.new);
