import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironbook_gm/features/members/presentation/members_list_screen.dart';
import 'package:ironbook_gm/features/members/viewmodel/members_viewmodel.dart';
import 'package:ironbook_gm/data/models/member.dart';

void main() {
  testWidgets('MembersListScreen shows loading initially', (tester) async {
    final controller = StreamController<List<Member>>();
    addTearDown(controller.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          membersViewModelProvider.overrideWith(() => MockMembersViewModel(controller.stream)),
        ],
        child: const MaterialApp(home: MembersListScreen()),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Clear loading state by sending empty data
    controller.add([]);
    await tester.pump();
    // No more indicator, no more timers
  });

  testWidgets('MembersListScreen shows empty state when no members', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          membersViewModelProvider.overrideWith(() => MockMembersViewModel(Stream.value([]))),
        ],
        child: const MaterialApp(home: MembersListScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('No members yet. Add your first member!'), findsOneWidget);
  });
}

class MockMembersViewModel extends MembersViewModel {
  final Stream<List<Member>> stream;
  MockMembersViewModel(this.stream);

  @override
  Stream<List<Member>> build() => stream;
}
