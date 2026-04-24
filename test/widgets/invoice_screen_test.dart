import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/payment.dart';
import 'package:ironm/data/models/owner_profile.dart';
import 'package:ironm/features/billing/presentation/invoice_screen.dart';
import 'package:ironm/features/members/viewmodel/members_viewmodel.dart';
import 'package:ironm/features/payments/viewmodel/payments_viewmodel.dart';
import 'package:ironm/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:ironm/data/models/app_settings.dart';

class FakeAuthViewModel extends AuthViewModel {
  final AuthState _state;
  FakeAuthViewModel(this._state);
  @override
  AuthState build() => _state;
}

void main() {
  group('InvoiceScreen Widget Tests', () {
    final now = DateTime(2026, 4, 24);
    final member = Member(
      memberId: 'm1',
      name: 'John Doe',
      joinDate: now,
      expiryDate: now.add(const Duration(days: 30)),
      lastUpdated: now,
    );
    final owner = OwnerProfile(
      gymName: 'Titan Gym',
      ownerName: 'Admin',
      phone: '000',
      gstin: 'GST123',
    );
    final payment = Payment(
      id: 'p1',
      memberId: 'm1',
      date: now,
      amount: 1180,
      method: 'UPI',
      planId: 'p',
      planName: 'Gold Plan',
      invoiceNumber: 'INV-00001',
      subtotal: 1000,
      gstAmount: 180,
      gstRate: 18,
      durationMonths: 1,
    );

    testWidgets('Shows ownerProfile.gymName and gstin', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(owner: owner, settings: AppSettings(), isLoading: false))),
            membersProvider.overrideWithValue([member]),
            memberPaymentsProvider(member.memberId).overrideWithValue([payment]),
          ],
          child: MaterialApp(
            home: InvoiceScreen(memberId: member.memberId),
          ),
        ),
      );

      expect(find.text('Titan Gym'), findsOneWidget);
      expect(find.textContaining('GST123'), findsOneWidget);
    });

    testWidgets('Shows payment.invoiceNumber and member.name', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(owner: owner, settings: AppSettings(), isLoading: false))),
            membersProvider.overrideWithValue([member]),
            memberPaymentsProvider(member.memberId).overrideWithValue([payment]),
          ],
          child: MaterialApp(
            home: InvoiceScreen(memberId: member.memberId),
          ),
        ),
      );

      expect(find.text('#INV-00001'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Shows correct GST and amount', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(owner: owner, settings: AppSettings(), isLoading: false))),
            membersProvider.overrideWithValue([member]),
            memberPaymentsProvider(member.memberId).overrideWithValue([payment]),
          ],
          child: MaterialApp(
            home: InvoiceScreen(memberId: member.memberId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('₹180.00'), findsOneWidget);
      expect(find.text('₹1180.00'), findsOneWidget);
    });
  });
}
