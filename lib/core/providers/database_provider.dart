import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/payment.dart';
import 'package:ironm/data/models/attendance.dart';
import 'package:ironm/data/models/plan.dart';
import 'package:ironm/data/models/domain_event.dart';
import 'package:ironm/data/models/product.dart';
import 'package:ironm/data/models/sale.dart';
import 'package:ironm/data/models/owner_profile.dart';
import 'package:ironm/data/models/invoice_sequence.dart';
import 'package:ironm/data/models/app_settings.dart';

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
