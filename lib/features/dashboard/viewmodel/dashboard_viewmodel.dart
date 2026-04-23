import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/repositories/payment_repository.dart';

part 'dashboard_viewmodel.g.dart';

class DashboardState {
  final int totalMembers;
  final int activeMembers;
  final int expiringSoon;
  final double monthlyRevenue;

  const DashboardState({
    required this.totalMembers,
    required this.activeMembers,
    required this.expiringSoon,
    required this.monthlyRevenue,
  });
}

@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  Future<DashboardState> build() async {
    final memberRepo = ref.watch(memberRepositoryProvider);
    final paymentRepo = ref.watch(paymentRepositoryProvider);

    final members = await memberRepo.getAllMembers();
    final payments = await paymentRepo.getAllPayments();

    final active = members.where((m) => m.isActive).length;
    final expiring = members.where((m) => m.daysLeft >= 0 && m.daysLeft <= 7).length;
    
    // Revenue for current month
    final now = DateTime.now();
    final monthlyRev = payments
        .where((p) => p.paymentDate.month == now.month && p.paymentDate.year == now.year)
        .fold(0.0, (sum, p) => sum + p.amount);

    return DashboardState(
      totalMembers: members.length,
      activeMembers: active,
      expiringSoon: expiring,
      monthlyRevenue: monthlyRev,
    );
  }
}
