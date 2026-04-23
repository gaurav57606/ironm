import 'package:flutter_test/flutter_test.dart';
import 'package:ironm/core/utils/validators.dart';

void main() {
  group('Validators Test', () {
    test('required returns error for empty string', () {
      expect(AppValidators.required(''), 'This field is required');
      expect(AppValidators.required('John'), null);
    });

    test('phone returns error for invalid phone', () {
      expect(AppValidators.phone(''), 'Phone number is required');
      expect(AppValidators.phone('123'), 'Enter a valid phone number');
      expect(AppValidators.phone('1234567890'), null);
    });
  });
}
