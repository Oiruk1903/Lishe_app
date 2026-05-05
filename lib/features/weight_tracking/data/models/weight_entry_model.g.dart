// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeightEntryModelImpl _$$WeightEntryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WeightEntryModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weight: (json['weight'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      synced: json['synced'] as bool? ?? false,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$WeightEntryModelImplToJson(
        _$WeightEntryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'weight': instance.weight,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'synced': instance.synced,
      'note': instance.note,
    };
