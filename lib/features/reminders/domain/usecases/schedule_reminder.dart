import 'package:uuid/uuid.dart';
import '../../data/datasources/reminder_local_datasource.dart';
import '../../data/models/reminder.dart';
import '../../../../core/services/notification_service.dart';

class ScheduleReminderUseCase {
  final ReminderLocalDataSource _dataSource;

  ScheduleReminderUseCase(this._dataSource);

  Future<void> execute({
    required String userId,
    required ReminderType type,
    required String title,
    required String description,
    required DateTime scheduledFor,
    Map<String, dynamic>? metadata,
  }) async {
    final reminder = Reminder(
      id: const Uuid().v4(),
      userId: userId,
      type: type,
      title: title,
      description: description,
      scheduledFor: scheduledFor,
      metadata: metadata,
    );

    await _dataSource.saveReminder(reminder);

    // Schedule notification
    await NotificationService.scheduleReminder(
      id: reminder.id.hashCode,
      title: title,
      body: description,
      scheduledTime: scheduledFor,
      payload: reminder.id,
    );
  }
}
