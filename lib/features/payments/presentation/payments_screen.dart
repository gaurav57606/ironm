import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../viewmodel/payments_viewmodel.dart';
import '../../members/viewmodel/members_viewmodel.dart';
import '../../../data/models/payment.dart';
import '../../../data/models/member.dart';

// 🔒 LOCKED SCREEN — PaymentsScreen
class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentsStreamProvider).value ?? [];
    final members = ref.watch(membersProvider);

    final now = DateTime.now();
    final mtdPayments = payments.where((p) => 
      p.date.month == now.month && p.date.year == now.year
    ).toList();
    
    final totalRevenue = mtdPayments.fold(0.0, (sum, p) => sum + p.amount);
    
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Payments'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(totalRevenue, mtdPayments),
          Expanded(
            child: mtdPayments.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    itemCount: mtdPayments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final payment = mtdPayments[i];
                      final member = members.where((m) => m.memberId == payment.memberId).firstOrNull;
                      return _buildPaymentTile(context, payment, member);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/gym/add-member'),
        backgroundColor: AppColors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSummaryCard(double total, List<Payment> mtdPayments) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.orange, AppColors.orangeD],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Revenue (MTD)', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          Text(formatter.format(total), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMiniStat('Payments', mtdPayments.length.toString()),
              const SizedBox(width: 24),
              _buildMiniStat('Collected', formatter.format(total)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_rounded, size: 48, color: AppColors.textMuted.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('No transactions this month', style: AppTextStyles.label.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildPaymentTile(BuildContext context, Payment payment, Member? member) {
    return InkWell(
      onTap: () => context.push('/gym/member-details/${payment.memberId}/invoice', extra: payment),
      borderRadius: BorderRadius.circular(14),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.active.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.call_received, color: AppColors.active, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member?.name ?? 'Unknown Member', style: AppTextStyles.title),
                  Text('${payment.method} · ${payment.planName}', style: AppTextStyles.subtext),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${payment.amount.toInt()}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                Text(DateFormat('dd MMM').format(payment.date), style: AppTextStyles.subtext),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0: context.go('/dashboard'); break;
            case 1: context.go('/gym'); break;
            case 2: context.go('/pos'); break; // Map to POS for now as per router
            case 3: context.go('/attendance'); break;
            case 4: context.go('/settings'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Members'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'POS'),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}


