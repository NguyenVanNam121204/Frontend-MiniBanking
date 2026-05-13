// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransferState {
  List<AccountModel> get myAccounts => throw _privateConstructorUsedError;
  AccountModel? get selectedSourceAccount => throw _privateConstructorUsedError;
  AccountModel? get recipientAccount => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get pin => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSearchingRecipient => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  TransactionModel? get successTransaction =>
      throw _privateConstructorUsedError;
  int get currentStep =>
      throw _privateConstructorUsedError; // 1: Input Info, 2: Confirm, 3: PIN, 4: Success
  int get wrongPinAttempts => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferStateCopyWith<TransferState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferStateCopyWith<$Res> {
  factory $TransferStateCopyWith(
    TransferState value,
    $Res Function(TransferState) then,
  ) = _$TransferStateCopyWithImpl<$Res, TransferState>;
  @useResult
  $Res call({
    List<AccountModel> myAccounts,
    AccountModel? selectedSourceAccount,
    AccountModel? recipientAccount,
    double amount,
    String description,
    String pin,
    bool isLoading,
    bool isSearchingRecipient,
    String? errorMessage,
    TransactionModel? successTransaction,
    int currentStep,
    int wrongPinAttempts,
    bool isLocked,
  });

  $AccountModelCopyWith<$Res>? get selectedSourceAccount;
  $AccountModelCopyWith<$Res>? get recipientAccount;
  $TransactionModelCopyWith<$Res>? get successTransaction;
}

/// @nodoc
class _$TransferStateCopyWithImpl<$Res, $Val extends TransferState>
    implements $TransferStateCopyWith<$Res> {
  _$TransferStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myAccounts = null,
    Object? selectedSourceAccount = freezed,
    Object? recipientAccount = freezed,
    Object? amount = null,
    Object? description = null,
    Object? pin = null,
    Object? isLoading = null,
    Object? isSearchingRecipient = null,
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
            selectedSourceAccount: freezed == selectedSourceAccount
                ? _value.selectedSourceAccount
                : selectedSourceAccount // ignore: cast_nullable_to_non_nullable
                      as AccountModel?,
            recipientAccount: freezed == recipientAccount
                ? _value.recipientAccount
                : recipientAccount // ignore: cast_nullable_to_non_nullable
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
            isSearchingRecipient: null == isSearchingRecipient
                ? _value.isSearchingRecipient
                : isSearchingRecipient // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountModelCopyWith<$Res>? get selectedSourceAccount {
    if (_value.selectedSourceAccount == null) {
      return null;
    }

    return $AccountModelCopyWith<$Res>(_value.selectedSourceAccount!, (value) {
      return _then(_value.copyWith(selectedSourceAccount: value) as $Val);
    });
  }

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountModelCopyWith<$Res>? get recipientAccount {
    if (_value.recipientAccount == null) {
      return null;
    }

    return $AccountModelCopyWith<$Res>(_value.recipientAccount!, (value) {
      return _then(_value.copyWith(recipientAccount: value) as $Val);
    });
  }

  /// Create a copy of TransferState
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
abstract class _$$TransferStateImplCopyWith<$Res>
    implements $TransferStateCopyWith<$Res> {
  factory _$$TransferStateImplCopyWith(
    _$TransferStateImpl value,
    $Res Function(_$TransferStateImpl) then,
  ) = __$$TransferStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<AccountModel> myAccounts,
    AccountModel? selectedSourceAccount,
    AccountModel? recipientAccount,
    double amount,
    String description,
    String pin,
    bool isLoading,
    bool isSearchingRecipient,
    String? errorMessage,
    TransactionModel? successTransaction,
    int currentStep,
    int wrongPinAttempts,
    bool isLocked,
  });

  @override
  $AccountModelCopyWith<$Res>? get selectedSourceAccount;
  @override
  $AccountModelCopyWith<$Res>? get recipientAccount;
  @override
  $TransactionModelCopyWith<$Res>? get successTransaction;
}

