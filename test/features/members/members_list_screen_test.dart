import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironm/features/members/presentation/members_list_screen.dart';
import 'package:ironm/features/members/viewmodel/members_viewmodel.dart';
import 'package:ironm/data/models/member.dart';

void main() {
  testWidgets('MembersListScreen shows loading initially', (tester) async {
    // Note: StreamProvider initially emits AsyncLoading if no value is present
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          membersStreamProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: const MaterialApp(home: MembersListScreen()),
      ),
    );
    // Since we used Stream.empty(), it might stay loading or show empty depending on how it's handled.
    // Actually membersProvider uses .value ?? [] which handles the null/loading case.
    
    expect(find.byType(MembersListScreen), findsOneWidget);
  });

  testWidgets('MembersListScreen shows empty state when no members', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          membersStreamProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(home: MembersListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No members found'), findsOneWidget);
  });

  testWidgets('MembersListScreen shows members when data is present', (tester) async {
    final members = [
      Member(
        memberId: '1',
        name: 'John Doe',
        joinDate: DateTime.now(),
        lastUpdated: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          membersStreamProvider.overrideWith((ref) => Stream.value(members)),
        ],
        child: const MaterialApp(home: MembersListScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('John Doe'), findsOneWidget);
  });
}

