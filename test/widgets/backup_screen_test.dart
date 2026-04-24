import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironm/features/settings/presentation/screens/backup_screen.dart';
import 'package:ironm/core/providers/backup_provider.dart';
import 'package:ironm/core/services/backup_service.dart';
import 'package:ironm/core/services/restore_service.dart';

class DataBackupViewModel extends BackupViewModel {
  @override
  FutureOr<void> build() => null;
}

class LoadingBackupViewModel extends BackupViewModel {
  @override
  FutureOr<void> build() => Completer<void>().future;
}

void main() {
  group('BackupRestoreScreen Widget Tests', () {
    testWidgets('Renders action buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            backupViewModelProvider.overrideWith(DataBackupViewModel.new),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const BackupRestoreScreen(),
                ),
                GoRoute(
                  path: '/dashboard',
                  builder: (context, state) => const Scaffold(body: Text('Dashboard')),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Create New Backup'), findsOneWidget);
      expect(find.text('Select Backup File'), findsOneWidget);
    });

    testWidgets('Shows loading indicator when state is loading', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            backupViewModelProvider.overrideWith(LoadingBackupViewModel.new),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const BackupRestoreScreen(),
                ),
                GoRoute(
                  path: '/dashboard',
                  builder: (context, state) => const Scaffold(body: Text('Dashboard')),
                ),
              ],
            ),
          ),
        ),
      );

      // We need a small pump to trigger the loading state in the UI if it's not immediate
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
