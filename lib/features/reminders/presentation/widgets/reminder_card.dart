import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/reminder.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;

  const ReminderCard({
    super.key,
    required this.reminder,
    this.onComplete,
    this.onDelete,
  });

  IconData _getIcon(ReminderType type) {
    switch (type) {
      case ReminderType.clinic:
        return Icons.local_hospital;
      case ReminderType.meal:
        return Icons.restaurant;
      case ReminderType.medication:
        return Icons.medication;
      case ReminderType.exercise:
        return Icons.directions_run;
    }
  }

  Color _getColor(ReminderType type) {
    switch (type) {
      case ReminderType.clinic:
        return AppColors.error;
      case ReminderType.meal:
        return AppColors.success;
      case ReminderType.medication:
        return AppColors.warning;
      case ReminderType.exercise:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: _getColor(reminder.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                _getIcon(reminder.type),
                color: _getColor(reminder.type),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      decoration: reminder.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (reminder.description.isNotEmpty)
                    Text(
                      reminder.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDateTime(reminder.scheduledFor),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!reminder.isCompleted) ...[
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                color: AppColors.success,
                onPressed: onComplete,
                tooltip: 'Thibitisha',
              ),
            ],
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: AppColors.error,
              onPressed: onDelete,
              tooltip: 'Futa',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (date == today) {
      dateStr = 'Leo';
    } else if (date == tomorrow) {
      dateStr = 'Kesho';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    return '$dateStr saa ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
