import 'package:flutter_test/flutter_test.dart';
import 'package:ironm/core/utils/date_utils.dart';

void main() {
  group('DateUtils Test', () {
    test('formatDate returns correctly formatted string', () {
      final date = DateTime(2024, 1, 1);
      expect(AppDateUtils.formatDate(date), 'Jan 01, 2024');
    });

    test('formatDateTime returns correctly formatted string', () {
      final date = DateTime(2024, 1, 1, 14, 30);
      expect(AppDateUtils.formatDateTime(date), 'Jan 01, 2024 02:30 PM');
    });

    test('isExpired returns true for past dates', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      final futureDate = DateTime.now().add(const Duration(days: 1));
      
      expect(AppDateUtils.isExpired(pastDate), true);
      expect(AppDateUtils.isExpired(futureDate), false);
    });
  });
}
