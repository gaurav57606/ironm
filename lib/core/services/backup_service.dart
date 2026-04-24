import 'dart:convert';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_service.dart';
import '../../data/models/member.dart';
import '../../data/models/payment.dart';
import '../../data/models/attendance.dart';
import '../../data/models/plan.dart';
import '../../data/models/product.dart';
import '../../data/models/sale.dart';
import '../../data/models/owner_profile.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/domain_event.dart';
import '../../data/models/invoice_sequence.dart';

sealed class BackupResult {}

class BackupSuccess extends BackupResult {
  final String filePath;
  final DateTime timestamp;
  final int memberCount;
  BackupSuccess(this.filePath, this.timestamp, {this.memberCount = 0});
}

class BackupFailure extends BackupResult {
  final String error;
  BackupFailure(this.error);
}

class BackupService {
  static const String _lastAutoBackupKey = 'last_auto_backup';
  static const String _autoBackupEnabledKey = 'auto_backup_enabled';

  Future<String?> getBackupDirectory() async {
    String? backupDir;
    try {
      if (Platform.isAndroid) {
        final externalDirs = await getExternalStorageDirectories(type: StorageDirectory.downloads);
        if (externalDirs != null && externalDirs.isNotEmpty) {
          backupDir = '${externalDirs.first.path}/IronM_Backups';
        }
      }
    } catch (e) {
      LogService.warning('BackupService', 'External storage unavailable: $e');
    }

    if (backupDir == null) {
      final appDocDir = await getApplicationDocumentsDirectory();
      backupDir = '${appDocDir.path}/backups';
    }
    return backupDir;
  }

  Future<List<File>> listBackupFiles() async {
    final path = await getBackupDirectory();
    if (path == null) return [];
    final dir = Directory(path);
    if (!await dir.exists()) return [];
    return dir.list().where((e) => e is File && e.path.endsWith('.json')).cast<File>().toList();
  }

  Future<BackupResult> createBackup(Isar isar) async {
    try {
      LogService.info('BackupService', 'Starting backup...');
      
      final data = {
        'members': await isar.members.where().findAll().then((list) => list.map((e) => _memberToMap(e)).toList()),
        'payments': await isar.payments.where().findAll().then((list) => list.map((e) => _paymentToMap(e)).toList()),
        'attendance': await isar.attendances.where().findAll().then((list) => list.map((e) => _attendanceToMap(e)).toList()),
        'plans': await isar.plans.where().findAll().then((list) => list.map((e) => _planToMap(e)).toList()),
        'products': await isar.products.where().findAll().then((list) => list.map((e) => _productToMap(e)).toList()),
        'sales': await isar.sales.where().findAll().then((list) => list.map((e) => _saleToMap(e)).toList()),
        'ownerProfile': await isar.ownerProfiles.where().findFirst().then((e) => e != null ? _ownerProfileToMap(e) : null),
        'appSettings': await isar.appSettings.where().findFirst().then((e) => e != null ? _appSettingsToMap(e) : null),
        'domainEvents': await isar.domainEvents.where().findAll().then((list) => list.map((e) => e.toJson()).toList()),
        'invoiceSequences': await isar.invoiceSequences.where().findAll().then((list) => list.map((e) => _invoiceSequenceToMap(e)).toList()),
      };

      final dataJson = jsonEncode(data);
      final checksum = sha256.convert(utf8.encode(dataJson)).toString();
      final timestamp = DateTime.now();
      
      final backupContent = {
        'version': 1,
        'exportedAt': timestamp.toUtc().toIso8601String(),
        'appVersion': '1.0.0',
        'checksum': checksum,
        'data': data,
      };

      final fileName = 'ironm_backup_${DateFormat('yyyy-MM-dd_HH-mm').format(timestamp)}.json';
      String? backupDir;

      try {
        if (Platform.isAndroid) {
          final externalDirs = await getExternalStorageDirectories(type: StorageDirectory.downloads);
          if (externalDirs != null && externalDirs.isNotEmpty) {
            backupDir = '${externalDirs.first.path}/IronM_Backups';
          }
        }
      } catch (e) {
        LogService.warning('BackupService', 'External storage unavailable: $e');
      }

      if (backupDir == null) {
        final appDocDir = await getApplicationDocumentsDirectory();
        backupDir = '${appDocDir.path}/backups';
      }

      final dir = Directory(backupDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final file = File('${dir.path}/$fileName');
      await file.writeAsString(jsonEncode(backupContent));

      await _rotateBackups(dir);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastAutoBackupKey, timestamp.toIso8601String());

      LogService.info('BackupService', 'Backup created successfully: ${file.path}');
      return BackupSuccess(file.path, timestamp, memberCount: (data['members'] as List).length);
    } catch (e, stack) {
      LogService.error('BackupService', 'Backup failed: $e', stack);
      return BackupFailure(e.toString());
    }
  }

