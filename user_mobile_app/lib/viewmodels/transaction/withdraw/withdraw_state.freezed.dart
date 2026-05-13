// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'withdraw_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WithdrawState {
  List<AccountModel> get myAccounts => throw _privateConstructorUsedError;
  AccountModel? get selectedAccount => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get pin => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  TransactionModel? get successTransaction =>
      throw _privateConstructorUsedError;
  int get currentStep =>
      throw _privateConstructorUsedError; // 1: Input, 2: Confirm, 3: PIN, 4: Success
  int get wrongPinAttempts => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;

  /// Create a copy of WithdrawState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WithdrawStateCopyWith<WithdrawState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WithdrawStateCopyWith<$Res> {
  factory $WithdrawStateCopyWith(
    WithdrawState value,
    $Res Function(WithdrawState) then,
  ) = _$WithdrawStateCopyWithImpl<$Res, WithdrawState>;
  @useResult
  $Res call({
    List<AccountModel> myAccounts,
    AccountModel? selectedAccount,
    double amount,
    String description,
    String pin,
    bool isLoading,
    String? errorMessage,
    TransactionModel? successTransaction,
    int currentStep,
    int wrongPinAttempts,
    bool isLocked,
  });

  $AccountModelCopyWith<$Res>? get selectedAccount;
  $TransactionModelCopyWith<$Res>? get successTransaction;
}

