import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/member.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../viewmodel/members_viewmodel.dart';

// 🔒 LOCKED SCREEN — MemberDetailScreen
class MemberDetailScreen extends ConsumerWidget {
  final int memberId;
  const MemberDetailScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(membersViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('Member Detail'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left, size: 28),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
        ],
      ),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.orange)),
        error: (err, stack) => Center(child: Text(err.toString())),
        data: (members) {
          // Find member by ID
          Member? member;
          try {
            member = members.firstWhere((m) => m.id == memberId);
          } catch (_) {
            member = members.isNotEmpty ? members.first : null;
          }
          
          if (member == null) {
            return const Center(child: Text('Member not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(member),
                const SizedBox(height: 32),
                _buildInfoCard('Contact Information', [
                  _buildInfoRow('Phone', member.phone, Icons.phone_outlined),
                  _buildInfoRow('WhatsApp', member.phone, Icons.chat_outlined),
                ]),
                const SizedBox(height: 16),
                _buildInfoCard('Plan Details', [
                  _buildInfoRow('Current Plan', member.planName, Icons.fitness_center_outlined),
                  _buildInfoRow('Join Date', _formatDate(member.joinDate), Icons.calendar_today_outlined),
                  _buildInfoRow('Expiry Date', _formatDate(member.expiryDate), Icons.event_available_outlined),
                ]),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton('Mark Attendance', Icons.fact_check_outlined, AppColors.blue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton('Record Payment', Icons.currency_rupee, AppColors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.red.withOpacity(0.1), foregroundColor: AppColors.red),
                  child: const Text('Delete Member'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(dynamic member) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.bgCard,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, size: 40, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(member.name, style: AppTextStyles.h1),
          const SizedBox(height: 4),
          _buildStatusBadge(member.isActive),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (isActive ? AppColors.green : AppColors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'EXPIRED',
        style: AppTextStyles.caption.copyWith(color: isActive ? AppColors.green : AppColors.red),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.orange)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.label),
          const Spacer(),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.label.copyWith(color: color, fontSize: 10)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}
