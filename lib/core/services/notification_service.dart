import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';
import '../../data/models/member.dart';
import 'log_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String _channelId = 'ironm_expiry_channel';
  static const String _channelName = 'Member Expiry Alerts';
  static const String _channelDescription = 'Notifications for expiring and expired gym memberships';

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _notificationsPlugin.initialize(settings: initSettings);
    LogService.info('NotificationService', 'Initialized');
  }

  static Future<void> showExpiryNotification({
    required int memberId,
    required String memberName,
    required int daysLeft,
  }) async {
    final title = daysLeft > 0 ? '⚠️ Expiring Soon' : '❌ Membership Expired';
    final body = daysLeft > 0 
        ? "$memberName's membership expires in $daysLeft day(s)"
        : "$memberName's membership expired today";

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      id: memberId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  static Future<void> checkAndNotifyExpiring(Isar isar) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final sevenDaysLater = today.add(const Duration(days: 7));

      // Expiring in next 7 days
      final expiringMembers = await isar.members
          .where()
          .filter()
          .expiryDateBetween(today, sevenDaysLater)
          .and()
          .archivedEqualTo(false)
          .findAll();

      for (final member in expiringMembers) {
        final daysLeft = member.expiryDate!.difference(today).inDays;
        await showExpiryNotification(
          memberId: member.isarId ?? 0,
          memberName: member.name,
          daysLeft: daysLeft,
        );
      }

      // Already expired but still active
      final expiredMembers = await isar.members
          .where()
          .filter()
          .expiryDateLessThan(today)
          .and()
          .archivedEqualTo(false)
          .findAll();

      for (final member in expiredMembers) {
        await showExpiryNotification(
          memberId: member.isarId ?? 0,
          memberName: member.name,
          daysLeft: 0,
        );
      }
    } catch (e, stack) {
      LogService.error('NotificationService', 'Check failed: $e', stack);
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    LogService.info('NotificationService', 'All notifications cancelled');
  }
}
