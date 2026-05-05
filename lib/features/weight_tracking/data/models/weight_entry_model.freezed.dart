// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeightEntryModel _$WeightEntryModelFromJson(Map<String, dynamic> json) {
  return _WeightEntryModel.fromJson(json);
}

/// @nodoc
mixin _$WeightEntryModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  DateTime get recordedAt => throw _privateConstructorUsedError;
  bool get synced => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this WeightEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightEntryModelCopyWith<WeightEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightEntryModelCopyWith<$Res> {
  factory $WeightEntryModelCopyWith(
          WeightEntryModel value, $Res Function(WeightEntryModel) then) =
      _$WeightEntryModelCopyWithImpl<$Res, WeightEntryModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      double weight,
      DateTime recordedAt,
      bool synced,
      String? note});
}

/// @nodoc
class _$WeightEntryModelCopyWithImpl<$Res, $Val extends WeightEntryModel>
    implements $WeightEntryModelCopyWith<$Res> {
  _$WeightEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? weight = null,
    Object? recordedAt = null,
    Object? synced = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeightEntryModelImplCopyWith<$Res>
    implements $WeightEntryModelCopyWith<$Res> {
  factory _$$WeightEntryModelImplCopyWith(_$WeightEntryModelImpl value,
          $Res Function(_$WeightEntryModelImpl) then) =
      __$$WeightEntryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      double weight,
      DateTime recordedAt,
      bool synced,
      String? note});
}

/// @nodoc
class __$$WeightEntryModelImplCopyWithImpl<$Res>
    extends _$WeightEntryModelCopyWithImpl<$Res, _$WeightEntryModelImpl>
    implements _$$WeightEntryModelImplCopyWith<$Res> {
  __$$WeightEntryModelImplCopyWithImpl(_$WeightEntryModelImpl _value,
      $Res Function(_$WeightEntryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeightEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? weight = null,
    Object? recordedAt = null,
    Object? synced = null,
    Object? note = freezed,
  }) {
    return _then(_$WeightEntryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightEntryModelImpl implements _WeightEntryModel {
  const _$WeightEntryModelImpl(
      {required this.id,
      required this.userId,
      required this.weight,
      required this.recordedAt,
      this.synced = false,
      this.note});

  factory _$WeightEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightEntryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final double weight;
  @override
  final DateTime recordedAt;
  @override
  @JsonKey()
  final bool synced;
  @override
  final String? note;

  @override
  String toString() {
    return 'WeightEntryModel(id: $id, userId: $userId, weight: $weight, recordedAt: $recordedAt, synced: $synced, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightEntryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.synced, synced) || other.synced == synced) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, weight, recordedAt, synced, note);

  /// Create a copy of WeightEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightEntryModelImplCopyWith<_$WeightEntryModelImpl> get copyWith =>
      __$$WeightEntryModelImplCopyWithImpl<_$WeightEntryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightEntryModelImplToJson(
      this,
    );
  }
}

abstract class _WeightEntryModel implements WeightEntryModel {
  const factory _WeightEntryModel(
      {required final String id,
      required final String userId,
      required final double weight,
      required final DateTime recordedAt,
      final bool synced,
      final String? note}) = _$WeightEntryModelImpl;

  factory _WeightEntryModel.fromJson(Map<String, dynamic> json) =
      _$WeightEntryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  double get weight;
  @override
  DateTime get recordedAt;
  @override
  bool get synced;
  @override
  String? get note;

  /// Create a copy of WeightEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightEntryModelImplCopyWith<_$WeightEntryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
