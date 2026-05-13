// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransactionHistoryState {
  List<TransactionModel> get transactions => throw _privateConstructorUsedError;
  List<AccountModel> get accounts => throw _privateConstructorUsedError;
  AccountModel? get selectedAccount => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get filterType => throw _privateConstructorUsedError;

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionHistoryStateCopyWith<TransactionHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionHistoryStateCopyWith<$Res> {
  factory $TransactionHistoryStateCopyWith(
    TransactionHistoryState value,
    $Res Function(TransactionHistoryState) then,
  ) = _$TransactionHistoryStateCopyWithImpl<$Res, TransactionHistoryState>;
  @useResult
  $Res call({
    List<TransactionModel> transactions,
    List<AccountModel> accounts,
    AccountModel? selectedAccount,
    bool isLoading,
    bool isLoadingMore,
    int currentPage,
    bool hasMore,
    String? errorMessage,
    String? filterType,
  });

  $AccountModelCopyWith<$Res>? get selectedAccount;
}

/// @nodoc
class _$TransactionHistoryStateCopyWithImpl<
  $Res,
  $Val extends TransactionHistoryState
>
    implements $TransactionHistoryStateCopyWith<$Res> {
  _$TransactionHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? accounts = null,
    Object? selectedAccount = freezed,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? currentPage = null,
    Object? hasMore = null,
    Object? errorMessage = freezed,
    Object? filterType = freezed,
  }) {
    return _then(
      _value.copyWith(
            transactions: null == transactions
                ? _value.transactions
                : transactions // ignore: cast_nullable_to_non_nullable
                      as List<TransactionModel>,
            accounts: null == accounts
                ? _value.accounts
                : accounts // ignore: cast_nullable_to_non_nullable
                      as List<AccountModel>,
            selectedAccount: freezed == selectedAccount
                ? _value.selectedAccount
                : selectedAccount // ignore: cast_nullable_to_non_nullable
                      as AccountModel?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoadingMore: null == isLoadingMore
                ? _value.isLoadingMore
                : isLoadingMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            filterType: freezed == filterType
                ? _value.filterType
                : filterType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of TransactionHistoryState
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
}

/// @nodoc
abstract class _$$TransactionHistoryStateImplCopyWith<$Res>
    implements $TransactionHistoryStateCopyWith<$Res> {
  factory _$$TransactionHistoryStateImplCopyWith(
    _$TransactionHistoryStateImpl value,
    $Res Function(_$TransactionHistoryStateImpl) then,
  ) = __$$TransactionHistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<TransactionModel> transactions,
    List<AccountModel> accounts,
    AccountModel? selectedAccount,
    bool isLoading,
    bool isLoadingMore,
    int currentPage,
    bool hasMore,
    String? errorMessage,
    String? filterType,
  });

  @override
  $AccountModelCopyWith<$Res>? get selectedAccount;
}

/// @nodoc
class __$$TransactionHistoryStateImplCopyWithImpl<$Res>
    extends
        _$TransactionHistoryStateCopyWithImpl<
          $Res,
          _$TransactionHistoryStateImpl
        >
    implements _$$TransactionHistoryStateImplCopyWith<$Res> {
  __$$TransactionHistoryStateImplCopyWithImpl(
    _$TransactionHistoryStateImpl _value,
    $Res Function(_$TransactionHistoryStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? accounts = null,
    Object? selectedAccount = freezed,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? currentPage = null,
    Object? hasMore = null,
    Object? errorMessage = freezed,
    Object? filterType = freezed,
  }) {
    return _then(
      _$TransactionHistoryStateImpl(
        transactions: null == transactions
            ? _value._transactions
            : transactions // ignore: cast_nullable_to_non_nullable
                  as List<TransactionModel>,
        accounts: null == accounts
            ? _value._accounts
            : accounts // ignore: cast_nullable_to_non_nullable
                  as List<AccountModel>,
        selectedAccount: freezed == selectedAccount
            ? _value.selectedAccount
            : selectedAccount // ignore: cast_nullable_to_non_nullable
                  as AccountModel?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        filterType: freezed == filterType
            ? _value.filterType
            : filterType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$TransactionHistoryStateImpl implements _TransactionHistoryState {
  const _$TransactionHistoryStateImpl({
    final List<TransactionModel> transactions = const [],
    final List<AccountModel> accounts = const [],
    this.selectedAccount,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.hasMore = true,
    this.errorMessage,
    this.filterType,
  }) : _transactions = transactions,
       _accounts = accounts;

  final List<TransactionModel> _transactions;
  @override
  @JsonKey()
  List<TransactionModel> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  final List<AccountModel> _accounts;
  @override
  @JsonKey()
  List<AccountModel> get accounts {
    if (_accounts is EqualUnmodifiableListView) return _accounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accounts);
  }

  @override
  final AccountModel? selectedAccount;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  final String? errorMessage;
  @override
  final String? filterType;

  @override
  String toString() {
    return 'TransactionHistoryState(transactions: $transactions, accounts: $accounts, selectedAccount: $selectedAccount, isLoading: $isLoading, isLoadingMore: $isLoadingMore, currentPage: $currentPage, hasMore: $hasMore, errorMessage: $errorMessage, filterType: $filterType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionHistoryStateImpl &&
            const DeepCollectionEquality().equals(
              other._transactions,
              _transactions,
            ) &&
            const DeepCollectionEquality().equals(other._accounts, _accounts) &&
            (identical(other.selectedAccount, selectedAccount) ||
                other.selectedAccount == selectedAccount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.filterType, filterType) ||
                other.filterType == filterType));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_transactions),
    const DeepCollectionEquality().hash(_accounts),
    selectedAccount,
    isLoading,
    isLoadingMore,
    currentPage,
    hasMore,
    errorMessage,
    filterType,
  );

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionHistoryStateImplCopyWith<_$TransactionHistoryStateImpl>
  get copyWith =>
      __$$TransactionHistoryStateImplCopyWithImpl<
        _$TransactionHistoryStateImpl
      >(this, _$identity);
}

abstract class _TransactionHistoryState implements TransactionHistoryState {
  const factory _TransactionHistoryState({
    final List<TransactionModel> transactions,
    final List<AccountModel> accounts,
    final AccountModel? selectedAccount,
    final bool isLoading,
    final bool isLoadingMore,
    final int currentPage,
    final bool hasMore,
    final String? errorMessage,
    final String? filterType,
  }) = _$TransactionHistoryStateImpl;

  @override
  List<TransactionModel> get transactions;
  @override
  List<AccountModel> get accounts;
  @override
  AccountModel? get selectedAccount;
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  int get currentPage;
  @override
  bool get hasMore;
  @override
  String? get errorMessage;
  @override
  String? get filterType;

  /// Create a copy of TransactionHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionHistoryStateImplCopyWith<_$TransactionHistoryStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
