import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/reminder_local_datasource.dart';
import '../../data/models/reminder.dart';
import '../../domain/usecases/schedule_reminder.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final reminderLocalDataSourceProvider =
    Provider<ReminderLocalDataSource>((ref) {
  return ReminderLocalDataSource();
});

final scheduleReminderUseCaseProvider =
    Provider<ScheduleReminderUseCase>((ref) {
  final dataSource = ref.watch(reminderLocalDataSourceProvider);
  return ScheduleReminderUseCase(dataSource);
});

final remindersProvider = FutureProvider<List<Reminder>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.user?.id;
  if (userId == null) return [];
  final dataSource = ref.watch(reminderLocalDataSourceProvider);
  return await dataSource.getReminders(userId);
});

final upcomingRemindersProvider = FutureProvider<List<Reminder>>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.user?.id;
  if (userId == null) return [];
  final dataSource = ref.watch(reminderLocalDataSourceProvider);
  return await dataSource.getUpcomingReminders(userId);
});

class ReminderFormState {
  final ReminderType? type;
  final String title;
  final String description;
  final DateTime? scheduledDate;
  final TimeOfDay? scheduledTime;
  final bool isLoading;
  final String? errorMessage;

  const ReminderFormState({
    this.type,
    this.title = '',
    this.description = '',
    this.scheduledDate,
    this.scheduledTime,
    this.isLoading = false,
    this.errorMessage,
  });

  ReminderFormState copyWith({
    ReminderType? type,
    String? title,
    String? description,
    DateTime? scheduledDate,
    TimeOfDay? scheduledTime,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ReminderFormState(
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ReminderFormNotifier extends StateNotifier<ReminderFormState> {
  final ScheduleReminderUseCase _scheduleUseCase;
  final Ref _ref;

  ReminderFormNotifier(this._scheduleUseCase, this._ref)
      : super(const ReminderFormState());

  void updateType(ReminderType type) {
    state = state.copyWith(type: type);
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(scheduledDate: date);
  }

  void updateTime(TimeOfDay time) {
    state = state.copyWith(scheduledTime: time);
  }

  Future<bool> submit() async {
    final authState = _ref.read(authNotifierProvider);
    final userId = authState.user?.id;

    if (userId == null) {
      state = state.copyWith(errorMessage: 'User not logged in');
      return false;
    }

    if (state.type == null ||
        state.title.isEmpty ||
        state.scheduledDate == null ||
        state.scheduledTime == null) {
      state = state.copyWith(errorMessage: 'Tafadhali jaza taarifa zote');
      return false;
    }

    final scheduledFor = DateTime(
      state.scheduledDate!.year,
      state.scheduledDate!.month,
      state.scheduledDate!.day,
      state.scheduledTime!.hour,
      state.scheduledTime!.minute,
    );

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _scheduleUseCase.execute(
        userId: userId,
        type: state.type!,
        title: state.title,
        description: state.description,
        scheduledFor: scheduledFor,
      );

      state = const ReminderFormState();
      _ref.invalidate(remindersProvider);
      _ref.invalidate(upcomingRemindersProvider);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void reset() {
    state = const ReminderFormState();
  }
}

final reminderFormNotifierProvider =
    StateNotifierProvider<ReminderFormNotifier, ReminderFormState>((ref) {
  final useCase = ref.watch(scheduleReminderUseCaseProvider);
  return ReminderFormNotifier(useCase, ref);
});

// Mark reminder as completed
final markReminderCompletedProvider =
    FutureProvider.family<void, String>((ref, reminderId) async {
  final dataSource = ref.watch(reminderLocalDataSourceProvider);
  await dataSource.markAsCompleted(reminderId);
  ref.invalidate(remindersProvider);
  ref.invalidate(upcomingRemindersProvider);
});
