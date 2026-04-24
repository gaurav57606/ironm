import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar_wrapper.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(expiringMembersProvider);

    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: alertsAsync.when(
                  data: (alerts) {
                    if (alerts.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      itemCount: alerts.length,
                      itemBuilder: (context, index) => ExpiryAlertCard(alert: alerts[index]),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.orange)),
                  error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.expired))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.bg3,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.border),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.chevron_left, size: 16, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 12),
          Text('Alerts', style: AppTextStyles.h2.copyWith(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: AppColors.active.withValues(alpha: 0.5), size: 64),
          const SizedBox(height: 16),
          Text('All memberships active', style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text('Expirations will appear here', style: AppTextStyles.label.copyWith(color: AppColors.textMuted)),
        ],
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

    Color statusColor;
    String statusText;

    if (days < 0) {
      statusColor = AppColors.expired;
      statusText = 'Expired';
    } else if (days <= 3) {
      statusColor = AppColors.orange;
      statusText = '$days days left';
    } else {
      statusColor = AppColors.active;
      statusText = '$days days left';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () => context.push('/members/${member.id}'),
        title: Text(member.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(member.phone ?? 'No phone', style: AppTextStyles.label.copyWith(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor.withValues(alpha: 0.3)),
          ),
          child: Text(statusText, style: AppTextStyles.label.copyWith(color: statusColor, fontSize: 9, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
