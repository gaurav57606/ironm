import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ironm/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:ironm/core/providers/security_providers.dart';
import 'package:ironm/core/providers/database_provider.dart';
import 'package:ironm/core/providers/backup_provider.dart';
import 'package:ironm/core/security/pin_service.dart';
import 'package:ironm/data/repositories/settings_repository.dart';
import 'dart:io' as io;
import 'package:isar/isar.dart';
import 'package:ironm/core/services/backup_service.dart';
import 'package:ironm/data/models/owner_profile.dart';
import 'package:ironm/data/models/app_settings.dart';
import 'package:mocktail/mocktail.dart';

class FakeSecureStorage extends Mock implements FlutterSecureStorage {
  final Map<String, String> _data = {};
  
  @override
  Future<void> write({required String key, required String? value, 
      IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, 
      WebOptions? webOptions, MacOsOptions? mOptions, WindowsOptions? wOptions}) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  }
  
  @override
  Future<String?> read({required String key, 
      IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, 
      WebOptions? webOptions, MacOsOptions? mOptions, WindowsOptions? wOptions}) async {
    return _data[key];
  }
  
  @override
  Future<void> delete({required String key, 
      IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, 
      WebOptions? webOptions, MacOsOptions? mOptions, WindowsOptions? wOptions}) async {
    _data.remove(key);
  }
  
  @override
  Future<void> deleteAll({
      IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, 
      WebOptions? webOptions, MacOsOptions? mOptions, WindowsOptions? wOptions}) async {
    _data.clear();
  }

  @override
  Future<bool> containsKey({required String key, 
      IOSOptions? iOptions, AndroidOptions? aOptions, LinuxOptions? lOptions, 
      WebOptions? webOptions, MacOsOptions? mOptions, WindowsOptions? wOptions}) async {
    return _data.containsKey(key);
  }
}

class FakePinService implements PinService {
  @override
  dynamic get _storage => null;
  @override
  dynamic get _localAuth => null;

  String? _savedPin;
  bool _unlocked = false;

  @override
  Future<void> setPin(String pin) async => _savedPin = pin;
  @override
  Future<void> savePin(String pin) async => _savedPin = pin;
  @override
  Future<bool> verifyPin(String pin) async => pin == _savedPin;
  @override
  Future<bool> hasPin() async => _savedPin != null;
  @override
  Future<AuthResult> authenticate({String? pinFallback}) async {
    if (pinFallback == _savedPin) {
      _unlocked = true;
      return AuthResult.success;
    }
    return AuthResult.failure;
  }
  @override
  Future<AuthResult> authenticateWithBiometric() async => AuthResult.failure;
  @override
  String _hashWithSalt(String input, String salt, {int iterations = 100000}) => '';
}

class FakeSettingsRepository implements IsarSettingsRepository {
  @override
  dynamic get _isar => null;
  @override
  dynamic get _hmacService => null;

  OwnerProfile? _owner;
  AppSettings _settings = AppSettings();

  @override
  Future<OwnerProfile?> getOwner() async => _owner;
  @override
  Future<void> saveOwner(OwnerProfile owner) async => _owner = owner;
  @override
  Future<AppSettings> getSettings() async => _settings;
  @override
  Future<void> saveSettings(AppSettings settings) async => _settings = settings;
  @override
  Future<void> clearAll() async {
    _owner = null;
    _settings = AppSettings();
  }
}

class FakeBackupService implements BackupService {
  @override
  Future<void> autoBackupIfDue(Isar isar) async {}
  @override
  Future<BackupResult> createBackup(Isar isar) async => BackupFailure('Not implemented');
  @override
  Future<String?> getBackupDirectory() async => null;
  @override
  Future<List<io.File>> listBackupFiles() async => [];
}

void main() {
  late ProviderContainer container;
  late FakeSecureStorage fakeStorage;
  late FakePinService fakePinService;
  late FakeSettingsRepository fakeSettingsRepo;
  late FakeBackupService fakeBackupService;

  setUp(() {
    fakeStorage = FakeSecureStorage();
    fakePinService = FakePinService();
    fakeSettingsRepo = FakeSettingsRepository();
    fakeBackupService = FakeBackupService();

    container = ProviderContainer(
      overrides: [
        appSecureStorageProvider.overrideWith((ref) => fakeStorage),
        pinServiceProvider.overrideWithValue(fakePinService),
        settingsRepositoryProvider.overrideWithValue(fakeSettingsRepo),
        isarProvider.overrideWithValue(null),
        backupServiceProvider.overrideWithValue(fakeBackupService),
      ],
    );
    // Keep authProvider alive during the test to prevent repeated build() calls
    container.listen(authProvider, (_, __) {});
  });

  group('Auth Provider Tests', () {
    test('Initial state: isFirstLaunch=true when no storage', () async {
      // The _init is called in build(), so it runs immediately.
      // Wait for it to finish.
      while (container.read(authProvider).isLoading) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      final state = container.read(authProvider);
      expect(state.isFirstLaunch, true);
      expect(state.isLoading, false);
    });

    test('After completeOnboarding() → isFirstLaunch=false', () async {
      while (container.read(authProvider).isLoading) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      await container.read(authProvider.notifier).completeOnboarding();
      final state = container.read(authProvider);
      expect(state.isFirstLaunch, false);
    });

    test('After setPin("1234") → isPinSetup=true, unlocked=true', () async {
      while (container.read(authProvider).isLoading) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      await container.read(authProvider.notifier).setPin('1234');
      final state = container.read(authProvider);
      expect(state.isPinSetup, true);
      expect(state.unlocked, true);
    });

    test('signOut() clears everything', () async {
      while (container.read(authProvider).isLoading) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      fakeSettingsRepo._owner = OwnerProfile(gymName: 'G', ownerName: 'O', phone: 'P');
      fakePinService._savedPin = '1234';
      
      await container.read(authProvider.notifier).signOut();
      
      final state = container.read(authProvider);
      expect(state.isAuthenticated, false);
      expect(state.isPinSetup, false);
      expect(state.owner, isNull);
    });
  });
}
