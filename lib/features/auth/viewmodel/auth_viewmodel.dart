import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/security/pin_service.dart';
import '../../../data/models/owner_profile.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../core/providers/security_providers.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/providers/backup_provider.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';


class AuthState {
  final bool isLoading;
  final bool isFirstLaunch;
  final bool isAuthenticated;
  final OwnerProfile? owner;
  final AppSettings settings;
  final bool isPinSetup;
  final bool unlocked;
  final int authAttempts;

  AuthState({
    this.isLoading = true,
    this.isFirstLaunch = true,
    this.isAuthenticated = false,
    this.owner,
    required this.settings,
    this.isPinSetup = false,
    this.unlocked = false,
    this.authAttempts = 0,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isFirstLaunch,
    bool? isAuthenticated,
    OwnerProfile? owner,
    AppSettings? settings,
    bool? isPinSetup,
    bool? unlocked,
    int? authAttempts,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      owner: owner ?? this.owner,
      settings: settings ?? this.settings,
      isPinSetup: isPinSetup ?? this.isPinSetup,
      unlocked: unlocked ?? this.unlocked,
      authAttempts: authAttempts ?? this.authAttempts,
    );
  }
}

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late FlutterSecureStorage _storage;
  late PinService _pinService;
  late ISettingsRepository _settingsRepo;
  late BackupService _backupService;
  Isar? _isar;

  @override
  AuthState build() {
    _storage = ref.watch(appSecureStorageProvider);
    _pinService = ref.watch(pinServiceProvider);
    _settingsRepo = ref.watch(settingsRepositoryProvider);
    _backupService = ref.watch(backupServiceProvider);
    _isar = ref.watch(isarProvider);

    _init();
    return AuthState(settings: AppSettings());
  }

  Future<void> _init() async {
    final pinHash = await _storage.read(key: 'pin_hash');
    final pinSalt = await _storage.read(key: 'pin_salt');
    final onboardingDone = await _storage.read(key: 'onboarding_done');
    
    bool isPinSetup = pinHash != null && pinSalt != null;
    
    final owner = await _settingsRepo.getOwner();
    final settings = await _settingsRepo.getSettings();

    state = state.copyWith(
      isPinSetup: isPinSetup,
      isFirstLaunch: onboardingDone != 'true',
      isAuthenticated: owner != null,
      owner: owner,
      settings: settings,
      isLoading: false,
    );

    if (_isar != null && state.unlocked) {
      NotificationService.checkAndNotifyExpiring(_isar!);
      _backupService.autoBackupIfDue(_isar!);
    }
  }

  Future<void> completeOnboarding() async {
    await _storage.write(key: 'onboarding_done', value: 'true');
    state = state.copyWith(isFirstLaunch: false);
  }

  Future<bool> authenticate({String? pin}) async {
    final result = await _pinService.authenticate(pinFallback: pin);
    if (result == AuthResult.success) {
      state = state.copyWith(unlocked: true, authAttempts: 0);
      if (_isar != null) {
        NotificationService.checkAndNotifyExpiring(_isar!);
        _backupService.autoBackupIfDue(_isar!);
      }
      return true;
    }

    state = state.copyWith(authAttempts: state.authAttempts + 1);
    return false;
  }

  Future<bool> verifyPin(String pin) => authenticate(pin: pin);

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final savedEmail = await _storage.read(key: 'auth_email');
      final savedPassword = await _storage.read(key: 'auth_password');
      if (email == savedEmail && password == savedPassword) {
        state = state.copyWith(
          isAuthenticated: true,
          authAttempts: 0,
          isLoading: false,
        );
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<bool> signUp(String email, String password, {
    required String gymName,
    required String ownerName,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await _storage.write(key: 'auth_email', value: email);
      await _storage.write(key: 'auth_password', value: password);
      
      final owner = OwnerProfile(
        gymName: gymName,
        ownerName: ownerName,
        phone: phone ?? '',
      );
      await saveOwner(owner);
      return true;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _settingsRepo.clearAll();
    await _storage.deleteAll();
    state = AuthState(
      isAuthenticated: false,
      unlocked: false,
      isPinSetup: false,
      isFirstLaunch: true,
      isLoading: false,
      settings: AppSettings(),
    );
  }

  Future<void> setPin(String pin) async {
    await _pinService.setPin(pin);
    state = state.copyWith(isPinSetup: true, unlocked: true);
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _settingsRepo.saveSettings(settings);
    state = state.copyWith(settings: settings);
  }

  Future<void> saveOwner(OwnerProfile owner) async {
    await _settingsRepo.saveOwner(owner);
    state = state.copyWith(owner: owner, isAuthenticated: true);
  }

  Future<void> logout() => signOut();

  Future<void> setBiometricOptIn(bool optedIn) async {
    await _storage.write(key: 'biometric_opt_in', value: optedIn.toString());
  }

  Future<void> sendPasswordReset(String email) async {
    state = state.copyWith(isLoading: true);
    // Mocking email behavior with a delay
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
  }
}

// Keep the old provider name for compatibility but refactor it to use the new notifier
final authProvider = authViewModelProvider;

