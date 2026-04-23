import 'package:flutter/material.dart';
import '../../../data/models/attendance.dart';
import '../../../core/utils/date_utils.dart';

class AttendanceRow extends StatelessWidget {
  final Attendance attendance;

  const AttendanceRow({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppDateUtils.formatDateTime(attendance.checkInTime),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.check_circle, color: Colors.blue, size: 20),
        ],
      ),
    );
  }
}
