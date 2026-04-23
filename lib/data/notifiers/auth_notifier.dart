import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/security/pin_service.dart';
import '../../core/services/hmac_service.dart';
import '../models/owner_profile.dart';
import '../models/app_settings.dart';
import '../repositories/settings_repository.dart';
import '../../core/providers/security_providers.dart';

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

class AuthNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage _storage;
  final PinService _pinService;
  final IsarSettingsRepository _settingsRepo;
  final HmacService _hmacService;

  AuthNotifier(this._storage, this._pinService, this._settingsRepo, this._hmacService)
      : super(AuthState(settings: AppSettings())) {
    _init();
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
  }

  Future<void> completeOnboarding() async {
    await _storage.write(key: 'onboarding_done', value: 'true');
    state = state.copyWith(isFirstLaunch: false);
  }

  Future<bool> authenticate({String? pin}) async {
    final result = await _pinService.authenticate(pinFallback: pin);
    if (result == AuthResult.success) {
      state = state.copyWith(unlocked: true, authAttempts: 0);
      return true;
    }
    state = state.copyWith(authAttempts: state.authAttempts + 1);
    return false;
  }

  Future<bool> login(String email, String password) async {
    // Mock login for now, matching version0 behavior
    if (email.isNotEmpty && password.length >= 6) {
      state = state.copyWith(isAuthenticated: true, authAttempts: 0);
      return true;
    }
    return false;
  }

  Future<bool> signUp(String email, String password, {
    required String gymName,
    required String ownerName,
    String? phone,
  }) async {
    // Mock signup
    final owner = OwnerProfile(
      gymName: gymName,
      ownerName: ownerName,
      phone: phone ?? '',
    );
    await saveOwner(owner);
    return true;
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
    // In a real app, save to secure storage/settings
    await _storage.write(key: 'biometric_opt_in', value: optedIn.toString());
  }

  Future<void> sendPasswordReset(String email) async {
    // Mock password reset
    await Future.delayed(const Duration(seconds: 1));
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final storage = ref.watch(appSecureStorageProvider);
  final pinService = ref.watch(pinServiceProvider);
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  final hmac = ref.watch(hmacServiceProvider);
  return AuthNotifier(storage, pinService, settingsRepo, hmac);
});
