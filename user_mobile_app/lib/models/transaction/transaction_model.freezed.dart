// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) {
  return _TransactionModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionModel {
  int get id => throw _privateConstructorUsedError;
  String get referenceNumber => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  TransactionStatus get status => throw _privateConstructorUsedError;
  int? get fromAccountId => throw _privateConstructorUsedError;
  String? get fromAccountNumber => throw _privateConstructorUsedError;
  String? get fromAccountOwner => throw _privateConstructorUsedError;
  int? get toAccountId => throw _privateConstructorUsedError;
  String? get toAccountNumber => throw _privateConstructorUsedError;
  String? get toAccountOwner => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionModelCopyWith<TransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionModelCopyWith<$Res> {
  factory $TransactionModelCopyWith(
    TransactionModel value,
    $Res Function(TransactionModel) then,
  ) = _$TransactionModelCopyWithImpl<$Res, TransactionModel>;
  @useResult
  $Res call({
    int id,
    String referenceNumber,
    TransactionType type,
    double amount,
    TransactionStatus status,
    int? fromAccountId,
    String? fromAccountNumber,
    String? fromAccountOwner,
    int? toAccountId,
    String? toAccountNumber,
    String? toAccountOwner,
    String? description,
    DateTime createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$TransactionModelCopyWithImpl<$Res, $Val extends TransactionModel>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNumber = null,
    Object? type = null,
    Object? amount = null,
    Object? status = null,
    Object? fromAccountId = freezed,
    Object? fromAccountNumber = freezed,
    Object? fromAccountOwner = freezed,
    Object? toAccountId = freezed,
    Object? toAccountNumber = freezed,
    Object? toAccountOwner = freezed,
    Object? description = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            referenceNumber: null == referenceNumber
                ? _value.referenceNumber
                : referenceNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TransactionStatus,
            fromAccountId: freezed == fromAccountId
                ? _value.fromAccountId
                : fromAccountId // ignore: cast_nullable_to_non_nullable
                      as int?,
            fromAccountNumber: freezed == fromAccountNumber
                ? _value.fromAccountNumber
                : fromAccountNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            fromAccountOwner: freezed == fromAccountOwner
                ? _value.fromAccountOwner
                : fromAccountOwner // ignore: cast_nullable_to_non_nullable
                      as String?,
            toAccountId: freezed == toAccountId
                ? _value.toAccountId
                : toAccountId // ignore: cast_nullable_to_non_nullable
                      as int?,
            toAccountNumber: freezed == toAccountNumber
                ? _value.toAccountNumber
                : toAccountNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            toAccountOwner: freezed == toAccountOwner
                ? _value.toAccountOwner
                : toAccountOwner // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionModelImplCopyWith<$Res>
    implements $TransactionModelCopyWith<$Res> {
  factory _$$TransactionModelImplCopyWith(
    _$TransactionModelImpl value,
    $Res Function(_$TransactionModelImpl) then,
  ) = __$$TransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String referenceNumber,
    TransactionType type,
    double amount,
    TransactionStatus status,
    int? fromAccountId,
    String? fromAccountNumber,
    String? fromAccountOwner,
    int? toAccountId,
    String? toAccountNumber,
    String? toAccountOwner,
    String? description,
    DateTime createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$TransactionModelImplCopyWithImpl<$Res>
    extends _$TransactionModelCopyWithImpl<$Res, _$TransactionModelImpl>
    implements _$$TransactionModelImplCopyWith<$Res> {
  __$$TransactionModelImplCopyWithImpl(
    _$TransactionModelImpl _value,
    $Res Function(_$TransactionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNumber = null,
    Object? type = null,
    Object? amount = null,
    Object? status = null,
    Object? fromAccountId = freezed,
    Object? fromAccountNumber = freezed,
    Object? fromAccountOwner = freezed,
    Object? toAccountId = freezed,
    Object? toAccountNumber = freezed,
    Object? toAccountOwner = freezed,
    Object? description = freezed,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$TransactionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        referenceNumber: null == referenceNumber
            ? _value.referenceNumber
            : referenceNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TransactionStatus,
        fromAccountId: freezed == fromAccountId
            ? _value.fromAccountId
            : fromAccountId // ignore: cast_nullable_to_non_nullable
                  as int?,
        fromAccountNumber: freezed == fromAccountNumber
            ? _value.fromAccountNumber
            : fromAccountNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        fromAccountOwner: freezed == fromAccountOwner
            ? _value.fromAccountOwner
            : fromAccountOwner // ignore: cast_nullable_to_non_nullable
                  as String?,
        toAccountId: freezed == toAccountId
            ? _value.toAccountId
            : toAccountId // ignore: cast_nullable_to_non_nullable
                  as int?,
        toAccountNumber: freezed == toAccountNumber
            ? _value.toAccountNumber
            : toAccountNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        toAccountOwner: freezed == toAccountOwner
            ? _value.toAccountOwner
            : toAccountOwner // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionModelImpl implements _TransactionModel {
  const _$TransactionModelImpl({
    required this.id,
    required this.referenceNumber,
    required this.type,
    required this.amount,
    required this.status,
    this.fromAccountId,
    this.fromAccountNumber,
    this.fromAccountOwner,
    this.toAccountId,
    this.toAccountNumber,
    this.toAccountOwner,
    this.description,
    required this.createdAt,
    this.completedAt,
  });

  factory _$TransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionModelImplFromJson(json);

  @override
  final int id;
  @override
  final String referenceNumber;
  @override
  final TransactionType type;
  @override
  final double amount;
  @override
  final TransactionStatus status;
  @override
  final int? fromAccountId;
  @override
  final String? fromAccountNumber;
  @override
  final String? fromAccountOwner;
  @override
  final int? toAccountId;
  @override
  final String? toAccountNumber;
  @override
  final String? toAccountOwner;
  @override
  final String? description;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'TransactionModel(id: $id, referenceNumber: $referenceNumber, type: $type, amount: $amount, status: $status, fromAccountId: $fromAccountId, fromAccountNumber: $fromAccountNumber, fromAccountOwner: $fromAccountOwner, toAccountId: $toAccountId, toAccountNumber: $toAccountNumber, toAccountOwner: $toAccountOwner, description: $description, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.fromAccountId, fromAccountId) ||
                other.fromAccountId == fromAccountId) &&
            (identical(other.fromAccountNumber, fromAccountNumber) ||
                other.fromAccountNumber == fromAccountNumber) &&
            (identical(other.fromAccountOwner, fromAccountOwner) ||
                other.fromAccountOwner == fromAccountOwner) &&
            (identical(other.toAccountId, toAccountId) ||
                other.toAccountId == toAccountId) &&
            (identical(other.toAccountNumber, toAccountNumber) ||
                other.toAccountNumber == toAccountNumber) &&
            (identical(other.toAccountOwner, toAccountOwner) ||
                other.toAccountOwner == toAccountOwner) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    referenceNumber,
    type,
    amount,
    status,
    fromAccountId,
    fromAccountNumber,
    fromAccountOwner,
    toAccountId,
    toAccountNumber,
    toAccountOwner,
    description,
    createdAt,
    completedAt,
  );

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      __$$TransactionModelImplCopyWithImpl<_$TransactionModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionModelImplToJson(this);
  }
}

abstract class _TransactionModel implements TransactionModel {
  const factory _TransactionModel({
    required final int id,
    required final String referenceNumber,
    required final TransactionType type,
    required final double amount,
    required final TransactionStatus status,
    final int? fromAccountId,
    final String? fromAccountNumber,
    final String? fromAccountOwner,
    final int? toAccountId,
    final String? toAccountNumber,
    final String? toAccountOwner,
    final String? description,
    required final DateTime createdAt,
    final DateTime? completedAt,
  }) = _$TransactionModelImpl;

  factory _TransactionModel.fromJson(Map<String, dynamic> json) =
      _$TransactionModelImpl.fromJson;

  @override
  int get id;
  @override
  String get referenceNumber;
  @override
  TransactionType get type;
  @override
  double get amount;
  @override
  TransactionStatus get status;
  @override
  int? get fromAccountId;
  @override
  String? get fromAccountNumber;
  @override
  String? get fromAccountOwner;
  @override
  int? get toAccountId;
  @override
  String? get toAccountNumber;
  @override
  String? get toAccountOwner;
  @override
  String? get description;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of TransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionModelImplCopyWith<_$TransactionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
