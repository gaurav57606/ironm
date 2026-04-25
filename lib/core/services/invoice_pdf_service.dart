import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../data/models/member.dart';
import '../../data/models/payment.dart';
import '../../data/models/owner_profile.dart';

/// Pure service — no Isar, no Firebase, no Riverpod dependency.
/// Takes data objects → returns PDF bytes.
/// Always call via compute() to avoid janking the UI thread.
class InvoicePdfService {
  const InvoicePdfService();

  /// Entry point for compute() — receives a map of plain data.
  /// compute() cannot pass typed objects directly, so we pass
  /// pre-serialized Maps and rebuild inside the isolate.
  static Future<Uint8List> generateFromMaps(
      Map<String, dynamic> args) async {
    final member  = Member.fromJson(args['member']  as Map<String, dynamic>);
    final payment = Payment.fromJson(args['payment'] as Map<String, dynamic>);
    final ownerMap = args['owner'] as Map<String, dynamic>?;
    final owner = ownerMap != null ? OwnerProfile.fromJson(ownerMap) : null;
    return const InvoicePdfService()._build(member, payment, owner);
  }

  Future<Uint8List> _build(
    Member member,
    Payment payment,
    OwnerProfile? owner,
  ) async {
    final doc = pw.Document();

    // ── Colours matching IronM brand ─────────────────────────
    const orange    = PdfColor.fromInt(0xFFFF6B2B);
    const bgCard    = PdfColor.fromInt(0xFF141417);
    const borderCol = PdfColor.fromInt(0xFF2A2A30);
    const textPrim  = PdfColor.fromInt(0xFFF0EEF6);
    const textSec   = PdfColor.fromInt(0xFF9896A4);
    const textMuted = PdfColor.fromInt(0xFF5C5A67);

    final gymName    = owner?.gymName    ?? 'IronM Fitness';
    final ownerName  = owner?.ownerName  ?? '';
    final address    = owner?.address    ?? 'Premium Gym Management';
    final gstin      = owner?.gstin      ?? 'N/A';
    final bankName   = owner?.bankName   ?? 'N/A';
    final accountNo  = owner?.accountNumber ?? 'N/A';
    final ifsc       = owner?.ifsc       ?? 'N/A';
    final upi        = owner?.upiId      ?? '';

    final invoiceDate = _formatDate(payment.date);
    final expiryStr   = member.expiryDate != null
        ? _formatDate(member.expiryDate!)
        : 'N/A';

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              // ── Header ────────────────────────────────────────
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: bgCard,
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: orange, width: 0.5),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(gymName,
                            style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: orange)),
                        pw.SizedBox(height: 4),
                        pw.Text(ownerName,
                            style: pw.TextStyle(fontSize: 9, color: textSec)),
                        pw.Text(address,
                            style: pw.TextStyle(fontSize: 8, color: textMuted)),
                        if (gstin != 'N/A')
                          pw.Text('GSTIN: $gstin',
                              style:
                                  pw.TextStyle(fontSize: 8, color: textMuted)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('INVOICE',
                            style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: orange)),
                        pw.Text('#${payment.invoiceNumber}',
                            style: pw.TextStyle(fontSize: 9, color: textSec)),
                        pw.SizedBox(height: 4),
                        pw.Text('Date: $invoiceDate',
                            style: pw.TextStyle(fontSize: 8, color: textMuted)),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 16),

              // ── Billed To ─────────────────────────────────────
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: bgCard,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: borderCol),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('BILLED TO',
                        style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            color: textSec)),
                    pw.SizedBox(height: 6),
                    _pdfRow('Name',   member.name,        textPrim, textSec),
                    _pdfRow('Phone',  member.phone ?? '-', textPrim, textSec),
                    _pdfRow('Member ID',
                        member.memberId.substring(0, 8).toUpperCase(),
                        textPrim, textSec),
                  ],
                ),
              ),

              pw.SizedBox(height: 12),

              // ── Subscription Details ──────────────────────────
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: bgCard,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: borderCol),
                ),
                child: pw.Column(
                  children: [
                    _pdfRow('Plan',     payment.planName,  textPrim, textSec),
                    _pdfRow('Duration', '${payment.durationMonths} month(s)', textPrim, textSec),
                    _pdfRow('Valid Till', expiryStr,       textPrim, textSec),
                    _pdfRow('Payment Method', payment.method, textPrim, textSec),
                    if (payment.reference != null && payment.reference!.isNotEmpty)
                      _pdfRow('Ref', payment.reference!,  textPrim, textSec),
                  ],
                ),
              ),

              pw.SizedBox(height: 12),

              // ── Line Items ────────────────────────────────────
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: bgCard,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: borderCol),
                ),
                child: pw.Column(
                  children: [
                    // Items
                    if (payment.components.isNotEmpty)
                      ...payment.components.map((c) =>
                          _pdfRow(c.name, '₹${c.price.toStringAsFixed(2)}',
                              textPrim, textSec))
                    else
                      _pdfRow(payment.planName,
                          '₹${payment.subtotal.toStringAsFixed(2)}',
                          textPrim, textSec),

                    pw.Divider(color: borderCol, thickness: 0.5),

                    _pdfRow('Subtotal',
                        '₹${payment.subtotal.toStringAsFixed(2)}',
                        textSec, textSec),
                    _pdfRow('GST @ ${payment.gstRate.toStringAsFixed(0)}% (Incl.)',
                        '₹${payment.gstAmount.toStringAsFixed(2)}',
                        textSec, textSec),

                    pw.SizedBox(height: 6),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('TOTAL PAID',
                            style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: textPrim)),
                        pw.Text('₹${payment.amount.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight: pw.FontWeight.bold,
                                color: orange)),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 12),

              // ── Bank / UPI Details ────────────────────────────
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: bgCard,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: borderCol),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('PAYMENT DETAILS',
                        style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            color: textSec)),
                    pw.SizedBox(height: 6),
                    if (bankName != 'N/A') ...[
                      _pdfRow('Bank', bankName, textPrim, textSec),
                      _pdfRow('A/C', accountNo, textPrim, textSec),
                      _pdfRow('IFSC', ifsc,     textPrim, textSec),
                    ],
                    if (upi.isNotEmpty)
                      _pdfRow('UPI', upi, textPrim, textSec),
                  ],
                ),
              ),

              pw.Spacer(),

              // ── Footer ────────────────────────────────────────
              pw.Divider(color: borderCol),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TxID: ${payment.id.substring(0, 8).toUpperCase()}',
                    style: pw.TextStyle(fontSize: 7, color: textMuted),
                  ),
                  pw.Text(
                    'Generated by IronM · ironm.app',
                    style: pw.TextStyle(fontSize: 7, color: textMuted),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  // ── Helpers ────────────────────────────────────────────────

  pw.Widget _pdfRow(
      String label, String value, PdfColor valColor, PdfColor labColor) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(fontSize: 9, color: labColor)),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: valColor)),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} '
      '${_months[d.month - 1]} '
      '${d.year}';

  static const _months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];
}
