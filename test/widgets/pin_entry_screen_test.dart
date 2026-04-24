import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironm/features/auth/presentation/pin_entry_screen.dart';
import 'package:ironm/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:ironm/data/models/app_settings.dart';

class FakeAuthViewModel extends AuthViewModel {
  final AuthState _state;
  FakeAuthViewModel(this._state);
  @override
  AuthState build() => _state;

  @override
  Future<bool> verifyPin(String pin) async => true;
}

void main() {
  group('PinEntryScreen Widget Tests', () {
    testWidgets('Renders numpad and header', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(isLoading: false, settings: AppSettings()))),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const PinEntryScreen(),
                ),
                GoRoute(
                  path: '/dashboard',
                  builder: (context, state) => const Scaffold(body: Text('Dashboard')),
                ),
                GoRoute(
                  path: '/forgot-password',
                  builder: (context, state) => const Scaffold(body: Text('Forgot Password')),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Secure Access'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('Entering 4 digits triggers verification', (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(isLoading: false, settings: AppSettings()))),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const PinEntryScreen(),
                ),
                GoRoute(
                  path: '/dashboard',
                  builder: (context, state) => const Scaffold(body: Text('Dashboard')),
                ),
                GoRoute(
                  path: '/forgot-password',
                  builder: (context, state) => const Scaffold(body: Text('Forgot Password')),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('3'));
      await tester.pump();
      
      // Verification happens on the 4th digit
      await tester.tap(find.text('4'));
      await tester.pumpAndSettle();
    });
  });
}
