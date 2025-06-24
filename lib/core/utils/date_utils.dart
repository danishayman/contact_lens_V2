// Using DateUtilsHelper name to avoid conflict with Flutter's built-in DateUtils
class DateUtilsHelper {
  /// Calculate the number of days between current date and a target date
  static int daysUntil(DateTime targetDate) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime target = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    return target.difference(today).inDays;
  }

  /// Check if the given date is today
  static bool isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Format date to a readable string (e.g., "June 24, 2025")
  static String formatDate(DateTime date) {
    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
