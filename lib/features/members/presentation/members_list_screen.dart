import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../viewmodel/members_viewmodel.dart';
import '../../../shared/widgets/error_view.dart';

// 🔒 LOCKED SCREEN — MembersListScreen
class MembersListScreen extends ConsumerWidget {
  const MembersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(membersViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('Directory'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: membersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.orange)),
              error: (err, stack) => ErrorView(
                message: 'Failed to load members',
                onRetry: () => ref.invalidate(membersViewModelProvider),
              ),
              data: (members) => ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: members.isEmpty ? 5 : members.length, // Show mock if empty for visual demo
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) {
                  if (members.isEmpty) return _buildMockMemberTile(i);
                  return _buildMemberTile(context, members[i]);
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/members/add'),
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildFilterTabs() {
    final tabs = ['All', 'Active', 'Expiring', 'Expired'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == 'All';
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.orange : AppColors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: isSelected ? null : Border.all(color: AppColors.border),
            ),
            child: Text(
              tab,
              style: AppTextStyles.label.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMemberTile(BuildContext context, dynamic member) {
    return GestureDetector(
      onTap: () => context.go('/members/${member.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.bgAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: AppTextStyles.title),
                  const SizedBox(height: 2),
                  Text(member.planName, style: AppTextStyles.subtext),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Exp: ${_formatDate(member.expiryDate)}',
                  style: AppTextStyles.subtext,
                ),
                const SizedBox(height: 4),
                _buildStatusTag(member.isActive),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockMemberTile(int i) {
    final names = ['Suresh Raina', 'Mahendra Singh', 'Virat Kohli', 'Rohit Sharma', 'Hardik Pandya'];
    final plans = ['3 Months', '12 Months', 'Monthly', '6 Months', 'Monthly'];
    final status = [true, true, false, true, false];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.bgAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(names[i % names.length], style: AppTextStyles.title),
                const SizedBox(height: 2),
                Text(plans[i % plans.length], style: AppTextStyles.subtext),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Exp: 12 May 2024', style: AppTextStyles.subtext),
              const SizedBox(height: 4),
              _buildStatusTag(status[i % status.length]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? AppColors.green : AppColors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'ACTIVE' : 'EXPIRED',
        style: AppTextStyles.caption.copyWith(
          color: isActive ? AppColors.green : AppColors.red,
          fontSize: 8,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple format for demo
    return '${date.day} ${_getMonth(date.month)} ${date.year}';
  }

  String _getMonth(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/dashboard'); break;
            case 1: context.go('/members'); break;
            case 2: context.go('/payments'); break;
            case 3: context.go('/attendance'); break;
            case 4: context.go('/settings'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Members'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
