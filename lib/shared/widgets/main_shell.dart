import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_bottom_nav.dart';
import 'status_bar_wrapper.dart';
import 'sync_status_indicator.dart';


class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StatusBarWrapper(
      child: Scaffold(
        body: Column(
          children: [
            // Header with Sync Status
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SyncStatusIndicator(),
                ],
              ),
            ),
            Expanded(child: navigationShell),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTap,
        ),
      ),
    );
  }
}
