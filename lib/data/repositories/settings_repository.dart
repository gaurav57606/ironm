import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/hmac_service.dart';
import '../models/owner_profile.dart';
import '../models/app_settings.dart';
// import 'web/web_settings_repository.dart';
// import '../../core/providers/web_data_store.dart';

abstract class ISettingsRepository {
  Future<OwnerProfile?> getOwner();
  Future<void> saveOwner(OwnerProfile owner);
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<void> clearAll();
}

class IsarSettingsRepository implements ISettingsRepository {
  final Isar? _isar;
  final HmacService _hmacService;

  IsarSettingsRepository(this._isar, this._hmacService);

  @override
  Future<OwnerProfile?> getOwner() async {
    if (_isar == null) return null;
    final owner = await _isar.ownerProfiles.where().findFirst();
    if (owner != null && await _hmacService.verifyInstance(owner)) {
      return owner;
    }
    return null;
  }

  @override
  Future<void> saveOwner(OwnerProfile owner) async {
    if (_isar == null) return;
    owner.hmacSignature = await _hmacService.signSnapshot(owner);
    await _isar.writeTxn(() async {
      await _isar.ownerProfiles.put(owner);
    });
  }

  @override
  Future<AppSettings> getSettings() async {
    if (_isar == null) return AppSettings();
    final settings = await _isar.appSettings.where().findFirst();
    return settings ?? AppSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    if (_isar == null) return;
    await _isar.writeTxn(() async {
      await _isar.appSettings.put(settings);
    });
  }

  @override
  Future<void> clearAll() async {
    if (_isar == null) return;
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }
}


final settingsRepositoryProvider = Provider<ISettingsRepository>((ref) {
  final isar = ref.watch(isarProvider);
  if (isar == null) {
    final webStore = ref.watch(webDataStoreProvider);
    if (webStore != null) {
      // return WebSettingsRepository(webStore);
    }
  }
  final hmac = ref.watch(hmacServiceProvider);
  return IsarSettingsRepository(isar, hmac);
});
