import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IClock {
  DateTime get now;
}

class Clock implements IClock {
  const Clock();
  @override
  DateTime get now => DateTime.now();
}

final clockProvider = Provider<IClock>((ref) => const Clock());
