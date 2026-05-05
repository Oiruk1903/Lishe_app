import 'package:equatable/equatable.dart';

class WeightEntry extends Equatable {
  final String id;
  final String userId;
  final double weight;
  final DateTime recordedAt;
  final bool synced;
  final String? note;

  const WeightEntry({
    required this.id,
    required this.userId,
    required this.weight,
    required this.recordedAt,
    this.synced = false,
    this.note,
  });

  @override
  List<Object?> get props => [id, userId, weight, recordedAt, synced];
}
