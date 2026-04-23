import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy hh:mm a').format(date);
  }

  static bool isExpired(DateTime expiryDate) {
    return DateTime.now().isAfter(expiryDate);
  }

  static int daysDifference(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }
  
  static DateTime addMonths(DateTime date, int months) {
    int year = date.year + (date.month + months - 1) ~/ 12;
    int month = (date.month + months - 1) % 12 + 1;
    int day = date.day;
    
    // Handle end of month issues
    int lastDay = DateTime(year, month + 1, 0).day;
    if (day > lastDay) day = lastDay;
    
    return DateTime(year, month, day, date.hour, date.minute, date.second);
  }
  
  static DateTime now() => DateTime.now();
}
