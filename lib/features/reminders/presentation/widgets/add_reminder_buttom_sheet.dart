import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/models/reminder.dart';
import '../providers/reminder_provider.dart';

class AddReminderBottomSheet extends ConsumerStatefulWidget {
  const AddReminderBottomSheet({super.key});

  @override
  ConsumerState<AddReminderBottomSheet> createState() =>
      _AddReminderBottomSheetState();
}

class _AddReminderBottomSheetState
    extends ConsumerState<AddReminderBottomSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reminderFormNotifierProvider);
    final notifier = ref.read(reminderFormNotifierProvider.notifier);

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Ongeza Kikumbusho',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 20.h),

          // Reminder Type
          Text(
            'Aina ya Kikumbusho',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            children: ReminderType.values.map((type) {
              final isSelected = state.type == type;
              String label;
              IconData icon;

              switch (type) {
                case ReminderType.clinic:
                  label = 'Kliniki';
                  icon = Icons.local_hospital;
                  break;
                case ReminderType.meal:
                  label = 'Mlo';
                  icon = Icons.restaurant;
                  break;
                case ReminderType.medication:
                  label = 'Dawa';
                  icon = Icons.medication;
                  break;
                case ReminderType.exercise:
                  label = 'Mazoezi';
                  icon = Icons.directions_run;
                  break;
              }

              return FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(label),
                  ],
                ),
                selected: isSelected,
                onSelected: (_) => notifier.updateType(type),
                selectedColor: AppColors.primary.withOpacity(0.1),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),

          // Title
          AppTextField(
            label: 'Kichwa',
            controller: _titleController,
            onChanged: notifier.updateTitle,
          ),
          SizedBox(height: 16.h),

          // Description
          AppTextField(
            label: 'Maelezo (Si lazima)',
            controller: _descriptionController,
            onChanged: notifier.updateDescription,
            maxLines: 2,
          ),
          SizedBox(height: 16.h),

          // Date and Time
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      notifier.updateDate(date);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Tarehe',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      state.scheduledDate != null
                          ? '${state.scheduledDate!.day}/${state.scheduledDate!.month}/${state.scheduledDate!.year}'
                          : 'Chagua tarehe',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      notifier.updateTime(time);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Muda',
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    child: Text(
                      state.scheduledTime != null
                          ? state.scheduledTime!.format(context)
                          : 'Chagua muda',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Error message
          if (state.errorMessage != null)
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Text(
                state.errorMessage!,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 14.sp,
                ),
              ),
            ),

          // Submit button
          AppButton(
            text: 'Hifadhi Kikumbusho',
            onPressed: () async {
              final success = await notifier.submit();
              if (success && mounted) {
                Navigator.pop(context);
              }
            },
            isLoading: state.isLoading,
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
