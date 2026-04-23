import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_viewmodel.g.dart';

@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  @override
  Future<void> build() async {
    // Initialize settings from SharedPreferences if needed
  }

  Future<void> clearAllData() async {
    // Implementation for factory reset if requested
  }
}
