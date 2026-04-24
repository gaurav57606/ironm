import 'dart:convert';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:crypto/crypto.dart';
import 'log_service.dart';
import 'backup_service.dart';
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

sealed class RestoreResult {}

class RestoreSuccess extends RestoreResult {
  final int membersRestored;
  final int paymentsRestored;
  final DateTime backupDate;
  RestoreSuccess(this.membersRestored, this.paymentsRestored, this.backupDate);
}

class RestoreFailure extends RestoreResult {
  final String error;
  RestoreFailure(this.error);
}

class RestoreService {
  Future<RestoreResult> restoreFromFile(Isar isar, String filePath) async {
    try {
      LogService.info('RestoreService', 'Starting restore from: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        return RestoreFailure('Backup file not found');
      }

      final content = await file.readAsString();
      final Map<String, dynamic> backup = jsonDecode(content);

      if (backup['version'] != 1) {
        return RestoreFailure('Backup version ${backup['version']} is not supported');
      }

      final String? checksum = backup['checksum'];
      final dynamic data = backup['data'];
      
      if (data == null || checksum == null) {
        return RestoreFailure('File is corrupted or not a valid backup');
      }

      final dataJson = jsonEncode(data);
      final recalculatedChecksum = sha256.convert(utf8.encode(dataJson)).toString();

      if (recalculatedChecksum != checksum) {
        return RestoreFailure('Backup file checksum mismatch — file may be corrupted');
      }

      // Safety Backup
      LogService.info('RestoreService', 'Creating safety backup...');
      final safetyBackup = await BackupService().createBackup(isar);
      if (safetyBackup is BackupFailure) {
        return RestoreFailure('Safety backup failed: ${safetyBackup.error}. Aborting restore.');
      }

      LogService.info('RestoreService', 'Clearing current data and restoring...');

      int membersCount = 0;
      int paymentsCount = 0;

      await isar.writeTxn(() async {
        // Clear all collections
        await isar.members.clear();
        await isar.payments.clear();
        await isar.attendances.clear();
        await isar.plans.clear();
        await isar.products.clear();
        await isar.sales.clear();
        await isar.ownerProfiles.clear();
        await isar.appSettings.clear();
        await isar.domainEvents.clear();
        await isar.invoiceSequences.clear();

        final mapData = data as Map<String, dynamic>;

        if (mapData['members'] != null) {
          final members = (mapData['members'] as List).map((e) => _mapToMember(e as Map<String, dynamic>)).toList();
          await isar.members.putAll(members);
          membersCount = members.length;
        }

        if (mapData['payments'] != null) {
          final payments = (mapData['payments'] as List).map((e) => _mapToPayment(e as Map<String, dynamic>)).toList();
          await isar.payments.putAll(payments);
          paymentsCount = payments.length;
        }

        if (mapData['attendance'] != null) {
          final attendance = (mapData['attendance'] as List).map((e) => _mapToAttendance(e as Map<String, dynamic>)).toList();
          await isar.attendances.putAll(attendance);
        }

        if (mapData['plans'] != null) {
          final plans = (mapData['plans'] as List).map((e) => _mapToPlan(e as Map<String, dynamic>)).toList();
          await isar.plans.putAll(plans);
        }

        if (mapData['products'] != null) {
          final products = (mapData['products'] as List).map((e) => _mapToProduct(e as Map<String, dynamic>)).toList();
          await isar.products.putAll(products);
        }

        if (mapData['sales'] != null) {
          final sales = (mapData['sales'] as List).map((e) => _mapToSale(e as Map<String, dynamic>)).toList();
          await isar.sales.putAll(sales);
        }

        if (mapData['ownerProfile'] != null) {
          await isar.ownerProfiles.put(_mapToOwnerProfile(mapData['ownerProfile'] as Map<String, dynamic>));
        }

        if (mapData['appSettings'] != null) {
          await isar.appSettings.put(_mapToAppSettings(mapData['appSettings'] as Map<String, dynamic>));
        }

        if (mapData['domainEvents'] != null) {
          final events = (mapData['domainEvents'] as List).map((e) => DomainEvent.fromJson(e as Map<String, dynamic>)).toList();
          await isar.domainEvents.putAll(events);
        }

        if (mapData['invoiceSequences'] != null) {
          final sequences = (mapData['invoiceSequences'] as List).map((e) => _mapToInvoiceSequence(e as Map<String, dynamic>)).toList();
          await isar.invoiceSequences.putAll(sequences);
        }
      });

      LogService.info('RestoreService', 'Restore completed successfully');
      return RestoreSuccess(membersCount, paymentsCount, DateTime.parse(backup['exportedAt']));
    } catch (e, stack) {
      LogService.error('RestoreService', 'Restore failed: $e', stack);
      return RestoreFailure(e.toString());
    }
  }

