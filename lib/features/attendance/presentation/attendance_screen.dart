import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_bar_wrapper.dart';
import '../viewmodel/attendance_viewmodel.dart';
import '../../members/viewmodel/members_viewmodel.dart';
import '../../../data/models/attendance.dart';
import '../../../data/models/member.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final attendance = ref.watch(attendanceProvider);
    final members = ref.watch(membersProvider);

    // Filter attendance for the selected date
    final filteredAttendance = attendance.where((a) {
      return a.checkInTime.year == _selectedDate.year &&
          a.checkInTime.month == _selectedDate.month &&
          a.checkInTime.day == _selectedDate.day;
    }).toList();

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
                child: filteredAttendance.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        itemCount: filteredAttendance.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (ctx, i) {
                          final record = filteredAttendance[i];
                          final member = members.firstWhereOrNull(
                              (m) => m.memberId == record.memberId);
                          return _buildAttendanceTile(record, member);
                        },
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCheckInSheet(context, members),
          backgroundColor: AppColors.orange,
          child: const Icon(Icons.add_task_rounded, color: Colors.white),
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
          _buildIconButton(Icons.calendar_month_rounded, () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2024),
              lastDate: DateTime(2026),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          }),
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
          final date = DateTime.now().subtract(Duration(days: 6 - index));
          final isSelected = date.day == _selectedDate.day &&
                             date.month == _selectedDate.month &&
                             date.year == _selectedDate.year;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
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
                    DateFormat('E').format(date).substring(0, 1),
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
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
          Text('No records for ${DateFormat('dd MMM').format(_selectedDate)}',
              style: AppTextStyles.label.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildAttendanceTile(Attendance record, Member? member) {
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
                  'Checked in at ${DateFormat('hh:mm a').format(record.checkInTime)}',
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

  void _showCheckInSheet(BuildContext context, List<Member> members) {
    final searchController = TextEditingController();
    List<Member> filtered = members.where((m) => m.getStatus(DateTime.now()) != MemberStatus.expired).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  onChanged: (val) {
                    setSheetState(() {
                      filtered = members.where((m) => 
                        m.name.toLowerCase().contains(val.toLowerCase()) ||
                        (m.phone?.contains(val) ?? false)
                      ).toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search member to check in...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final m = filtered[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text(m.name[0])),
                      title: Text(m.name),
                      subtitle: Text(m.phone ?? 'No Phone'),
                      trailing: const Icon(Icons.login_rounded, color: AppColors.orange),
                      onTap: () async {
                        final attendance = Attendance(
                          memberId: m.memberId,
                          checkInTime: DateTime.now(),
                        );
                        await ref.read(attendanceViewModelProvider.notifier).markAttendance(attendance);
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


