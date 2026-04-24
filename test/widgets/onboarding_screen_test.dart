import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/features/auth/presentation/onboarding_screen.dart';
import 'package:ironm/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:ironm/data/models/app_settings.dart';

class FakeAuthViewModel extends AuthViewModel {
  final AuthState _state;
  FakeAuthViewModel(this._state);
  @override
  AuthState build() => _state;
}

void main() {
  group('OnboardingScreen Widget Tests', () {
    testWidgets('Renders first page content', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(isLoading: false, settings: AppSettings()))),
          ],
          child: const MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      expect(find.text('Track every member'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('Swiping changes pages', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(isLoading: false, settings: AppSettings()))),
          ],
          child: const MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Instant invoices'), findsOneWidget);
    });

    testWidgets('Last page shows "Get Started"', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(isLoading: false, settings: AppSettings()))),
          ],
          child: const MaterialApp(
            home: OnboardingScreen(),
          ),
        ),
      );

      // Go to last page (3 pages total)
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
    });
  });
}
