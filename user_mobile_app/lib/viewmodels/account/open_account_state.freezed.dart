// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_account_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OpenAccountState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  AccountModel? get createdAccount => throw _privateConstructorUsedError;

  /// Create a copy of OpenAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpenAccountStateCopyWith<OpenAccountState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpenAccountStateCopyWith<$Res> {
  factory $OpenAccountStateCopyWith(
    OpenAccountState value,
    $Res Function(OpenAccountState) then,
  ) = _$OpenAccountStateCopyWithImpl<$Res, OpenAccountState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isSuccess,
    String? errorMessage,
    AccountModel? createdAccount,
  });

  $AccountModelCopyWith<$Res>? get createdAccount;
}

/// @nodoc
class _$OpenAccountStateCopyWithImpl<$Res, $Val extends OpenAccountState>
    implements $OpenAccountStateCopyWith<$Res> {
  _$OpenAccountStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpenAccountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? errorMessage = freezed,
    Object? createdAccount = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAccount: freezed == createdAccount
                ? _value.createdAccount
                : createdAccount // ignore: cast_nullable_to_non_nullable
                      as AccountModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of OpenAccountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountModelCopyWith<$Res>? get createdAccount {
    if (_value.createdAccount == null) {
      return null;
    }

    return $AccountModelCopyWith<$Res>(_value.createdAccount!, (value) {
      return _then(_value.copyWith(createdAccount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OpenAccountStateImplCopyWith<$Res>
    implements $OpenAccountStateCopyWith<$Res> {
  factory _$$OpenAccountStateImplCopyWith(
    _$OpenAccountStateImpl value,
    $Res Function(_$OpenAccountStateImpl) then,
  ) = __$$OpenAccountStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isSuccess,
    String? errorMessage,
    AccountModel? createdAccount,
  });

  @override
  $AccountModelCopyWith<$Res>? get createdAccount;
}

/// @nodoc
class __$$OpenAccountStateImplCopyWithImpl<$Res>
    extends _$OpenAccountStateCopyWithImpl<$Res, _$OpenAccountStateImpl>
    implements _$$OpenAccountStateImplCopyWith<$Res> {
  __$$OpenAccountStateImplCopyWithImpl(
    _$OpenAccountStateImpl _value,
    $Res Function(_$OpenAccountStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OpenAccountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isSuccess = null,
    Object? errorMessage = freezed,
    Object? createdAccount = freezed,
  }) {
    return _then(
      _$OpenAccountStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAccount: freezed == createdAccount
            ? _value.createdAccount
            : createdAccount // ignore: cast_nullable_to_non_nullable
                  as AccountModel?,
      ),
    );
  }
}

/// @nodoc

class _$OpenAccountStateImpl implements _OpenAccountState {
  const _$OpenAccountStateImpl({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.createdAccount,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSuccess;
  @override
  final String? errorMessage;
  @override
  final AccountModel? createdAccount;

  @override
  String toString() {
    return 'OpenAccountState(isLoading: $isLoading, isSuccess: $isSuccess, errorMessage: $errorMessage, createdAccount: $createdAccount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpenAccountStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.createdAccount, createdAccount) ||
                other.createdAccount == createdAccount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    isSuccess,
    errorMessage,
    createdAccount,
  );

  /// Create a copy of OpenAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpenAccountStateImplCopyWith<_$OpenAccountStateImpl> get copyWith =>
      __$$OpenAccountStateImplCopyWithImpl<_$OpenAccountStateImpl>(
        this,
        _$identity,
      );
}

abstract class _OpenAccountState implements OpenAccountState {
  const factory _OpenAccountState({
    final bool isLoading,
    final bool isSuccess,
    final String? errorMessage,
    final AccountModel? createdAccount,
  }) = _$OpenAccountStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isSuccess;
  @override
  String? get errorMessage;
  @override
  AccountModel? get createdAccount;

  /// Create a copy of OpenAccountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpenAccountStateImplCopyWith<_$OpenAccountStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
