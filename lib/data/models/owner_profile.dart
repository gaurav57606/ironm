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

  // Gamification stats (from version0)
  late int level;
  late int exp;
  late double strength;
  late double endurance;
  late double dexterity;
  late String selectedCharacterId;

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
    this.level = 1,
    this.exp = 0,
    this.strength = 0.5,
    this.endurance = 0.5,
    this.dexterity = 0.5,
    this.selectedCharacterId = 'warrior',
    this.hmacSignature = '',
  });
}
