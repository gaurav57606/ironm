import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:ironm/data/models/domain_event.dart';
import 'package:ironm/data/models/member.dart';
import 'package:ironm/data/models/owner_profile.dart';
import 'package:ironm/data/models/plan.dart';
import 'package:ironm/data/models/payment.dart';
import 'package:ironm/core/utils/canonical_json.dart';

final hmacServiceProvider = Provider<HmacService>((ref) {
  return const HmacService(FlutterSecureStorage());
});

class HmacService {
  final FlutterSecureStorage _storage;
  
  static const _keyStorageName = 'hmac_device_key';
  static const _idKey = 'installation_id';

  const HmacService(this._storage);

  Future<String> _getOrCreateKey() async {
    var key = await _storage.read(key: _keyStorageName);
    if (key == null) {
      final bytes = List.generate(32, (_) => Random.secure().nextInt(256));
      key = base64Encode(bytes);
      await _storage.write(key: _keyStorageName, value: key);
    }
    return key;
  }

  Future<String> getInstallationId() async {
    var id = await _storage.read(key: _idKey);
    if (id == null) {
      id = const Uuid().v4();
      await _storage.write(key: _idKey, value: id);
    }
    return id;
  }

  Future<String> signEvent(DomainEvent event) async {
    final keyStr = await _getOrCreateKey();
    final keyBytes = base64Decode(keyStr);
    final payloadJson = CanonicalJson.encode(event.payload);
    
    final canonical = '${event.id}|${event.entityId}|${event.eventType.name}|'
        '${event.deviceTimestamp.toUtc().toIso8601String()}|'
        '$payloadJson|${event.deviceId}';
    
    final hmacSha256 = crypto.Hmac(crypto.sha256, keyBytes);
    final digest = hmacSha256.convert(utf8.encode(canonical));
    return base64Encode(digest.bytes);
  }

  Future<bool> verifyEvent(DomainEvent event) async {
    if (event.hmacSignature.isEmpty) return false;
    final expected = await signEvent(event);
    return expected == event.hmacSignature;
  }

  Future<String> signData(String entityId, Map<String, dynamic> data) async {
    final keyStr = await _getOrCreateKey();
    final keyBytes = base64Decode(keyStr);
    final payloadJson = CanonicalJson.encode(data);
    final canonical = '$entityId|$payloadJson';
    
    final hmacSha256 = crypto.Hmac(crypto.sha256, keyBytes);
    final digest = hmacSha256.convert(utf8.encode(canonical));
    return base64Encode(digest.bytes);
  }

  Future<bool> verifySnapshot(String entityId, Map<String, dynamic> data, String signature) async {
    final expected = await signData(entityId, data);
    return expected == signature;
  }

  Future<String> signSnapshot(dynamic instance) => signInstance(instance);

  Future<String> signInstance(dynamic instance) async {
    if (instance is Member) {
      return signData(instance.memberId, {
        'name': instance.name,
        'phone': instance.phone,
        'joinDate': instance.joinDate.toIso8601String(),
        'planId': instance.planId,
        'expiryDate': instance.expiryDate?.toIso8601String(),
        'totalPaid': instance.totalPaid,
        'archived': instance.archived,
      });
    } else if (instance is OwnerProfile) {
      return signData('owner', {
        'gymName': instance.gymName,
        'ownerName': instance.ownerName,
        'phone': instance.phone,
        'level': instance.level,
      });
    } else if (instance is Payment) {
      return signData(instance.id, {
        'memberId': instance.memberId,
        'amount': instance.amount,
        'date': instance.date.toIso8601String(),
        'method': instance.method,
      });
    } else if (instance is Plan) {
      return signData(instance.id, {
        'name': instance.name,
        'durationMonths': instance.durationMonths,
      });
    } else if (instance is DomainEvent) {
      return signEvent(instance);
    }
    throw UnimplementedError('HMAC signing not implemented for ${instance.runtimeType}');
  }

  Future<bool> verifyInstance(dynamic instance) async {
    if (instance == null) return false;
    final signature = (instance as dynamic).hmacSignature as String;
    if (signature.isEmpty) return false;
    final expected = await signInstance(instance);
    return expected == signature;
  }
}
