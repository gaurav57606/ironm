import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthResult { success, failure, canceled }

final pinServiceProvider = Provider<PinService>((ref) {
  return PinService(const FlutterSecureStorage());
});

class PinService {
  final FlutterSecureStorage _storage;
  
  static const _pinHashKey = 'pin_hash';
  static const _pinSaltKey = 'pin_salt';
  static const _failCountKey = 'pin_fail_count';
  static const _lockoutUntilKey = 'pin_lockout_until';
  
  final _localAuth = LocalAuthentication();

  PinService(this._storage);

  Future<void> savePin(String pin) async {
    final salt = base64Encode(List.generate(16, (_) => Random.secure().nextInt(256)));
    final hash = _hashWithSalt(pin, salt, iterations: 100000);
    // Prefix with v2| to indicate hardened hashing
    await _storage.write(key: _pinHashKey, value: 'v2|$hash');
    await _storage.write(key: _pinSaltKey, value: salt);
    await _storage.delete(key: _failCountKey);
    await _storage.delete(key: _lockoutUntilKey);
  }

  String _hashWithSalt(String input, String salt, {int iterations = 100000}) {
    var hash = sha256.convert(utf8.encode(input + salt)).toString();
    // Hardened work factor: 100,000 rounds of SHA-256
    for (int i = 0; i < iterations; i++) {
      hash = sha256.convert(utf8.encode(hash + salt)).toString();
    }
    return hash;
  }

  Future<bool> verifyPin(String input) async {
    // 1. Check Lockout
    final lockoutUntilRaw = await _storage.read(key: _lockoutUntilKey);
    if (lockoutUntilRaw != null) {
      final lockoutUntil = DateTime.tryParse(lockoutUntilRaw);
      if (lockoutUntil != null && lockoutUntil.isAfter(DateTime.now())) {
        return false; // Still locked out
      }
    }

    final stored = await _storage.read(key: _pinHashKey);
    final salt = await _storage.read(key: _pinSaltKey);
    
    if (stored == null || salt == null) return false;
    
    bool isCorrect = false;
    if (stored.startsWith('v2|')) {
      final actualHash = stored.substring(3);
      final inputHash = _hashWithSalt(input, salt, iterations: 100000);
      isCorrect = inputHash == actualHash;
    } else {
      // Legacy v1 fallback (if any)
      final inputHash = _hashWithSalt(input, salt, iterations: 1000);
      isCorrect = inputHash == stored;
      if (isCorrect) await savePin(input); // Auto-migrate
    }

    if (isCorrect) {
      await _storage.delete(key: _failCountKey);
      await _storage.delete(key: _lockoutUntilKey);
      return true;
    } else {
      final countRaw = await _storage.read(key: _failCountKey);
      final count = (int.tryParse(countRaw ?? '0') ?? 0) + 1;
      await _storage.write(key: _failCountKey, value: count.toString());

      if (count >= 10) {
        // Severe failure: Wipe security tokens
        await _storage.delete(key: _pinHashKey);
        await _storage.delete(key: _failCountKey);
        await _storage.delete(key: _lockoutUntilKey);
        return false;
      }

      if (count >= 5) {
        final lockoutTime = DateTime.now().add(const Duration(seconds: 30));
        await _storage.write(key: _lockoutUntilKey, value: lockoutTime.toIso8601String());
      }
      return false;
    }
  }

  Future<bool> hasPin() async {
    return await _storage.containsKey(key: _pinHashKey);
  }

  Future<AuthResult> authenticateWithBiometric() async {
    try {
      if (kIsWeb) return AuthResult.failure;
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      if (!canCheck || !isSupported) return AuthResult.failure;

      final success = await _localAuth.authenticate(
        localizedReason: 'Verify your identity to open IronBook GM',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return success ? AuthResult.success : AuthResult.canceled;
    } catch (e) {
      debugPrint('PinService: Biometric Auth Error: $e');
      return AuthResult.failure;
    }
  }
  Future<void> setPin(String pin) => savePin(pin);

  Future<AuthResult> authenticate({String? pinFallback}) async {
    final bioResult = await authenticateWithBiometric();
    if (bioResult == AuthResult.success) return AuthResult.success;
    
    if (pinFallback != null) {
      final pinResult = await verifyPin(pinFallback);
      return pinResult ? AuthResult.success : AuthResult.failure;
    }
    
    return bioResult;
  }
}
