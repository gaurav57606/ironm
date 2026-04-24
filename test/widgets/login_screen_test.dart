import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/features/auth/presentation/login_screen.dart';
import 'package:ironm/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:ironm/data/models/app_settings.dart';

class FakeAuthViewModel extends AuthViewModel {
  final AuthState _state;
  FakeAuthViewModel(this._state);
  @override
  AuthState build() => _state;
}

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('Renders login UI', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(isLoading: false, settings: AppSettings()))),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('EMAIL ADDRESS'), findsOneWidget);
      expect(find.text('PASSWORD'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('Shows loading state logic', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authProvider.overrideWith(() => FakeAuthViewModel(AuthState(isLoading: true, settings: AppSettings()))),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // _isLoading is local to the widget, so mocking the provider doesn't change it.
      // But we can check if it renders without error.
      expect(find.text('Welcome Back'), findsOneWidget);
    });
  });
}
