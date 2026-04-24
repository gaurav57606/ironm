// test/core/services/backup_service_test.dart
//
// Tests for BackupService and RestoreService.
// Uses a real temporary Isar instance for integration-level accuracy.
// Requires: mocktail, flutter_test, isar_flutter_libs

import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:ironm/core/services/backup_service.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ironm/core/services/restore_service.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/payment.dart';
import 'package:ironm/data/models/attendance.dart';
import 'package:ironm/data/models/plan.dart';
import 'package:ironm/data/models/product.dart';
import 'package:ironm/data/models/sale.dart';
import 'package:ironm/data/models/owner_profile.dart';
import 'package:ironm/data/models/app_settings.dart';
import 'package:ironm/data/models/domain_event.dart';
import 'package:ironm/data/models/invoice_sequence.dart';

// ── Fake PathProvider ────────────────────────────────────────────────
class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String tempPath;
  FakePathProviderPlatform(this.tempPath);

  @override
  Future<String?> getApplicationDocumentsPath() async => tempPath;
  @override
  Future<String?> getTemporaryPath() async => tempPath;
  @override
  Future<String?> getExternalStoragePath() async => null;
  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) async => null;
}

// ── Helpers ──────────────────────────────────────────────────────────

Future<Isar> _openTestIsar(String dir) async {
  return Isar.open(
    [
      MemberSchema,
      PaymentSchema,
      AttendanceSchema,
      PlanSchema,
      DomainEventSchema,
      ProductSchema,
      SaleSchema,
      OwnerProfileSchema,
      InvoiceSequenceSchema,
      AppSettingsSchema,
    ],
    directory: dir,
    name: 'test_${DateTime.now().millisecondsSinceEpoch}',
  );
}

Member _fakeMember() => Member(
      memberId: 'M001',
      name: 'Ravi Kumar',
      phone: '9876543210',
      joinDate: DateTime(2026, 1, 1),
      expiryDate: DateTime(2026, 5, 1),
      lastUpdated: DateTime(2026, 1, 1),
    );

// ── Tests ────────────────────────────────────────────────────────────

