import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/admin_auth_provider.dart';
import '../../screens/login_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/subscribers_list_screen.dart';
import '../../screens/subscriber_detail_screen.dart';
import '../../screens/create_subscriber_screen.dart';

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(adminAuthProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}

final _routerNotifierProvider = Provider<_RouterNotifier>((ref) {
  return _RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authStatus = ref.read(adminAuthProvider);
      final isLoginPath = state.matchedLocation == '/login';

      if (authStatus == AdminAuthStatus.loading) return null;

      if (authStatus == AdminAuthStatus.loggedOut ||
          authStatus == AdminAuthStatus.unauthorized) {
        return isLoginPath ? null : '/login';
      }

      if (authStatus == AdminAuthStatus.loggedIn && isLoginPath) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (_, __) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/subscribers',
        builder: (_, __) => const SubscribersListScreen(),
      ),
      GoRoute(
        path: '/subscriber/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return SubscriberDetailScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/create-subscriber',
        builder: (_, __) => const CreateSubscriberScreen(),
      ),
    ],
  );
});
