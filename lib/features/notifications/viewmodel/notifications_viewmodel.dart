import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/providers/database_provider.dart';
import '../../../data/models/member.dart';

class ExpiryAlert {
  final Member member;
  final int daysUntilExpiry;

  ExpiryAlert({required this.member, required this.daysUntilExpiry});
  bool get isExpired => daysUntilExpiry < 0;
}

final expiringMembersProvider = StreamProvider.autoDispose<List<ExpiryAlert>>((ref) async* {
  final isar = ref.watch(isarProvider);
  if (isar == null) {
    yield [];
    return;
  }

  // Watch for changes in members collection
  yield* isar.members.where()
      .filter()
      .archivedEqualTo(false)
      .watch(fireImmediately: true)
      .map((members) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final alerts = <ExpiryAlert>[];
    for (final member in members) {
      if (member.expiryDate == null) continue;
      
      final expiry = DateTime(member.expiryDate!.year, member.expiryDate!.month, member.expiryDate!.day);
      final daysUntil = expiry.difference(today).inDays;

      if (daysUntil <= 30) {
        alerts.add(ExpiryAlert(member: member, daysUntilExpiry: daysUntil));
      }
    }

    // Sort by daysUntilExpiry ascending (most urgent first)
    alerts.sort((a, b) => a.daysUntilExpiry.compareTo(b.daysUntilExpiry));
    return alerts;
  });
});
