import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/weight_entry.dart';

part 'weight_entry_model.freezed.dart';
part 'weight_entry_model.g.dart';

@freezed
class WeightEntryModel with _$WeightEntryModel {
  const factory WeightEntryModel({
    required String id,
    required String userId,
    required double weight,
    required DateTime recordedAt,
    @Default(false) bool synced,
    String? note,
  }) = _WeightEntryModel;

  factory WeightEntryModel.fromJson(Map<String, dynamic> json) =>
      _$WeightEntryModelFromJson(json);

  factory WeightEntryModel.fromEntity(WeightEntry entry) => WeightEntryModel(
        id: entry.id,
        userId: entry.userId,
        weight: entry.weight,
        recordedAt: entry.recordedAt,
        synced: entry.synced,
        note: entry.note,
      );
}

extension WeightEntryModelX on WeightEntryModel {
  WeightEntry toEntity() => WeightEntry(
        id: id,
        userId: userId,
        weight: weight,
        recordedAt: recordedAt,
        synced: synced,
        note: note,
      );
}
