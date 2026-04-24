import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:ironm/data/models/payment.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/invoice_sequence.dart';
import 'package:ironm/data/repositories/payment_repository.dart';
import 'package:ironm/data/repositories/member_repository.dart';
import 'package:ironm/features/payments/viewmodel/payments_viewmodel.dart';

class FakePaymentRepository implements IsarPaymentRepository {
  final List<Payment> _payments = [];
  final Map<String, InvoiceSequence> _sequences = {};

  @override
  Isar? get _isar => null;
  @override
  dynamic get _hmacService => null;

  @override
  Future<List<Payment>> getAll() async => _payments;

  @override
  Stream<List<Payment>> watchAll() => Stream.value(_payments);

  @override
  Future<void> save(Payment payment) async {
    _payments.add(payment);
  }

  @override
  Future<InvoiceSequence> getNextInvoiceSequence(String prefix) async {
    return _sequences[prefix] ?? InvoiceSequence(prefix: prefix);
  }

  @override
  Future<void> updateInvoiceSequence(InvoiceSequence sequence) async {
    _sequences[sequence.prefix] = sequence;
  }
}

class FakeMemberRepository implements IMemberRepository {
  final Map<String, Member> _members = {};
  @override
  Future<List<Member>> getAll() async => _members.values.toList();
  @override
  Stream<List<Member>> watchAll() => Stream.value(_members.values.toList());
  @override
  Future<Member?> getById(String memberId) async => _members[memberId];
  @override
  Future<void> save(Member member) async => _members[member.memberId] = member;
  @override
  Future<void> delete(String memberId) async => _members.remove(memberId);
  @override
  Future<void> reconcile(String memberId) async {}
}

void main() {
  late ProviderContainer container;
  late FakePaymentRepository fakePaymentRepo;
  late FakeMemberRepository fakeMemberRepo;

  setUp(() {
    fakePaymentRepo = FakePaymentRepository();
    fakeMemberRepo = FakeMemberRepository();
    container = ProviderContainer(
      overrides: [
        paymentRepositoryProvider.overrideWithValue(fakePaymentRepo),
        memberRepositoryProvider.overrideWithValue(fakeMemberRepo),
        paymentsStreamProvider.overrideWith((ref) => Stream.value(fakePaymentRepo._payments)),
      ],
    );
  });

  group('Payments Provider Tests', () {
    test('memberPaymentsProvider(id) returns only payments for that memberId sorted DESC', () async {
      final p1 = Payment(id: '1', memberId: 'm1', date: DateTime(2026, 1, 1), amount: 100, method: 'C', planId: 'p', planName: 'P', invoiceNumber: '001', subtotal: 80, gstAmount: 20, gstRate: 18, durationMonths: 1);
      final p2 = Payment(id: '2', memberId: 'm1', date: DateTime(2026, 1, 2), amount: 100, method: 'C', planId: 'p', planName: 'P', invoiceNumber: '002', subtotal: 80, gstAmount: 20, gstRate: 18, durationMonths: 1);
      final p3 = Payment(id: '3', memberId: 'm2', date: DateTime(2026, 1, 3), amount: 100, method: 'C', planId: 'p', planName: 'P', invoiceNumber: '003', subtotal: 80, gstAmount: 20, gstRate: 18, durationMonths: 1);
      
      fakePaymentRepo._payments.addAll([p1, p2, p3]);
      
      await container.read(paymentsStreamProvider.future);
      final m1Payments = container.read(memberPaymentsProvider('m1'));
      expect(m1Payments.length, 2);
      expect(m1Payments.first.id, '2'); // sorted DESC
    });

    test('recordPayment increments invoice number', () async {
      fakeMemberRepo._members['m1'] = Member(memberId: 'm1', name: 'M1', joinDate: DateTime.now(), lastUpdated: DateTime.now());
      fakePaymentRepo._sequences['INV'] = InvoiceSequence(prefix: 'INV', lastNumber: 5);

      await container.read(recordPaymentNotifierProvider.notifier).recordPayment(
        memberId: 'm1',
        amount: 1000,
        method: 'Cash',
        planId: 'p1',
        planName: 'Gold',
        durationMonths: 1,
        subtotal: 847,
        gstAmount: 153,
        gstRate: 18,
      );

      expect(fakePaymentRepo._payments.first.invoiceNumber, 'INV-00006');
    });

    test('recordPayment updates member expiryDate correctly (Jan 31 + 1 month → Feb 28)', () async {
      final baseDate = DateTime(2027, 1, 31);
      fakeMemberRepo._members['m1'] = Member(
        memberId: 'm1', 
        name: 'M1', 
        joinDate: DateTime.now(), 
        expiryDate: baseDate, // Future date, will be used as base
        lastUpdated: DateTime.now()
      );
      
      await container.read(recordPaymentNotifierProvider.notifier).recordPayment(
        memberId: 'm1',
        amount: 1000,
        method: 'Cash',
        planId: 'p1',
        planName: 'Gold',
        durationMonths: 1,
        subtotal: 847,
        gstAmount: 153,
        gstRate: 18,
      );

      final member = fakeMemberRepo._members['m1']!;
      expect(member.expiryDate?.year, 2027);
      expect(member.expiryDate?.month, 2);
      expect(member.expiryDate?.day, 28);
    });
  });
}
