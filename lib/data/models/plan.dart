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
}
