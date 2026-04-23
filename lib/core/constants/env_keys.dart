// All sensitive values are stored in flutter_secure_storage, NOT in .env or hardcoded.
// On first app launch (onboarding), values are set by the owner.
// Never hardcode secrets in this file.
class EnvKeys {
  EnvKeys._();
  static const String ownerPinKey = 'owner_pin_hash';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String gymNameKey = 'gym_name';
  static const String lastBackupKey = 'last_backup_timestamp';
}
