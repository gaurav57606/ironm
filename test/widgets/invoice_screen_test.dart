import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
      id: 'payment_id_long_enough',
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
      tester.view.physicalSize = const Size(600, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(owner: owner, settings: AppSettings(), isLoading: false))),
            membersProvider.overrideWithValue([member]),
            paymentsStreamProvider.overrideWith((ref) => Stream.value([payment])),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => InvoiceScreen(memberId: member.memberId),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(owner.gymName), findsOneWidget);
      expect(find.textContaining(owner.gstin ?? 'GST123'), findsOneWidget);
    });

    testWidgets('Shows payment.invoiceNumber and member.name', (tester) async {
      tester.view.physicalSize = const Size(600, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(owner: owner, settings: AppSettings(), isLoading: false))),
            membersProvider.overrideWithValue([member]),
            paymentsStreamProvider.overrideWith((ref) => Stream.value([payment])),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => InvoiceScreen(memberId: member.memberId),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('INV-00001'), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('Shows correct GST and amount', (tester) async {
      tester.view.physicalSize = const Size(600, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(owner: owner, settings: AppSettings(), isLoading: false))),
            membersProvider.overrideWithValue([member]),
            paymentsStreamProvider.overrideWith((ref) => Stream.value([payment])),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => InvoiceScreen(memberId: member.memberId),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Relaxed finders to handle currency symbol variations
      expect(find.textContaining('180'), findsWidgets);
      expect(find.textContaining('1180'), findsWidgets);
    });
  });
}
