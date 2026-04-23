import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id? isarId;

  late double gstRate;
  late int expiryReminderDays;
  late bool whatsappReminders;
  late bool useBiometrics;
  late String businessType;
  DateTime? lastBackupAt;

  AppSettings({
    this.gstRate = 18.0,
    this.expiryReminderDays = 3,
    this.whatsappReminders = true,
    this.useBiometrics = false,
    this.businessType = 'Gym',
    this.lastBackupAt,
  });
}
