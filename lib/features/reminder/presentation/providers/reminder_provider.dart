import 'package:flutter/material.dart';
import '../../data/reminder_local_service.dart';
import '../../domain/reminder_model.dart';

class ReminderProvider extends ChangeNotifier {
  final ReminderLocalService _localService;

  ReminderModel? _reminder;
  bool _isLoading = false;
  String? _error;

  // Getters
  ReminderModel? get reminder => _reminder;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasReminder => _reminder != null;

  // Constructor injects the local service
  ReminderProvider({required ReminderLocalService localService})
    : _localService = localService {
    // Load data when instantiated
    loadReminder();
  }

  /// Load reminder from local service
  Future<void> loadReminder() async {
    _setLoading(true);
    try {
      _reminder = await _localService.getReminder();
      _error = null;
    } catch (e) {
      _error = 'Failed to load reminder: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Save a new reminder
  Future<void> saveReminder(ReminderModel reminder) async {
    _setLoading(true);
    try {
      await _localService.saveReminder(reminder);
      _reminder = reminder;
      _error = null;
    } catch (e) {
      _error = 'Failed to save reminder: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Delete the current reminder
  Future<void> deleteReminder() async {
    _setLoading(true);
    try {
      await _localService.deleteReminder();
      _reminder = null;
      _error = null;
    } catch (e) {
      _error = 'Failed to delete reminder: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Helper to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
