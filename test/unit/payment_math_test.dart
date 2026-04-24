import 'package:flutter_test/flutter_test.dart';

// Helper function that mirrors the logic in RecordPaymentNotifier.recordPayment
DateTime calculateExpiryDate(DateTime base, int durationMonths) {
  final targetMonth = base.month + durationMonths;
  final yearOffset = (targetMonth - 1) ~/ 12;
  final month = (targetMonth - 1) % 12 + 1;
  final year = base.year + yearOffset;

  final lastDayOfTargetMonth = DateTime(year, month + 1, 0).day;
  final day = base.day > lastDayOfTargetMonth ? lastDayOfTargetMonth : base.day;
  return DateTime(year, month, day);
}

void main() {
  group('Payment Math Tests', () {
    test('GST-inclusive calculation: 1180 at 18%', () {
      const amount = 1180.0;
      const gstRate = 18.0;
      final subtotal = amount / (1 + (gstRate / 100));
      final gstAmount = amount - subtotal;

      expect(subtotal, 1000.0);
      expect(gstAmount, 180.0);
      expect((subtotal + gstAmount).toStringAsFixed(2), amount.toStringAsFixed(2));
    });

    test('Expiry Date: 3 months from 2026-01-31 → 2026-04-30', () {
      final base = DateTime(2026, 1, 31);
      final expiry = calculateExpiryDate(base, 3);
      expect(expiry, DateTime(2026, 4, 30));
    });

    test('Expiry Date: 1 month from 2026-01-31 → 2026-02-28', () {
      final base = DateTime(2026, 1, 31);
      final expiry = calculateExpiryDate(base, 1);
      expect(expiry, DateTime(2026, 2, 28));
    });

    test('Expiry Date: 12 months from 2026-01-31 → 2027-01-31', () {
      final base = DateTime(2026, 1, 31);
      final expiry = calculateExpiryDate(base, 12);
      expect(expiry, DateTime(2027, 1, 31));
    });
  });
}
