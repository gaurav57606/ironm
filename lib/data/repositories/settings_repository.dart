import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/hmac_service.dart';
import '../models/owner_profile.dart';
import '../models/app_settings.dart';

class IsarSettingsRepository {
  final Isar? _isar;
  final HmacService _hmacService;

  IsarSettingsRepository(this._isar, this._hmacService);

  Future<OwnerProfile?> getOwner() async {
    if (_isar == null) return null;
    final owner = await _isar!.ownerProfiles.where().findFirst();
    if (owner != null && await _hmacService.verifyInstance(owner)) {
      return owner;
    }
    return null;
  }

  Future<void> saveOwner(OwnerProfile owner) async {
    if (_isar == null) return;
    owner.hmacSignature = await _hmacService.signSnapshot(owner);
    await _isar!.writeTxn(() async {
      await _isar!.ownerProfiles.put(owner);
    });
  }

  Future<AppSettings> getSettings() async {
    if (_isar == null) return AppSettings();
    final settings = await _isar!.appSettings.where().findFirst();
    return settings ?? AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.appSettings.put(settings);
    });
  }

  Future<void> clearAll() async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.clear();
    });
  }
}

final settingsRepositoryProvider = Provider<IsarSettingsRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final hmac = ref.watch(hmacServiceProvider);
  return IsarSettingsRepository(isar, hmac);
});
