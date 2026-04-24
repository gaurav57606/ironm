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
import 'web_data_store.dart';

final isarProvider = Provider<Isar?>((ref) => null);

final webDataStoreProvider = Provider<WebDataStore?>((ref) {
  // We'll initialize this in main and override it
  return null;
});

Future<Isar?> initIsar() async {
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

  try {
    if (kIsWeb) {
      // Isar 3.x web support is limited and often fails in local dev or specific browsers.
      // We'll return null here and let the repositories fall back to WebDataStore.
      return null; 
    } else {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        schemas,
        directory: dir.path,
      );
    }
  } catch (e) {
    debugPrint('Failed to initialize Isar: $e');
    return null;
  }
}
