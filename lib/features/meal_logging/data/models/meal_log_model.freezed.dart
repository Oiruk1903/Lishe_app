// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MealLogModel _$MealLogModelFromJson(Map<String, dynamic> json) {
  return _MealLogModel.fromJson(json);
}

/// @nodoc
mixin _$MealLogModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get foodId => throw _privateConstructorUsedError;
  String get mealPeriod => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  DateTime get loggedAt => throw _privateConstructorUsedError;
  bool get synced => throw _privateConstructorUsedError;

  /// Serializes this MealLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealLogModelCopyWith<MealLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealLogModelCopyWith<$Res> {
  factory $MealLogModelCopyWith(
          MealLogModel value, $Res Function(MealLogModel) then) =
      _$MealLogModelCopyWithImpl<$Res, MealLogModel>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String foodId,
      String mealPeriod,
      double quantity,
      String unit,
      DateTime loggedAt,
      bool synced});
}

/// @nodoc
class _$MealLogModelCopyWithImpl<$Res, $Val extends MealLogModel>
    implements $MealLogModelCopyWith<$Res> {
  _$MealLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? foodId = null,
    Object? mealPeriod = null,
    Object? quantity = null,
    Object? unit = null,
    Object? loggedAt = null,
    Object? synced = null,
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
      foodId: null == foodId
          ? _value.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      mealPeriod: null == mealPeriod
          ? _value.mealPeriod
          : mealPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MealLogModelImplCopyWith<$Res>
    implements $MealLogModelCopyWith<$Res> {
  factory _$$MealLogModelImplCopyWith(
          _$MealLogModelImpl value, $Res Function(_$MealLogModelImpl) then) =
      __$$MealLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String foodId,
      String mealPeriod,
      double quantity,
      String unit,
      DateTime loggedAt,
      bool synced});
}

/// @nodoc
class __$$MealLogModelImplCopyWithImpl<$Res>
    extends _$MealLogModelCopyWithImpl<$Res, _$MealLogModelImpl>
    implements _$$MealLogModelImplCopyWith<$Res> {
  __$$MealLogModelImplCopyWithImpl(
      _$MealLogModelImpl _value, $Res Function(_$MealLogModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? foodId = null,
    Object? mealPeriod = null,
    Object? quantity = null,
    Object? unit = null,
    Object? loggedAt = null,
    Object? synced = null,
  }) {
    return _then(_$MealLogModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      foodId: null == foodId
          ? _value.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      mealPeriod: null == mealPeriod
          ? _value.mealPeriod
          : mealPeriod // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      loggedAt: null == loggedAt
          ? _value.loggedAt
          : loggedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealLogModelImpl implements _MealLogModel {
  const _$MealLogModelImpl(
      {required this.id,
      required this.userId,
      required this.foodId,
      required this.mealPeriod,
      required this.quantity,
      required this.unit,
      required this.loggedAt,
      this.synced = false});

  factory _$MealLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealLogModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String foodId;
  @override
  final String mealPeriod;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final DateTime loggedAt;
  @override
  @JsonKey()
  final bool synced;

  @override
  String toString() {
    return 'MealLogModel(id: $id, userId: $userId, foodId: $foodId, mealPeriod: $mealPeriod, quantity: $quantity, unit: $unit, loggedAt: $loggedAt, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.mealPeriod, mealPeriod) ||
                other.mealPeriod == mealPeriod) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.loggedAt, loggedAt) ||
                other.loggedAt == loggedAt) &&
            (identical(other.synced, synced) || other.synced == synced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, foodId, mealPeriod,
      quantity, unit, loggedAt, synced);

  /// Create a copy of MealLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealLogModelImplCopyWith<_$MealLogModelImpl> get copyWith =>
      __$$MealLogModelImplCopyWithImpl<_$MealLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealLogModelImplToJson(
      this,
    );
  }
}

abstract class _MealLogModel implements MealLogModel {
  const factory _MealLogModel(
      {required final String id,
      required final String userId,
      required final String foodId,
      required final String mealPeriod,
      required final double quantity,
      required final String unit,
      required final DateTime loggedAt,
      final bool synced}) = _$MealLogModelImpl;

  factory _MealLogModel.fromJson(Map<String, dynamic> json) =
      _$MealLogModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get foodId;
  @override
  String get mealPeriod;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  DateTime get loggedAt;
  @override
  bool get synced;

  /// Create a copy of MealLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealLogModelImplCopyWith<_$MealLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
