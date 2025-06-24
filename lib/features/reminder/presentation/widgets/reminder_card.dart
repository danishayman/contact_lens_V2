import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_utils.dart';
import '../../domain/reminder_model.dart';
import '../../domain/reminder_usecase.dart';

class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;

  const ReminderCard({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    final daysRemaining = ReminderUseCase.daysRemaining(reminder);
    final nextChangeDate = ReminderUseCase.getNextChangeDate(reminder);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    reminder.lensType,
                    style: AppTextStyles.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(daysRemaining),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Start Date',
              value: DateUtilsHelper.formatDate(reminder.startDate),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.event_repeat,
              label: 'Interval',
              value: '${reminder.intervalDays} days',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.event_available,
              label: 'Next Change',
              value: DateUtilsHelper.formatDate(nextChangeDate),
            ),
            if (reminder.notes != null && reminder.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Notes:',
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(reminder.notes!, style: AppTextStyles.caption),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int daysRemaining) {
    late final Color badgeColor;
    late final String text;

    if (daysRemaining < 0) {
      badgeColor = AppColors.error;
      text = 'Overdue';
    } else if (daysRemaining == 0) {
      badgeColor = AppColors.error;
      text = 'Change Today';
    } else if (daysRemaining <= 2) {
      badgeColor = AppColors.secondary;
      text = '$daysRemaining days';
    } else {
      badgeColor = AppColors.success;
      text = '$daysRemaining days';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (daysRemaining > 0) ...[
            Text(
              '$daysRemaining',
              style: AppTextStyles.body.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'days',
              style: AppTextStyles.caption.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else
            Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textLight),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.caption,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
