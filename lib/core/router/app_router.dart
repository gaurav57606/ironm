import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/viewmodel/auth_viewmodel.dart';
import '../../shared/widgets/main_shell.dart';


import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/members/presentation/members_list_screen.dart';
import '../../features/members/presentation/quick_add_member_screen.dart';
import '../../features/members/presentation/member_detail_screen.dart';
import '../../features/analytics/presentation/analytics_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/backup_restore_screen.dart';
import '../../features/billing/presentation/pos_screen.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/pin_setup_screen.dart';
import '../../features/auth/presentation/pin_entry_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';

import '../../features/attendance/presentation/attendance_screen.dart';
import '../../features/billing/presentation/invoice_screen.dart';
import '../../features/plans/presentation/plans_screen.dart';


final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final isAuth = authState.isAuthenticated;
      final isFirstLaunch = authState.isFirstLaunch;
      final isPinSetup = authState.isPinSetup;
      final unlocked = authState.unlocked;

      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isPinSetupPath = state.matchedLocation == '/setup-pin';
      final isPinEntryPath = state.matchedLocation == '/unlock';

      if (isFirstLaunch && !isOnboarding) return '/onboarding';
      if (!isAuth && !isLoggingIn && !isOnboarding) return '/login';

      if (isAuth) {
        if (!isPinSetup && !isPinSetupPath) return '/setup-pin';
        if (isPinSetup && !unlocked && !isPinEntryPath) return '/unlock';
        if ((isLoggingIn || isOnboarding || state.matchedLocation == '/') &&
            unlocked) {
          return '/dashboard';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/setup-pin',
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: '/unlock',
        builder: (context, state) => const PinEntryScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),


      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/gym',
                builder: (context, state) => const MembersListScreen(),
                routes: [
                  GoRoute(
                    path: 'add-member',
                    builder: (context, state) => const QuickAddMemberScreen(),
                  ),
                  GoRoute(
                    path: 'member-details/:memberId',
                    builder: (context, state) {
                      final memberId = state.pathParameters['memberId']!;
                      return MemberDetailScreen(memberId: memberId);
                    },
                    routes: [
                      GoRoute(
                        path: 'invoice',
                        builder: (context, state) {
                          final memberId = state.pathParameters['memberId'];
                          return InvoiceScreen(memberId: memberId ?? '');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pos',
                builder: (context, state) => const POSScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/attendance',
                builder: (context, state) => const AttendanceScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notifications',
                builder: (context, state) => const NotificationsScreen(),
              ),

            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'backup-restore',
                    builder: (context, state) => const BackupRestoreScreen(),
                  ),
                  GoRoute(
                    path: 'plans',
                    builder: (context, state) => const PlansScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Coming Soon: $title')),
    );
  }
}
