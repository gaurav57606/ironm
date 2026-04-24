// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backupServiceHash() => r'6562bd786fe8d1ffd05f248b3e2fad816221030f';

/// See also [backupService].
@ProviderFor(backupService)
final backupServiceProvider = AutoDisposeProvider<BackupService>.internal(
  backupService,
  name: r'backupServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BackupServiceRef = AutoDisposeProviderRef<BackupService>;
String _$restoreServiceHash() => r'48bbd521c176d964b6fea20020db708caa05d027';

/// See also [restoreService].
@ProviderFor(restoreService)
final restoreServiceProvider = AutoDisposeProvider<RestoreService>.internal(
  restoreService,
  name: r'restoreServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$restoreServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RestoreServiceRef = AutoDisposeProviderRef<RestoreService>;
String _$backupViewModelHash() => r'ceca89beea7348e0e6d2349dad844372d0fba0bc';

/// See also [BackupViewModel].
@ProviderFor(BackupViewModel)
final backupViewModelProvider =
    AutoDisposeAsyncNotifierProvider<BackupViewModel, void>.internal(
  BackupViewModel.new,
  name: r'backupViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackupViewModel = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
