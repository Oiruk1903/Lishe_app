import 'package:equatable/equatable.dart';

enum ReminderType {
  clinic,
  meal,
  medication,
  exercise,
}

class Reminder extends Equatable {
  final String id;
  final String userId;
  final ReminderType type;
  final String title;
  final String description;
  final DateTime scheduledFor;
  final bool isCompleted;
  final bool synced;
  final Map<String, dynamic>? metadata;

  const Reminder({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.scheduledFor,
    this.isCompleted = false,
    this.synced = false,
    this.metadata,
  });

  Reminder copyWith({
    String? id,
    String? userId,
    ReminderType? type,
    String? title,
    String? description,
    DateTime? scheduledFor,
    bool? isCompleted,
    bool? synced,
    Map<String, dynamic>? metadata,
  }) {
    return Reminder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      isCompleted: isCompleted ?? this.isCompleted,
      synced: synced ?? this.synced,
      metadata: metadata ?? this.metadata,
    );
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: ReminderType.values.firstWhere(
        (e) => e.name == map['type'],
      ),
      title: map['title'] as String,
      description: map['description'] as String,
      scheduledFor: DateTime.parse(map['scheduled_for'] as String),
      isCompleted: (map['is_completed'] as int) == 1,
      synced: (map['synced'] as int) == 1,
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'title': title,
      'description': description,
      'scheduled_for': scheduledFor.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'synced': synced ? 1 : 0,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        title,
        description,
        scheduledFor,
        isCompleted,
        synced,
      ];
}
