import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/member.dart';
import '../../data/models/payment.dart';

class CsvExportService {
  const CsvExportService();

  // ── Members Export ────────────────────────────────────────

  /// compute()-compatible static entry point for members CSV.
  static Future<String> membersToString(
      List<Map<String, dynamic>> memberMaps) async {
    final members = memberMaps.map(Member.fromJson).toList();
    final rows = <List<dynamic>>[
      // Header row
      [
        'Member ID', 'Name', 'Phone', 'Gender', 'Age',
        'Join Date', 'Plan', 'Expiry Date', 'Days Remaining',
        'Total Paid', 'Status', 'Last Check-In',
      ],
    ];
    final now = DateTime.now();
    for (final m in members) {
      rows.add([
        m.memberId,
        m.name,
        m.phone ?? '',
        m.gender ?? '',
        m.age?.toString() ?? '',
        _formatDate(m.joinDate),
        m.planName ?? '',
        m.expiryDate != null ? _formatDate(m.expiryDate!) : '',
        m.getDaysRemaining(now).toString(),
        (m.totalPaid / 100.0).toStringAsFixed(2),
        m.getStatus(now).name,
        m.lastCheckIn != null ? _formatDate(m.lastCheckIn!) : '',
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  // ── Payments Export ───────────────────────────────────────

  /// compute()-compatible static entry point for payments CSV.
  static Future<String> paymentsToString(
      List<Map<String, dynamic>> paymentMaps) async {
    final payments = paymentMaps.map(Payment.fromJson).toList();
    final rows = <List<dynamic>>[
      [
        'Invoice #', 'Date', 'Member ID', 'Plan', 'Duration (months)',
        'Method', 'Reference', 'Subtotal', 'GST', 'GST Rate', 'Total',
      ],
    ];
    for (final p in payments) {
      rows.add([
        p.invoiceNumber,
        _formatDate(p.date),
        p.memberId,
        p.planName,
        p.durationMonths.toString(),
        p.method,
        p.reference ?? '',
        p.subtotal.toStringAsFixed(2),
        p.gstAmount.toStringAsFixed(2),
        '${p.gstRate.toStringAsFixed(0)}%',
        p.amount.toStringAsFixed(2),
      ]);
    }
    return const ListToCsvConverter().convert(rows);
  }

  // ── Share helpers ─────────────────────────────────────────

  /// Generate members CSV in compute() and share.
  Future<void> exportAndShareMembers(List<Member> members) async {
    try {
      final maps = members.map((m) => m.toJson()).toList();
      final csv  = await compute(CsvExportService.membersToString, maps);
      await _shareFile(csv, 'ironm_members.csv', 'text/csv');
    } catch (e) {
      debugPrint('CsvExportService.exportAndShareMembers error: $e');
      rethrow;
    }
  }

  /// Generate payments CSV in compute() and share.
  Future<void> exportAndSharePayments(List<Payment> payments) async {
    try {
      final maps = payments.map((p) => p.toJson()).toList();
      final csv  = await compute(CsvExportService.paymentsToString, maps);
      await _shareFile(csv, 'ironm_payments.csv', 'text/csv');
    } catch (e) {
      debugPrint('CsvExportService.exportAndSharePayments error: $e');
      rethrow;
    }
  }

  Future<void> _shareFile(
      String content, String fileName, String mimeType) async {
    final dir  = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(content, flush: true);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: mimeType)],
      subject: fileName,
    );
  }

  static String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';
}
