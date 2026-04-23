import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ironbook_gm/data/models/member.dart';
import 'package:ironbook_gm/data/models/payment.dart';
import 'package:ironbook_gm/data/models/attendance.dart';
import 'package:ironbook_gm/data/models/plan.dart';
import 'package:ironbook_gm/data/models/domain_event.dart';
import 'package:ironbook_gm/data/models/product.dart';
import 'package:ironbook_gm/data/models/sale.dart';
import 'package:ironbook_gm/data/models/owner_profile.dart';
import 'package:ironbook_gm/data/models/invoice_sequence.dart';
import 'package:ironbook_gm/data/models/app_settings.dart';

final isarProvider = Provider<Isar?>((ref) => null);

Future<Isar> initIsar() async {
  final schemas = [
    MemberSchema,
    PaymentSchema,
    AttendanceSchema,
    PlanSchema,
    DomainEventSchema,
    ProductSchema,
    SaleSchema,
    OwnerProfileSchema,
    InvoiceSequenceSchema,
    AppSettingsSchema,
  ];

  if (kIsWeb) {
    return Isar.open(schemas, directory: '');
  } else {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      schemas,
      directory: dir.path,
    );
  }
}
