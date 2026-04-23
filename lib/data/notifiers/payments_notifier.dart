import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';
import '../../core/constants/event_payload_keys.dart';
import '../../core/utils/clock.dart';
import '../../core/utils/date_utils.dart';
import '../models/payment.dart';
import '../models/domain_event.dart';
import '../models/plan.dart';
import '../repositories/payment_repository.dart';
import '../repositories/event_repository.dart';
import '../repositories/i_event_repository.dart';
import '../../core/services/hmac_service.dart';
import 'members_notifier.dart';

class PaymentsNotifier extends StateNotifier<List<Payment>> {
  final IsarPaymentRepository _repo;
  final IEventRepository _eventRepo;
  final IClock _clock;
  final HmacService _hmac;
  final Ref _ref;
  String _deviceId = 'device-unknown';

  PaymentsNotifier(this._repo, this._eventRepo, this._clock, this._hmac, this._ref) : super([]) {
    _init();
  }

  Future<void> _init() async {
    _deviceId = await _hmac.getInstallationId();
    await refresh();
  }

  Future<void> refresh() async {
    final payments = await _repo.getAll();
    state = payments;
  }

  Future<Payment> recordMemberPayment({
    required String memberId,
    required Plan plan,
    required String method,
    String? reference,
  }) async {
    final now = _clock.now;
    
    // 1. Get/Update Invoice Sequence
    final prefix = 'INV-${now.year}-';
    final sequence = await _repo.getNextInvoiceSequence(prefix);
    final invoiceNumber = sequence.nextInvoiceId;
    sequence.nextNumber++;
    await _repo.updateInvoiceSequence(sequence);

    // 2. Calculate Financials
    final total = plan.totalPrice;
    final subtotal = total / 1.18;
    const gstRate = 0.18;
    final gstAmount = total - subtotal;

    // 3. Create Payment Object
    final payment = Payment(
      id: const Uuid().v4(),
      memberId: memberId,
      date: now,
      amount: total,
      method: method,
      reference: reference,
      planId: plan.id,
      planName: plan.name,
      durationMonths: plan.durationMonths,
      invoiceNumber: invoiceNumber,
      subtotal: subtotal,
      gstAmount: gstAmount,
      gstRate: gstRate,
      components: plan.components.map((c) => PlanComponentSnapshot(
        name: c.name,
        price: c.price,
      )).toList(),
    );

    // 4. Calculate New Expiry for Member (via Event)
    final members = _ref.read(membersProvider);
    final member = members.firstWhereOrNull((m) => m.memberId == memberId);
    DateTime baseDate = member?.expiryDate ?? now;
    if (baseDate.isBefore(now)) baseDate = now;
    final newExpiryDate = AppDateUtils.addMonths(baseDate, plan.durationMonths);

    // 5. Persist Domain Event
    final payload = {
      EventPayloadKeys.memberId: memberId,
      EventPayloadKeys.paymentId: payment.id,
      EventPayloadKeys.amount: total,
      EventPayloadKeys.paymentMethod: method,
      EventPayloadKeys.invoiceNumber: invoiceNumber,
      EventPayloadKeys.planId: plan.id,
      EventPayloadKeys.planName: plan.name,
      EventPayloadKeys.durationMonths: plan.durationMonths,
      EventPayloadKeys.newExpiry: newExpiryDate.toUtc().toIso8601String(),
      EventPayloadKeys.updatedAt: now.toUtc().toIso8601String(),
    };

    final event = DomainEvent(
      entityId: memberId,
      eventType: EventType.paymentRecorded,
      deviceId: _deviceId,
      deviceTimestamp: now,
      payloadJson: jsonEncode(payload),
    );

    await _eventRepo.persist(event);

    // 6. Persist Payment Snapshot
    await _repo.save(payment);
    await refresh();

    return payment;
  }
}

final paymentsProvider = StateNotifierProvider<PaymentsNotifier, List<Payment>>((ref) {
  final repo = ref.watch(paymentRepositoryProvider);
  final eventRepo = ref.watch(eventRepositoryProvider);
  final clock = ref.watch(clockProvider);
  final hmac = ref.watch(hmacServiceProvider);
  return PaymentsNotifier(repo, eventRepo, clock, hmac, ref);
});

final memberPaymentsProvider = Provider.family<List<Payment>, String>((ref, memberId) {
  final payments = ref.watch(paymentsProvider);
  return payments.where((p) => p.memberId == memberId).toList();
});

final latestPaymentForMemberProvider = Provider.family<Payment?, String>((ref, memberId) {
  final payments = ref.watch(paymentsProvider);
  return payments.firstWhereOrNull((p) => p.memberId == memberId);
});

