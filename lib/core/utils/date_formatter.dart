import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime d) => DateFormat('d MMM yyyy').format(d);
  static String formatShort(DateTime d) => DateFormat('MMM yyyy').format(d);
}
