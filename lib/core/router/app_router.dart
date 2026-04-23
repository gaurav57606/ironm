import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/notifiers/auth_notifier.dart';
import '../../features/home/presentation/widgets/main_shell.dart';
import '../../features/home/presentation/screens/dashboard_screen.dart';
import '../../features/members/presentation/screens/members_list_screen.dart';
import '../../features/members/presentation/screens/quick_add_member_screen.dart';
import '../../features/members/presentation/screens/member_detail_screen.dart';
import '../../features/nutrition/presentation/screens/nutrition_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/billing/presentation/screens/pos_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/pin_setup_screen.dart';
import '../../features/auth/presentation/screens/pin_entry_screen.dart';
import '../../features/notifications/presentation/screens/notifications_hub_screen.dart';
import '../../features/attendance/presentation/attendance_screen.dart';
import '../../features/billing/presentation/screens/invoice_screen.dart';


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
        if ((isLoggingIn || isOnboarding || state.matchedLocation == '/') && unlocked) return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: Center(child: CircularProgressIndicator())),
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
      GoRoute(
        path: '/gamification',
        builder: (context, state) => const GamificationScreen(),
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
                          return InvoiceScreen(memberId: memberId);
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
                path: '/nutrition',
                builder: (context, state) => const NutritionScreen(),
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
                builder: (context, state) => const NotificationsHubScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
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