/// @nodoc
class _$WithdrawStateCopyWithImpl<$Res, $Val extends WithdrawState>
    implements $WithdrawStateCopyWith<$Res> {
  _$WithdrawStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WithdrawState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myAccounts = null,
    Object? selectedAccount = freezed,
    Object? amount = null,
    Object? description = null,
    Object? pin = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? successTransaction = freezed,
    Object? currentStep = null,
    Object? wrongPinAttempts = null,
    Object? isLocked = null,
  }) {
    return _then(
      _value.copyWith(
            myAccounts: null == myAccounts
                ? _value.myAccounts
                : myAccounts // ignore: cast_nullable_to_non_nullable
                      as List<AccountModel>,
            selectedAccount: freezed == selectedAccount
                ? _value.selectedAccount
                : selectedAccount // ignore: cast_nullable_to_non_nullable
                      as AccountModel?,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            pin: null == pin
                ? _value.pin
                : pin // ignore: cast_nullable_to_non_nullable
                      as String,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            successTransaction: freezed == successTransaction
                ? _value.successTransaction
                : successTransaction // ignore: cast_nullable_to_non_nullable
                      as TransactionModel?,
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            wrongPinAttempts: null == wrongPinAttempts
                ? _value.wrongPinAttempts
                : wrongPinAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            isLocked: null == isLocked
                ? _value.isLocked
                : isLocked // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of WithdrawState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountModelCopyWith<$Res>? get selectedAccount {
    if (_value.selectedAccount == null) {
      return null;
    }

    return $AccountModelCopyWith<$Res>(_value.selectedAccount!, (value) {
      return _then(_value.copyWith(selectedAccount: value) as $Val);
    });
  }

  /// Create a copy of WithdrawState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionModelCopyWith<$Res>? get successTransaction {
    if (_value.successTransaction == null) {
      return null;
    }

    return $TransactionModelCopyWith<$Res>(_value.successTransaction!, (value) {
      return _then(_value.copyWith(successTransaction: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WithdrawStateImplCopyWith<$Res>
    implements $WithdrawStateCopyWith<$Res> {
  factory _$$WithdrawStateImplCopyWith(
    _$WithdrawStateImpl value,
    $Res Function(_$WithdrawStateImpl) then,
  ) = __$$WithdrawStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<AccountModel> myAccounts,
    AccountModel? selectedAccount,
    double amount,
    String description,
    String pin,
    bool isLoading,
    String? errorMessage,
    TransactionModel? successTransaction,
    int currentStep,
    int wrongPinAttempts,
    bool isLocked,
  });

  @override
  $AccountModelCopyWith<$Res>? get selectedAccount;
  @override
  $TransactionModelCopyWith<$Res>? get successTransaction;
}

/// @nodoc
class __$$WithdrawStateImplCopyWithImpl<$Res>
    extends _$WithdrawStateCopyWithImpl<$Res, _$WithdrawStateImpl>
    implements _$$WithdrawStateImplCopyWith<$Res> {
  __$$WithdrawStateImplCopyWithImpl(
    _$WithdrawStateImpl _value,
    $Res Function(_$WithdrawStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WithdrawState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myAccounts = null,
    Object? selectedAccount = freezed,
    Object? amount = null,
    Object? description = null,
    Object? pin = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? successTransaction = freezed,
    Object? currentStep = null,
    Object? wrongPinAttempts = null,
    Object? isLocked = null,
  }) {
    return _then(
      _$WithdrawStateImpl(
        myAccounts: null == myAccounts
            ? _value._myAccounts
            : myAccounts // ignore: cast_nullable_to_non_nullable
                  as List<AccountModel>,
        selectedAccount: freezed == selectedAccount
            ? _value.selectedAccount
            : selectedAccount // ignore: cast_nullable_to_non_nullable
                  as AccountModel?,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        pin: null == pin
            ? _value.pin
            : pin // ignore: cast_nullable_to_non_nullable
                  as String,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        successTransaction: freezed == successTransaction
            ? _value.successTransaction
            : successTransaction // ignore: cast_nullable_to_non_nullable
                  as TransactionModel?,
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        wrongPinAttempts: null == wrongPinAttempts
            ? _value.wrongPinAttempts
            : wrongPinAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        isLocked: null == isLocked
            ? _value.isLocked
            : isLocked // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$WithdrawStateImpl implements _WithdrawState {
  const _$WithdrawStateImpl({
    final List<AccountModel> myAccounts = const [],
    this.selectedAccount,
    this.amount = 0.0,
    this.description = 'Rút tiền từ tài khoản',
    this.pin = '',
    this.isLoading = false,
    this.errorMessage,
    this.successTransaction,
    this.currentStep = 1,
    this.wrongPinAttempts = 0,
    this.isLocked = false,
  }) : _myAccounts = myAccounts;

  final List<AccountModel> _myAccounts;
  @override
  @JsonKey()
  List<AccountModel> get myAccounts {
    if (_myAccounts is EqualUnmodifiableListView) return _myAccounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myAccounts);
  }

  @override
  final AccountModel? selectedAccount;
  @override
  @JsonKey()
  final double amount;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String pin;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final TransactionModel? successTransaction;
  @override
  @JsonKey()
  final int currentStep;
  // 1: Input, 2: Confirm, 3: PIN, 4: Success
  @override
  @JsonKey()
  final int wrongPinAttempts;
  @override
  @JsonKey()
  final bool isLocked;

  @override
  String toString() {
    return 'WithdrawState(myAccounts: $myAccounts, selectedAccount: $selectedAccount, amount: $amount, description: $description, pin: $pin, isLoading: $isLoading, errorMessage: $errorMessage, successTransaction: $successTransaction, currentStep: $currentStep, wrongPinAttempts: $wrongPinAttempts, isLocked: $isLocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WithdrawStateImpl &&
            const DeepCollectionEquality().equals(
              other._myAccounts,
              _myAccounts,
            ) &&
            (identical(other.selectedAccount, selectedAccount) ||
                other.selectedAccount == selectedAccount) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.successTransaction, successTransaction) ||
                other.successTransaction == successTransaction) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.wrongPinAttempts, wrongPinAttempts) ||
                other.wrongPinAttempts == wrongPinAttempts) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_myAccounts),
    selectedAccount,
    amount,
    description,
    pin,
    isLoading,
    errorMessage,
    successTransaction,
    currentStep,
    wrongPinAttempts,
    isLocked,
  );

  /// Create a copy of WithdrawState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WithdrawStateImplCopyWith<_$WithdrawStateImpl> get copyWith =>
      __$$WithdrawStateImplCopyWithImpl<_$WithdrawStateImpl>(this, _$identity);
}

abstract class _WithdrawState implements WithdrawState {
  const factory _WithdrawState({
    final List<AccountModel> myAccounts,
    final AccountModel? selectedAccount,
    final double amount,
    final String description,
    final String pin,
    final bool isLoading,
    final String? errorMessage,
    final TransactionModel? successTransaction,
    final int currentStep,
    final int wrongPinAttempts,
    final bool isLocked,
  }) = _$WithdrawStateImpl;

  @override
  List<AccountModel> get myAccounts;
  @override
  AccountModel? get selectedAccount;
  @override
  double get amount;
  @override
  String get description;
  @override
  String get pin;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  TransactionModel? get successTransaction;
  @override
  int get currentStep; // 1: Input, 2: Confirm, 3: PIN, 4: Success
  @override
  int get wrongPinAttempts;
  @override
  bool get isLocked;

  /// Create a copy of WithdrawState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WithdrawStateImplCopyWith<_$WithdrawStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