  // Inverse Helpers
  Member _mapToMember(Map<String, dynamic> m) => Member(
    memberId: m['memberId'],
    name: m['name'],
    phone: m['phone'],
    joinDate: DateTime.parse(m['joinDate']).toLocal(),
    planId: m['planId'],
    planName: m['planName'],
    expiryDate: m['expiryDate'] != null ? DateTime.parse(m['expiryDate']).toLocal() : null,
    totalPaid: m['totalPaid'] ?? 0,
    paymentIds: List<String>.from(m['paymentIds'] ?? []),
    joinDateHistory: (m['joinDateHistory'] as List? ?? []).map((h) => JoinDateChange(
      previousDate: h['previousDate'] != null ? DateTime.parse(h['previousDate']).toLocal() : null,
      newDate: h['newDate'] != null ? DateTime.parse(h['newDate']).toLocal() : null,
      reason: h['reason'],
      changedAt: h['changedAt'] != null ? DateTime.parse(h['changedAt']).toLocal() : null,
    )).toList(),
    archived: m['archived'] ?? false,
    lastUpdated: DateTime.parse(m['lastUpdated']).toLocal(),
    gender: m['gender'],
    age: m['age'],
    profileImageUrl: m['profileImageUrl'],
    checkInPin: m['checkInPin'],
    lastCheckIn: m['lastCheckIn'] != null ? DateTime.parse(m['lastCheckIn']).toLocal() : null,
    lastCheckInDevice: m['lastCheckInDevice'],
    hmacSignature: m['hmacSignature'] ?? '',
  );

  Payment _mapToPayment(Map<String, dynamic> p) => Payment(
    id: p['id'],
    memberId: p['memberId'],
    date: DateTime.parse(p['date']).toLocal(),
    amount: (p['amount'] as num).toDouble(),
    method: p['method'],
    reference: p['reference'],
    planId: p['planId'],
    planName: p['planName'],
    components: (p['components'] as List? ?? []).map((c) => PlanComponentSnapshot(
      name: c['name'],
      price: (c['price'] as num).toDouble(),
    )).toList(),
    invoiceNumber: p['invoiceNumber'],
    subtotal: (p['subtotal'] as num).toDouble(),
    gstAmount: (p['gstAmount'] as num).toDouble(),
    gstRate: (p['gstRate'] as num).toDouble(),
    durationMonths: p['durationMonths'],
    hmacSignature: p['hmacSignature'] ?? '',
  );

  Attendance _mapToAttendance(Map<String, dynamic> a) => Attendance(
    memberId: a['memberId'],
    checkInTime: DateTime.parse(a['checkInTime']).toLocal(),
  );

  Plan _mapToPlan(Map<String, dynamic> p) => Plan(
    id: p['id'],
    name: p['name'],
    durationMonths: p['durationMonths'],
    components: (p['components'] as List? ?? []).map((c) => PlanComponent(
      id: c['id'],
      name: c['name'],
      price: (c['price'] as num).toDouble(),
    )).toList(),
    active: p['active'] ?? true,
    hmacSignature: p['hmacSignature'] ?? '',
  );

  Product _mapToProduct(Map<String, dynamic> p) => Product(
    id: p['id'],
    name: p['name'],
    price: (p['price'] as num).toDouble(),
    category: p['category'],
    iconCodePoint: p['iconCodePoint'],
  );

  Sale _mapToSale(Map<String, dynamic> s) => Sale(
    id: s['id'],
    date: DateTime.parse(s['date']).toLocal(),
    totalAmount: (s['totalAmount'] as num).toDouble(),
    paymentMethod: s['paymentMethod'],
    items: (s['items'] as List? ?? []).map((i) => SaleItem(
      productId: i['productId'],
      productName: i['productName'],
      price: (i['price'] as num).toDouble(),
      quantity: i['quantity'],
    )).toList(),
    invoiceNumber: s['invoiceNumber'],
    hmacSignature: s['hmacSignature'] ?? '',
  );

  OwnerProfile _mapToOwnerProfile(Map<String, dynamic> o) => OwnerProfile(
    gymName: o['gymName'] ?? '',
    ownerName: o['ownerName'] ?? '',
    phone: o['phone'] ?? '',
    address: o['address'] ?? '',
    gstin: o['gstin'],
    bankName: o['bankName'],
    accountNumber: o['accountNumber'],
    ifsc: o['ifsc'],
    upiId: o['upiId'],
    logoPath: o['logoPath'],
    level: o['level'] ?? 1,
    exp: o['exp'] ?? 0,
    strength: (o['strength'] as num?)?.toDouble() ?? 0.5,
    endurance: (o['endurance'] as num?)?.toDouble() ?? 0.5,
    dexterity: (o['dexterity'] as num?)?.toDouble() ?? 0.5,
    selectedCharacterId: o['selectedCharacterId'] ?? 'warrior',
    hmacSignature: o['hmacSignature'] ?? '',
  );

  AppSettings _mapToAppSettings(Map<String, dynamic> s) => AppSettings(
    gstRate: (s['gstRate'] as num?)?.toDouble() ?? 18.0,
    expiryReminderDays: s['expiryReminderDays'] ?? 3,
    whatsappReminders: s['whatsappReminders'] ?? true,
    useBiometrics: s['useBiometrics'] ?? false,
    businessType: s['businessType'] ?? 'Gym',
    lastBackupAt: s['lastBackupAt'] != null ? DateTime.parse(s['lastBackupAt']).toLocal() : null,
  );

  InvoiceSequence _mapToInvoiceSequence(Map<String, dynamic> i) => InvoiceSequence(
    prefix: i['prefix'],
    lastNumber: i['lastNumber'] ?? 0,
  );
}