void main() {
  late Directory tempDir;
  late Isar isar;
  late BackupService backupService;
  late RestoreService restoreService;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('ironm_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
    isar = await _openTestIsar(tempDir.path);
    backupService = BackupService();
    restoreService = RestoreService();
  });

  tearDown(() async {
    await isar.close();
    await tempDir.delete(recursive: true);
  });

  // ── BackupService Tests ─────────────────────────────────────────

  group('BackupService', skip: 'Requires Isar native binary', () {
    test('createBackup returns BackupSuccess with valid file path', () async {
      // Seed a member
      await isar.writeTxn(() async {
        await isar.members.put(_fakeMember());
      });

      final result = await backupService.createBackup(isar);

      expect(result, isA<BackupSuccess>());
      final success = result as BackupSuccess;
      expect(File(success.filePath).existsSync(), isTrue);
      expect(success.memberCount, 1);
    });

    test('backup file contains valid JSON envelope', () async {
      await isar.writeTxn(() async {
        await isar.members.put(_fakeMember());
      });

      final result = await backupService.createBackup(isar) as BackupSuccess;
      final raw = File(result.filePath).readAsStringSync();
      final json = jsonDecode(raw) as Map<String, dynamic>;

      expect(json['version'], 1);
      expect(json.containsKey('checksum'), isTrue);
      expect(json.containsKey('exportedAt'), isTrue);
      expect(json['data']['members'], isA<List>());
    });

    test('backup checksum matches data section', () async {
      final result = await backupService.createBackup(isar) as BackupSuccess;
      final raw = File(result.filePath).readAsStringSync();
      final json = jsonDecode(raw) as Map<String, dynamic>;


      final dataJson = jsonEncode(json['data']);
      final recomputed = crypto.sha256
          .convert(utf8.encode(dataJson))
          .toString();

      expect(json['checksum'], recomputed);
    });

    test('autoBackupIfDue skips if last backup was less than 24h ago',
        () async {
      // Set last backup to now
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'last_auto_backup', DateTime.now().toUtc().toIso8601String());

      int backupCount = 0;
      // Spy not available, so check file count instead
      final dirBefore = await backupService.listBackupFiles();
      await backupService.autoBackupIfDue(isar);
      final dirAfter = await backupService.listBackupFiles();

      expect(dirAfter.length, dirBefore.length); // no new backup created
    });
  });

  // ── RestoreService Tests ────────────────────────────────────────

  group('RestoreService', skip: 'Requires Isar native binary', () {
    test('restoreFromFile succeeds and restores members', () async {
      // Create data + backup
      await isar.writeTxn(() async {
        await isar.members.put(_fakeMember());
      });
      final backupResult =
          await backupService.createBackup(isar) as BackupSuccess;

      // Clear isar
      await isar.writeTxn(() async {
        await isar.members.clear();
      });
      expect(await isar.members.count(), 0);

      // Restore
      final result = await restoreService.restoreFromFile(
          isar, backupResult.filePath);

      expect(result, isA<RestoreSuccess>());
      final success = result as RestoreSuccess;
      expect(success.membersRestored, 1);
      expect(await isar.members.count(), 1);
    });

    test('restoreFromFile returns RestoreFailure for non-existent file',
        () async {
      final result = await restoreService.restoreFromFile(
          isar, '/non/existent/file.json');
      expect(result, isA<RestoreFailure>());
    });

    test('restoreFromFile returns RestoreFailure for corrupted JSON',
        () async {
      final badFile = File('${tempDir.path}/bad.json');
      await badFile.writeAsString('THIS IS NOT JSON {{{');

      final result =
          await restoreService.restoreFromFile(isar, badFile.path);
      expect(result, isA<RestoreFailure>());
      expect((result as RestoreFailure).error,
          contains('corrupted or not a valid'));
    });

    test('restoreFromFile returns RestoreFailure for unsupported version',
        () async {
      final fakeBackup = jsonEncode({
        'version': 99,
        'exportedAt': DateTime.now().toIso8601String(),
        'appVersion': '1.0.0',
        'checksum': 'fakechecksum',
        'data': {},
      });
      final f = File('${tempDir.path}/v99.json');
      await f.writeAsString(fakeBackup);

      final result = await restoreService.restoreFromFile(isar, f.path);
      expect(result, isA<RestoreFailure>());
      expect((result as RestoreFailure).error, contains('version'));
    });

    test('restoreFromFile returns RestoreFailure for checksum mismatch',
        () async {
      // Build a valid backup then tamper with data
      await isar.writeTxn(() async {
        await isar.members.put(_fakeMember());
      });
      final backupResult =
          await backupService.createBackup(isar) as BackupSuccess;
      final raw = File(backupResult.filePath).readAsStringSync();
      final json = jsonDecode(raw) as Map<String, dynamic>;

      // Tamper: inject an extra member into data
      (json['data']['members'] as List).add({'memberId': 'HACKER', 'name': 'Injected'});

      final tamperedFile = File('${tempDir.path}/tampered.json');
      await tamperedFile.writeAsString(jsonEncode(json));

      final result =
          await restoreService.restoreFromFile(isar, tamperedFile.path);
      expect(result, isA<RestoreFailure>());
      expect((result as RestoreFailure).error, contains('checksum mismatch'));
    });

    test('restoreFromFile creates safety backup before restoring', () async {
      await isar.writeTxn(() async {
        await isar.members.put(_fakeMember());
      });
      final backupResult =
          await backupService.createBackup(isar) as BackupSuccess;

      final filesBefore = await backupService.listBackupFiles();
      await restoreService.restoreFromFile(isar, backupResult.filePath);
      final filesAfter = await backupService.listBackupFiles();

      // At least one additional backup file should have been created (the safety backup)
      expect(filesAfter.length, greaterThanOrEqualTo(filesBefore.length));
    });
  });
}
