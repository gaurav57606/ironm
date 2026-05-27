import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/ac_colors.dart';
import '../core/constants/ac_text_styles.dart';
import '../widgets/app_toast.dart';
import 'home_dashboard_screen.dart';
import 'users_list_screen.dart';
import 'activity_log_screen.dart';
import 'admin_tools_screen.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);

    final List<Widget> tabs = [
      const HomeDashboardScreen(),
      const UsersListScreen(),
      const ActivityLogScreen(),
      const AdminToolsScreen(),
    ];

    return Scaffold(
      backgroundColor: AcColors.bg,
      body: Stack(
        children: [
          // Screen Area
          Positioned.fill(
            child: IndexedStack(
              index: currentTab,
              children: tabs,
            ),
          ),
          
          // Toast Overlay Floating above the Bottom Nav
          const AppToastOverlay(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 76,
        decoration: const BoxDecoration(
          color: AcColors.s1,
          border: Border(
            top: BorderSide(color: AcColors.rim, width: 1),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
        child: Row(
          children: [
            _buildTab(
              ref: ref,
              index: 0,
              currentIndex: currentTab,
              icon: Icons.grid_view_rounded,
              label: 'Home',
            ),
            _buildTab(
              ref: ref,
              index: 1,
              currentIndex: currentTab,
              icon: Icons.people_outline_rounded,
              label: 'Users',
              showDot: true, // Matching HTML .ntab-dot on Users
            ),
            _buildTab(
              ref: ref,
              index: 2,
              currentIndex: currentTab,
              icon: Icons.show_chart_rounded,
              label: 'Activity',
            ),
            _buildTab(
              ref: ref,
              index: 3,
              currentIndex: currentTab,
              icon: Icons.handyman_outlined,
              label: 'Tools',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required WidgetRef ref,
    required int index,
    required int currentIndex,
    required IconData icon,
    required String label,
    bool showDot = false,
  }) {
    final isActive = index == currentIndex;
    final color = isActive ? AcColors.primary : AcColors.textMuted;

    return Expanded(
      child: InkWell(
        onTap: () => ref.read(currentTabProvider.notifier).state = index,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: AcTextStyles.label.copyWith(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (showDot)
              Positioned(
                top: 14,
                right: MediaQuery.of(ref.context).size.width / 8 - 14,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AcColors.expired, // Red dot matching HTML
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
