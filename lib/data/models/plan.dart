import 'package:isar/isar.dart';

part 'plan.g.dart';

@collection
class Plan {
  Id? isarId;

  @Index(unique: true)
  late String id;

  late String name;
  late int durationMonths;
  late List<PlanComponent> components;
  
  @Index()
  late bool active;

  late String hmacSignature;

  Plan({
    required this.id,
    required this.name,
    required this.durationMonths,
    this.components = const [],
    this.active = true,
    this.hmacSignature = '',
  });

  @ignore
  double get totalPrice => components.fold(0, (sum, c) => sum + c.price);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'durationMonths': durationMonths,
    'components': components.map((e) => e.toJson()).toList(),
    'active': active,
    'hmacSignature': hmacSignature,
  };

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    durationMonths: json['durationMonths'] ?? 0,
    components: (json['components'] as List?)?.map((e) => PlanComponent.fromJson(e)).toList() ?? [],
    active: json['active'] ?? true,
    hmacSignature: json['hmacSignature'] ?? '',
  );
}

@embedded
class PlanComponent {
  late String id;
  late String name;
  late double price;

  PlanComponent({
    this.id = '',
    this.name = '',
    this.price = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
  };

  factory PlanComponent.fromJson(Map<String, dynamic> json) => PlanComponent(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
  );
}
