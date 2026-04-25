import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../firebase/firebase_providers.dart';

/// Background message handler — must be top-level function.
/// This runs in a separate isolate. No Riverpod, no BuildContext.
@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  debugPrint('FCM background: ${message.messageId}');
  // Local notification is handled by flutter_local_notifications
  // plugin automatically for data-only messages if configured.
}

class FcmService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore? _firestore;
  final FirebaseAuth? _auth;
  final FlutterLocalNotificationsPlugin _localNotifications;

  // Android notification channel for FCM
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'ironm_fcm_channel',
    'IronM Alerts',
    description: 'Membership and gym alerts from IronM',
    importance: Importance.high,
  );

  FcmService(
    this._messaging,
    this._firestore,
    this._auth,
    this._localNotifications,
  );

  /// Call once on app boot after Firebase init.
  Future<void> initialize() async {
    try {
      // Register background handler
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

      // Request permission (iOS + Android 13+)
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint('FCM permission: ${settings.authorizationStatus}');

      // Create Android notification channel
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      // Handle foreground messages — show as local notification
      FirebaseMessaging.onMessage.listen((message) {
        _showLocalNotification(message);
      });

      // Get and save FCM token to Firestore
      final token = await _messaging.getToken();
      if (token != null) await _saveFcmToken(token);

      // Refresh token listener
      _messaging.onTokenRefresh.listen(_saveFcmToken);
    } catch (e) {
      debugPrint('FcmService.initialize error (non-fatal): $e');
    }
  }

  Future<void> _saveFcmToken(String token) async {
    try {
      final uid = _auth?.currentUser?.uid;
      if (uid == null || _firestore == null) return;
      await _firestore!
          .collection('fcm_tokens')
          .doc(uid)
          .set({'token': token, 'updatedAt': FieldValue.serverTimestamp()},
              SetOptions(merge: true));
      debugPrint('FCM token saved for uid=$uid');
    } catch (e) {
      debugPrint('FcmService._saveFcmToken error: $e');
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _localNotifications.show(
      notification.hashCode,
      notification.title ?? 'IronM',
      notification.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Subscribe this device to the owner's topic.
  /// Topic format: gym_{uid}  (sanitized: no special chars)
  Future<void> subscribeToOwnerTopic(String uid) async {
    try {
      final topic = 'gym_$uid'.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
      await _messaging.subscribeToTopic(topic);
      debugPrint('FCM subscribed to topic: $topic');
    } catch (e) {
      debugPrint('FcmService.subscribeToOwnerTopic error: $e');
    }
  }
}

final fcmServiceProvider = Provider<FcmService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth      = ref.watch(firebaseAuthProvider);
  return FcmService(
    FirebaseMessaging.instance,
    firestore,
    auth,
    FlutterLocalNotificationsPlugin(),
  );
});
