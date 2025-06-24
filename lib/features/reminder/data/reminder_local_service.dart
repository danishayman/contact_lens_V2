import '../domain/reminder_model.dart';

/// A mock service that simulates storing and retrieving reminders
class ReminderLocalService {
  // In-memory storage for a single reminder
  ReminderModel? _reminderData;

  // Initialize with default data
  ReminderLocalService() {
    // Create a mock reminder (starting today with 14-day interval)
    _reminderData = ReminderModel(
      startDate: DateTime.now(),
      intervalDays: 14,
      lensType: 'Biweekly Soft Contact Lenses',
      notes: 'Use solution XYZ for cleaning',
    );
  }

  /// Get the saved reminder
  Future<ReminderModel?> getReminder() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _reminderData;
  }

  /// Save a reminder
  Future<void> saveReminder(ReminderModel reminder) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _reminderData = reminder;
  }

  /// Delete the saved reminder
  Future<void> deleteReminder() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    _reminderData = null;
  }
}
