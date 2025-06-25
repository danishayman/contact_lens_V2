import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/utils/notification_helper.dart';
import '../../domain/reminder_model.dart';
import '../providers/reminder_provider.dart';

class ReminderSetupScreen extends StatefulWidget {
  final ReminderModel? initialReminder;

  const ReminderSetupScreen({
    super.key,
    this.initialReminder,
  });

  @override
  State<ReminderSetupScreen> createState() => _ReminderSetupScreenState();
}

class _ReminderSetupScreenState extends State<ReminderSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  final _lensTypeController = TextEditingController();
  final _intervalDaysController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  void _initializeFormData() {
    if (widget.initialReminder != null) {
      _selectedDate = widget.initialReminder!.startDate;
      _lensTypeController.text = widget.initialReminder!.lensType;
      _intervalDaysController.text =
          widget.initialReminder!.intervalDays.toString();
      _notesController.text = widget.initialReminder!.notes ?? '';
    } else {
      // Default values
      _lensTypeController.text = 'Biweekly Soft Contact Lenses';
      _intervalDaysController.text = '14';
    }
  }

  @override
  void dispose() {
    _lensTypeController.dispose();
    _intervalDaysController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final intervalDays = int.parse(_intervalDaysController.text);

      final reminder = ReminderModel(
        startDate: _selectedDate,
        intervalDays: intervalDays,
        lensType: _lensTypeController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      await context.read<ReminderProvider>().saveReminder(reminder);

      // Schedule a notification
      final nextChangeDate = _calculateNextChangeDate(reminder);
      await NotificationHelper.scheduleReminder(
        nextChangeDate,
        'Time to Change Your Lenses',
        'Your ${reminder.lensType} need to be changed today!',
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save reminder: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  DateTime _calculateNextChangeDate(ReminderModel reminder) {
    final daysUntilChange = reminder.intervalDays -
        DateTime.now().difference(reminder.startDate).inDays %
            reminder.intervalDays;

    return DateTime.now().add(Duration(days: daysUntilChange));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialReminder == null
            ? 'Set Up Reminder'
            : 'Edit Reminder'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'When did you start using your current lenses?',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: AppTextStyles.body,
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'What type of lenses do you use?',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lensTypeController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Biweekly Soft Contact Lenses',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lens type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'How many days until you need to change them?',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _intervalDaysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'e.g., 14',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter interval days';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of days';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Additional notes (optional)',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Use solution XYZ for cleaning',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                CustomButton(
                  label: 'Save Reminder',
                  onPressed: _saveReminder,
                  isFullWidth: true,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
