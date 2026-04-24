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

  Map<String, dynamic> toJson() => {
    'gstRate': gstRate,
    'expiryReminderDays': expiryReminderDays,
    'whatsappReminders': whatsappReminders,
    'useBiometrics': useBiometrics,
    'businessType': businessType,
    'lastBackupAt': lastBackupAt?.toIso8601String(),
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    gstRate: (json['gstRate'] as num?)?.toDouble() ?? 18.0,
    expiryReminderDays: json['expiryReminderDays'] ?? 3,
    whatsappReminders: json['whatsappReminders'] ?? true,
    useBiometrics: json['useBiometrics'] ?? false,
    businessType: json['businessType'] ?? 'Gym',
    lastBackupAt: json['lastBackupAt'] != null ? DateTime.parse(json['lastBackupAt']) : null,
  );
}
