import 'package:isar/isar.dart';

part 'owner_profile.g.dart';

@collection
class OwnerProfile {
  Id? isarId;

  late String gymName;
  late String ownerName;
  late String phone;
  late String address;
  
  String? gstin;
  String? bankName;
  String? accountNumber;
  String? ifsc;
  String? upiId;
  String? logoPath;

  late String hmacSignature;

  OwnerProfile({
    this.gymName = '',
    this.ownerName = '',
    this.phone = '',
    this.address = '',
    this.gstin,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.upiId,
    this.logoPath,
    this.hmacSignature = '',
  });

  Map<String, dynamic> toJson() => {
    'gymName': gymName,
    'ownerName': ownerName,
    'phone': phone,
    'address': address,
    'gstin': gstin,
    'bankName': bankName,
    'accountNumber': accountNumber,
    'ifsc': ifsc,
    'upiId': upiId,
    'logoPath': logoPath,
    'hmacSignature': hmacSignature,
  };

  factory OwnerProfile.fromJson(Map<String, dynamic> json) => OwnerProfile(
    gymName: json['gymName'] ?? '',
    ownerName: json['ownerName'] ?? '',
    phone: json['phone'] ?? '',
    address: json['address'] ?? '',
    gstin: json['gstin'],
    bankName: json['bankName'],
    accountNumber: json['accountNumber'],
    ifsc: json['ifsc'],
    upiId: json['upiId'],
    logoPath: json['logoPath'],
    hmacSignature: json['hmacSignature'] ?? '',
  );
}