/// @nodoc
class __$$TransferStateImplCopyWithImpl<$Res>
    extends _$TransferStateCopyWithImpl<$Res, _$TransferStateImpl>
    implements _$$TransferStateImplCopyWith<$Res> {
  __$$TransferStateImplCopyWithImpl(
    _$TransferStateImpl _value,
    $Res Function(_$TransferStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? myAccounts = null,
    Object? selectedSourceAccount = freezed,
    Object? recipientAccount = freezed,
    Object? amount = null,
    Object? description = null,
    Object? pin = null,
    Object? isLoading = null,
    Object? isSearchingRecipient = null,
    Object? errorMessage = freezed,
    Object? successTransaction = freezed,
    Object? currentStep = null,
    Object? wrongPinAttempts = null,
    Object? isLocked = null,
  }) {
    return _then(
      _$TransferStateImpl(
        myAccounts: null == myAccounts
            ? _value._myAccounts
            : myAccounts // ignore: cast_nullable_to_non_nullable
                  as List<AccountModel>,
        selectedSourceAccount: freezed == selectedSourceAccount
            ? _value.selectedSourceAccount
            : selectedSourceAccount // ignore: cast_nullable_to_non_nullable
                  as AccountModel?,
        recipientAccount: freezed == recipientAccount
            ? _value.recipientAccount
            : recipientAccount // ignore: cast_nullable_to_non_nullable
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
        isSearchingRecipient: null == isSearchingRecipient
            ? _value.isSearchingRecipient
            : isSearchingRecipient // ignore: cast_nullable_to_non_nullable
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

class _$TransferStateImpl implements _TransferState {
  const _$TransferStateImpl({
    final List<AccountModel> myAccounts = const [],
    this.selectedSourceAccount,
    this.recipientAccount,
    this.amount = 0.0,
    this.description = 'Chuyển tiền',
    this.pin = '',
    this.isLoading = false,
    this.isSearchingRecipient = false,
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
  final AccountModel? selectedSourceAccount;
  @override
  final AccountModel? recipientAccount;
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
  @JsonKey()
  final bool isSearchingRecipient;
  @override
  final String? errorMessage;
  @override
  final TransactionModel? successTransaction;
  @override
  @JsonKey()
  final int currentStep;
  // 1: Input Info, 2: Confirm, 3: PIN, 4: Success
  @override
  @JsonKey()
  final int wrongPinAttempts;
  @override
  @JsonKey()
  final bool isLocked;

  @override
  String toString() {
    return 'TransferState(myAccounts: $myAccounts, selectedSourceAccount: $selectedSourceAccount, recipientAccount: $recipientAccount, amount: $amount, description: $description, pin: $pin, isLoading: $isLoading, isSearchingRecipient: $isSearchingRecipient, errorMessage: $errorMessage, successTransaction: $successTransaction, currentStep: $currentStep, wrongPinAttempts: $wrongPinAttempts, isLocked: $isLocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferStateImpl &&
            const DeepCollectionEquality().equals(
              other._myAccounts,
              _myAccounts,
            ) &&
            (identical(other.selectedSourceAccount, selectedSourceAccount) ||
                other.selectedSourceAccount == selectedSourceAccount) &&
            (identical(other.recipientAccount, recipientAccount) ||
                other.recipientAccount == recipientAccount) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSearchingRecipient, isSearchingRecipient) ||
                other.isSearchingRecipient == isSearchingRecipient) &&
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
    selectedSourceAccount,
    recipientAccount,
    amount,
    description,
    pin,
    isLoading,
    isSearchingRecipient,
    errorMessage,
    successTransaction,
    currentStep,
    wrongPinAttempts,
    isLocked,
  );

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferStateImplCopyWith<_$TransferStateImpl> get copyWith =>
      __$$TransferStateImplCopyWithImpl<_$TransferStateImpl>(this, _$identity);
}

abstract class _TransferState implements TransferState {
  const factory _TransferState({
    final List<AccountModel> myAccounts,
    final AccountModel? selectedSourceAccount,
    final AccountModel? recipientAccount,
    final double amount,
    final String description,
    final String pin,
    final bool isLoading,
    final bool isSearchingRecipient,
    final String? errorMessage,
    final TransactionModel? successTransaction,
    final int currentStep,
    final int wrongPinAttempts,
    final bool isLocked,
  }) = _$TransferStateImpl;

  @override
  List<AccountModel> get myAccounts;
  @override
  AccountModel? get selectedSourceAccount;
  @override
  AccountModel? get recipientAccount;
  @override
  double get amount;
  @override
  String get description;
  @override
  String get pin;
  @override
  bool get isLoading;
  @override
  bool get isSearchingRecipient;
  @override
  String? get errorMessage;
  @override
  TransactionModel? get successTransaction;
  @override
  int get currentStep; // 1: Input Info, 2: Confirm, 3: PIN, 4: Success
  @override
  int get wrongPinAttempts;
  @override
  bool get isLocked;

  /// Create a copy of TransferState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferStateImplCopyWith<_$TransferStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