  Future<void> autoBackupIfDue(Isar isar) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_autoBackupEnabledKey) ?? true;
    if (!enabled) return;

    final lastBackupStr = prefs.getString(_lastAutoBackupKey);
    if (lastBackupStr != null) {
      final lastBackup = DateTime.parse(lastBackupStr);
      if (DateTime.now().difference(lastBackup).inHours < 24) {
        return;
      }
    }

    await createBackup(isar);
  }

  Future<void> _rotateBackups(Directory dir) async {
    final files = await dir.list().where((e) => e is File && e.path.endsWith('.json')).toList();
    if (files.length > 10) {
      files.sort((a, b) => (a as File).lastModifiedSync().compareTo((b as File).lastModifiedSync()));
      final toDelete = files.length - 10;
      for (var i = 0; i < toDelete; i++) {
        await files[i].delete();
      }
    }
  }

  // Helper Mappers
  Map<String, dynamic> _memberToMap(Member m) => {
    'memberId': m.memberId,
    'name': m.name,
    'phone': m.phone,
    'joinDate': m.joinDate.toUtc().toIso8601String(),
    'planId': m.planId,
    'planName': m.planName,
    'expiryDate': m.expiryDate?.toUtc().toIso8601String(),
    'totalPaid': m.totalPaid,
    'paymentIds': m.paymentIds,
    'joinDateHistory': m.joinDateHistory.map((h) => {
      'previousDate': h.previousDate?.toUtc().toIso8601String(),
      'newDate': h.newDate?.toUtc().toIso8601String(),
      'reason': h.reason,
      'changedAt': h.changedAt?.toUtc().toIso8601String(),
    }).toList(),
    'archived': m.archived,
    'lastUpdated': m.lastUpdated.toUtc().toIso8601String(),
    'gender': m.gender,
    'age': m.age,
    'profileImageUrl': m.profileImageUrl,
    'checkInPin': m.checkInPin,
    'lastCheckIn': m.lastCheckIn?.toUtc().toIso8601String(),
    'lastCheckInDevice': m.lastCheckInDevice,
    'hmacSignature': m.hmacSignature,
  };

  Map<String, dynamic> _paymentToMap(Payment p) => {
    'id': p.id,
    'memberId': p.memberId,
    'date': p.date.toUtc().toIso8601String(),
    'amount': p.amount,
    'method': p.method,
    'reference': p.reference,
    'planId': p.planId,
    'planName': p.planName,
    'components': p.components.map((c) => {'name': c.name, 'price': c.price}).toList(),
    'invoiceNumber': p.invoiceNumber,
    'subtotal': p.subtotal,
    'gstAmount': p.gstAmount,
    'gstRate': p.gstRate,
    'durationMonths': p.durationMonths,
    'hmacSignature': p.hmacSignature,
  };

  Map<String, dynamic> _attendanceToMap(Attendance a) => {
    'memberId': a.memberId,
    'checkInTime': a.checkInTime.toUtc().toIso8601String(),
  };

  Map<String, dynamic> _planToMap(Plan p) => {
    'id': p.id,
    'name': p.name,
    'durationMonths': p.durationMonths,
    'components': p.components.map((c) => {'id': c.id, 'name': c.name, 'price': c.price}).toList(),
    'active': p.active,
    'hmacSignature': p.hmacSignature,
  };

  Map<String, dynamic> _productToMap(Product p) => {
    'id': p.id,
    'name': p.name,
    'price': p.price,
    'category': p.category,
    'iconCodePoint': p.iconCodePoint,
  };

  Map<String, dynamic> _saleToMap(Sale s) => {
    'id': s.id,
    'date': s.date.toUtc().toIso8601String(),
    'totalAmount': s.totalAmount,
    'paymentMethod': s.paymentMethod,
    'items': s.items.map((i) => {
      'productId': i.productId,
      'productName': i.productName,
      'price': i.price,
      'quantity': i.quantity,
    }).toList(),
    'invoiceNumber': s.invoiceNumber,
    'hmacSignature': s.hmacSignature,
  };

  Map<String, dynamic> _ownerProfileToMap(OwnerProfile o) => {
    'gymName': o.gymName,
    'ownerName': o.ownerName,
    'phone': o.phone,
    'address': o.address,
    'gstin': o.gstin,
    'bankName': o.bankName,
    'accountNumber': o.accountNumber,
    'ifsc': o.ifsc,
    'upiId': o.upiId,
    'logoPath': o.logoPath,
    'level': o.level,
    'exp': o.exp,
    'strength': o.strength,
    'endurance': o.endurance,
    'dexterity': o.dexterity,
    'selectedCharacterId': o.selectedCharacterId,
    'hmacSignature': o.hmacSignature,
  };

  Map<String, dynamic> _appSettingsToMap(AppSettings s) => {
    'gstRate': s.gstRate,
    'expiryReminderDays': s.expiryReminderDays,
    'whatsappReminders': s.whatsappReminders,
    'useBiometrics': s.useBiometrics,
    'businessType': s.businessType,
    'lastBackupAt': s.lastBackupAt?.toUtc().toIso8601String(),
  };

  Map<String, dynamic> _invoiceSequenceToMap(InvoiceSequence i) => {
    'prefix': i.prefix,
    'lastNumber': i.lastNumber,
  };
}
