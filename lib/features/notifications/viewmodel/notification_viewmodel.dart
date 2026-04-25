import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// In-memory inbox for FCM messages received while app is open.
/// Cleared on app restart — no persistence needed (FCM is ephemeral).
class NotificationInboxNotifier
    extends StateNotifier<List<RemoteMessage>> {
  NotificationInboxNotifier() : super([]) {
    // Listen for foreground messages and add to inbox
    FirebaseMessaging.onMessage.listen((msg) {
      state = [msg, ...state];
    });

    // Listen for notification taps (app in background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      // Mark as already-opened — just add to inbox for display
      state = [msg, ...state];
    });
  }

  void clearAll() => state = [];

  void remove(String? messageId) {
    if (messageId == null) return;
    state = state.where((m) => m.messageId != messageId).toList();
  }
}

final notificationInboxProvider =
    StateNotifierProvider<NotificationInboxNotifier, List<RemoteMessage>>(
  (ref) => NotificationInboxNotifier(),
);

/// Count of unread notifications (simply = inbox length for now)
final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationInboxProvider).length;
});
