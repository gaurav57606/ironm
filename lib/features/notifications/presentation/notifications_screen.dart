import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/notifications_viewmodel.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(expiringMembersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        title: const Text('Alerts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: alertsAsync.when(
        data: (alerts) {
          if (alerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green.withValues(alpha: 0.5), size: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'All memberships are active',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Members expiring in the next 30 days\nwill appear here',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              return ExpiryAlertCard(alert: alerts[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}

class ExpiryAlertCard extends StatelessWidget {
  final ExpiryAlert alert;

  const ExpiryAlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final member = alert.member;
    final days = alert.daysUntilExpiry;

    Color badgeColor;
    String statusText;

    if (days < 0) {
      badgeColor = const Color(0xFFe94560); // Red
      statusText = 'Expired';
    } else if (days <= 3) {
      badgeColor = Colors.orange;
      statusText = '$days days left';
    } else if (days <= 7) {
      badgeColor = Colors.yellow[700]!;
      statusText = '$days days left';
    } else {
      badgeColor = Colors.green;
      statusText = '$days days left';
    }

    return Card(
      color: const Color(0xFF16213e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () => context.push('/members/${member.memberId}'),
        title: Text(
          member.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              member.phone ?? 'No phone',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Expires: ${member.expiryDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeColor, width: 1),
          ),
          child: Text(
            statusText,
            style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
