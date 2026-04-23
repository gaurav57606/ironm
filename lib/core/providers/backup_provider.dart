import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/backup_service.dart';
import '../services/restore_service.dart';
import 'database_provider.dart';

part 'backup_provider.g.dart';

@riverpod
BackupService backupService(BackupServiceRef ref) {
  return BackupService();
}

@riverpod
RestoreService restoreService(RestoreServiceRef ref) {
  return RestoreService();
}

@riverpod
class BackupViewModel extends _$BackupViewModel {
  @override
  FutureOr<void> build() async {}

  Future<BackupResult> createBackup() async {
    state = const AsyncValue.loading();
    try {
      final isar = ref.read(isarProvider);
      if (isar == null) throw Exception('Database not initialized');
      final result = await ref.read(backupServiceProvider).createBackup(isar);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return BackupFailure(e.toString());
    }
  }

  Future<RestoreResult> restoreFromFile(String filePath) async {
    state = const AsyncValue.loading();
    try {
      final isar = ref.read(isarProvider);
      if (isar == null) throw Exception('Database not initialized');
      final result = await ref.read(restoreServiceProvider).restoreFromFile(isar, filePath);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return RestoreFailure(e.toString());
    }
  }
}
