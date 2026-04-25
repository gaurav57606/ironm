import 'package:isar/isar.dart';

part 'sync_job.g.dart';

enum SyncOperation { upsert, delete }
enum SyncCollection { members, payments, attendance, plans }

@collection
class SyncJob {
  Id isarId = Isar.autoIncrement;

  @Index()
  late String docId;          // e.g. memberId / paymentId

  @enumerated
  late SyncCollection collection;

  @enumerated
  late SyncOperation operation;

  late String payloadJson;    // JSON string of toJson()

  @Index()
  late DateTime createdAt;

  int retryCount = 0;

  SyncJob({
    required this.docId,
    required this.collection,
    required this.operation,
    required this.payloadJson,
    required this.createdAt,
    this.retryCount = 0,
  });
}
