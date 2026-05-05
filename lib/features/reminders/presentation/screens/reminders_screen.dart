import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lishe_app/features/reminders/presentation/widgets/add_reminder_buttom_sheet.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/reminder.dart';
import '../providers/reminder_provider.dart';
import '../widgets/reminder_card.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remindersAsync = ref.watch(remindersProvider);
    final upcomingAsync = ref.watch(upcomingRemindersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vikumbusho'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Vijayo'),
            Tab(text: 'Zote'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming Tab
          _buildReminderList(upcomingAsync, showCompleted: false),

          // All Tab
          _buildReminderList(remindersAsync, showCompleted: true),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(context),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildReminderList(
    AsyncValue<List<Reminder>> asyncValue, {
    required bool showCompleted,
  }) {
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (reminders) {
        final filteredReminders = showCompleted
            ? reminders
            : reminders.where((r) => !r.isCompleted).toList();

        if (filteredReminders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 64.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Hakuna vikumbusho',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          itemCount: filteredReminders.length,
          itemBuilder: (context, index) {
            final reminder = filteredReminders[index];
            return ReminderCard(
              reminder: reminder,
              onComplete: reminder.isCompleted
                  ? null
                  : () async {
                      await ref.read(
                        markReminderCompletedProvider(reminder.id).future,
                      );
                    },
              onDelete: () async {
                final dataSource = ref.read(reminderLocalDataSourceProvider);
                await dataSource.deleteReminder(reminder.id);
                ref.invalidate(remindersProvider);
                ref.invalidate(upcomingRemindersProvider);
              },
            );
          },
        );
      },
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => const AddReminderBottomSheet(),
    );
  }
}
