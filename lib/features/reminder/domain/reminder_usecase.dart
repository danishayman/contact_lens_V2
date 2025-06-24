import 'package:contact_lens_reminder/core/utils/date_utils.dart';
import 'reminder_model.dart';

class ReminderUseCase {
  /// Calculate the next date when lenses should be changed
  static DateTime getNextChangeDate(ReminderModel reminder) {
    // Calculate how many interval cycles have passed
    final now = DateTime.now();
    final startDate = reminder.startDate;
    final intervalDays = reminder.intervalDays;

    // Calculate days since start
    final int daysSinceStart = now.difference(startDate).inDays;

    // Calculate completed intervals
    final int completedIntervals = daysSinceStart ~/ intervalDays;

    // Calculate next change date
    final nextChangeDate = startDate.add(
      Duration(days: (completedIntervals + 1) * intervalDays),
    );

    return nextChangeDate;
  }

  /// Check if lenses are due to be changed today
  static bool isDueToday(ReminderModel reminder) {
    final nextChangeDate = getNextChangeDate(reminder);
    return DateUtilsHelper.isToday(nextChangeDate);
  }

  /// Calculate days remaining until next lens change
  static int daysRemaining(ReminderModel reminder) {
    final nextChangeDate = getNextChangeDate(reminder);
    return DateUtilsHelper.daysUntil(nextChangeDate);
  }
}
