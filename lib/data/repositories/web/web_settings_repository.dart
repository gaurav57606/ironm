import '../../../core/providers/web_data_store.dart';
import '../../models/owner_profile.dart';
import '../../models/app_settings.dart';
import '../settings_repository.dart';

class WebSettingsRepository implements ISettingsRepository {
  final WebDataStore _store;
  static const String _collection = 'settings';
  static const String _ownerKey = 'owner_profile';
  static const String _settingsKey = 'app_settings';

  WebSettingsRepository(this._store);

  @override
  Future<OwnerProfile?> getOwner() async {
    final data = await _store.get(_collection, _ownerKey);
    if (data == null) return null;
    return OwnerProfile.fromJson(data);
  }

  @override
  Future<void> saveOwner(OwnerProfile owner) async {
    await _store.save(_collection, _ownerKey, owner.toJson());
  }

  @override
  Future<AppSettings> getSettings() async {
    final data = await _store.get(_collection, _settingsKey);
    if (data == null) return AppSettings();
    return AppSettings.fromJson(data);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _store.save(_collection, _settingsKey, settings.toJson());
  }

  @override
  Future<void> clearAll() async {
    await _store.clear();
  }
}
