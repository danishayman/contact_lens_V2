import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/notification_helper.dart';
import '../../../../core/widgets/custom_button.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  bool _isSending = false;
  String _status = '';

  Future<void> _scheduleTestNotification() async {
    setState(() {
      _isSending = true;
      _status = '';
    });

    try {
      // Schedule a notification for 5 seconds from now
      final targetDate = DateTime.now().add(const Duration(seconds: 5));

      await NotificationHelper.scheduleReminder(
        targetDate,
        'Test Notification',
        'This is a test reminder notification. If you see this, notifications are working correctly!',
      );

      setState(() {
        _status = 'Notification scheduled for 5 seconds from now';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Notifications'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Notification Test',
                style: AppTextStyles.title,
              ),
              const SizedBox(height: 24),
              const Text(
                'Press the button below to schedule a test notification that will appear in 5 seconds.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 32),
              if (_isSending)
                const CircularProgressIndicator()
              else
                CustomButton(
                  label: 'Send Test Notification',
                  onPressed: _scheduleTestNotification,
                  isFullWidth: true,
                ),
              if (_status.isNotEmpty) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _status.contains('Error')
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _status,
                    style: AppTextStyles.body.copyWith(
                      color: _status.contains('Error')
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
