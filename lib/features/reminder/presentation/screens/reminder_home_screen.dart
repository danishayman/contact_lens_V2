import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../routes/route_names.dart';
import '../providers/reminder_provider.dart';
import '../widgets/reminder_card.dart';

class ReminderHomeScreen extends StatelessWidget {
  const ReminderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Lens Reminder'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    label: 'Retry',
                    onPressed: () => provider.loadReminder(),
                  ),
                ],
              ),
            );
          }

          if (!provider.hasReminder) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No reminder set up yet!',
                    style: AppTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    label: 'Set Up Reminder',
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.setup);
                    },
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Contact Lens Reminder',
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 16),
                ReminderCard(reminder: provider.reminder!),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final provider =
              Provider.of<ReminderProvider>(context, listen: false);
          Navigator.pushNamed(
            context,
            RouteNames.setup,
            arguments:
                provider.hasReminder ? {'reminder': provider.reminder} : null,
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
