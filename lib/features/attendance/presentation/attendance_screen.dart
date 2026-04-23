import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar_wrapper.dart';
import '../viewmodel/attendance_viewmodel.dart';
import '../../members/viewmodel/members_viewmodel.dart';
import '../../../data/models/attendance.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendance = ref.watch(attendanceProvider);
    final members = ref.watch(membersProvider);

    return Container(
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StatusBarWrapper(
          child: Column(
            children: [
              _buildAppBar(context),
              _buildDateSelector(),
              Expanded(
                child: attendance.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        itemCount: attendance.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (ctx, i) {
                          final record = attendance[i];
                          final member = members.firstWhereOrNull(
                              (m) => m.memberId == record.memberId);
                          return _buildAttendanceTile(record, member);
                        },
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
          _buildIconButton(Icons.chevron_left, () => context.pop()),
          const SizedBox(width: 12),
          Text('Attendance', style: AppTextStyles.h2.copyWith(fontSize: 20)),
          const Spacer(),
          _buildIconButton(Icons.calendar_month_rounded, () {}),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.bg3,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final isSelected = index == 3; // Mocking today
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.orange : AppColors.bg3,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: isSelected ? AppColors.orange : AppColors.border),
            ),
            child: Column(
              children: [
                Text(
                  ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${9 + index}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fact_check_rounded,
              size: 48, color: AppColors.textMuted.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text('No attendance records found',
              style: AppTextStyles.label.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildAttendanceTile(Attendance record, dynamic member) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              (member?.name ?? '?').substring(0, 1).toUpperCase(),
              style: const TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member?.name ?? 'Unknown Member',
                    style: AppTextStyles.body
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
                Text(
                  'Checked in at 06:42 AM', // Mocking check in time
                  style: AppTextStyles.label
                      .copyWith(fontSize: 9, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          _buildStatusPill('PRESENT', AppColors.active),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}

