import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../core/di/injection.dart';
import '../repositories/auth/auth_repository.dart';
import '../services/auth/auth_service.dart';
import '../services/account/account_service.dart';
import '../repositories/account/account_repository.dart';
import '../repositories/transaction/history/transaction_history_repository.dart';
import '../repositories/transaction/history/transaction_history_repository_impl.dart';
import '../repositories/transaction/deposit/deposit_repository.dart';
import '../repositories/transaction/deposit/deposit_repository_impl.dart';
import '../repositories/transaction/withdraw/withdraw_repository.dart';
import '../repositories/transaction/withdraw/withdraw_repository_impl.dart';
import '../services/storage_service.dart';
import '../services/realtime_event_service.dart';
import '../repositories/user/user_repository.dart';
import '../repositories/user/user_repository_impl.dart';
import '../repositories/notification/notification_repository.dart';
import '../repositories/notification/notification_repository_impl.dart';

// ViewModels
import '../viewmodels/auth/login/login_view_model.dart';
import '../viewmodels/auth/login/login_state.dart';
import '../viewmodels/auth/register/register_view_model.dart';
import '../viewmodels/auth/register/register_state.dart';
import '../viewmodels/auth/verify_otp/verify_otp_view_model.dart';
import '../viewmodels/auth/forgot_password/forgot_password_view_model.dart';
import '../viewmodels/auth/forgot_password/forgot_password_state.dart';
import '../viewmodels/auth/verify_otp/verify_otp_state.dart';
import '../repositories/transaction/transfer/transfer_repository.dart';
import '../repositories/transaction/transfer/transfer_repository_impl.dart';
import '../viewmodels/home/home_view_model.dart';
import '../viewmodels/home/home_state.dart';
import '../viewmodels/account/open_account_view_model.dart';
import '../viewmodels/account/open_account_state.dart';
import '../viewmodels/transaction/transfer/transfer_state.dart';
import '../viewmodels/transaction/transfer/transfer_view_model.dart';
import '../viewmodels/transaction/deposit/deposit_state.dart';
import '../viewmodels/transaction/deposit/deposit_view_model.dart';
import '../viewmodels/transaction/withdraw/withdraw_state.dart';
import '../viewmodels/transaction/withdraw/withdraw_view_model.dart';
import '../viewmodels/transaction/history/transaction_history_state.dart';
import '../viewmodels/transaction/history/transaction_history_view_model.dart';
import '../viewmodels/profile/profile_state.dart';
import '../viewmodels/profile/profile_view_model.dart';
import '../viewmodels/profile/security_state.dart';
import '../viewmodels/profile/security_view_model.dart';
import '../viewmodels/qr_pay/qr_pay_state.dart';
import '../viewmodels/qr_pay/qr_pay_view_model.dart';
import '../viewmodels/notification/notification_state.dart';
import '../viewmodels/notification/notification_view_model.dart';

// -- Infrastructure Providers --

final dioProvider = Provider<Dio>((ref) {
  return getIt<Dio>();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return getIt<StorageService>();
});

final realtimeEventServiceProvider = Provider<RealtimeEventService>((ref) {
  return getIt<RealtimeEventService>();
});

// -- Repository Providers --

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return getIt<IAuthRepository>();
});

// -- Service Providers --

final authServiceProvider = Provider<AuthService>((ref) {
  return getIt<AuthService>();
});

final accountRepositoryProvider = Provider<IAccountRepository>((ref) {
  return getIt<IAccountRepository>();
});

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(dioProvider));
});

final accountServiceProvider = Provider<AccountService>((ref) {
  return getIt<AccountService>();
});

final transactionHistoryRepositoryProvider =
    Provider<ITransactionHistoryRepository>((ref) {
      return TransactionHistoryRepositoryImpl(ref.watch(dioProvider));
    });

final depositRepositoryProvider = Provider<IDepositRepository>((ref) {
  return DepositRepositoryImpl(ref.watch(dioProvider));
});

final withdrawRepositoryProvider = Provider<IWithdrawRepository>((ref) {
  return WithdrawRepositoryImpl(ref.watch(dioProvider));
});

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(dioProvider));
});

// -- ViewModel Providers --

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>((ref) {
      return LoginViewModel(ref.watch(authServiceProvider));
    });

final registerViewModelProvider =
    StateNotifierProvider.autoDispose<RegisterViewModel, RegisterState>((ref) {
      return RegisterViewModel(ref.watch(authServiceProvider));
    });

final verifyOtpViewModelProvider =
    StateNotifierProvider<VerifyOtpViewModel, VerifyOtpState>((ref) {
      return VerifyOtpViewModel(ref.watch(authServiceProvider));
    });

final forgotPasswordViewModelProvider =
    StateNotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>((ref) {
      return ForgotPasswordViewModel(ref.watch(authServiceProvider));
    });

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
      return HomeViewModel(
        ref.watch(accountServiceProvider),
        ref.watch(storageServiceProvider),
        ref.watch(transactionHistoryRepositoryProvider),
      );
    });

final openAccountViewModelProvider =
    StateNotifierProvider<OpenAccountViewModel, OpenAccountState>((ref) {
      return OpenAccountViewModel(getIt<IAccountRepository>());
    });

final transferRepositoryProvider = Provider<ITransferRepository>((ref) {
  return TransferRepositoryImpl(ref.watch(dioProvider));
});

final transferViewModelProvider =
    StateNotifierProvider.autoDispose<TransferViewModel, TransferState>((ref) {
      return TransferViewModel(
        ref.watch(accountServiceProvider),
        ref.watch(transferRepositoryProvider),
      );
    });

final depositViewModelProvider =
    StateNotifierProvider.autoDispose<DepositViewModel, DepositState>((ref) {
      return DepositViewModel(
        ref.watch(accountServiceProvider),
        ref.watch(depositRepositoryProvider),
      );
    });

final withdrawViewModelProvider =
    StateNotifierProvider.autoDispose<WithdrawViewModel, WithdrawState>((ref) {
      return WithdrawViewModel(
        ref.watch(accountServiceProvider),
        ref.watch(withdrawRepositoryProvider),
      );
    });

final transactionHistoryViewModelProvider =
    StateNotifierProvider.autoDispose<
      TransactionHistoryViewModel,
      TransactionHistoryState
    >((ref) {
      return TransactionHistoryViewModel(
        ref.watch(transactionHistoryRepositoryProvider),
        ref.watch(accountServiceProvider),
      );
    });

final profileViewModelProvider =
    StateNotifierProvider.autoDispose<ProfileViewModel, ProfileState>((ref) {
      return ProfileViewModel(ref.watch(userRepositoryProvider));
    });

final securityViewModelProvider =
    StateNotifierProvider.autoDispose<SecurityViewModel, SecurityState>((ref) {
      return SecurityViewModel(ref.watch(userRepositoryProvider));
    });

final qrPayViewModelProvider =
    StateNotifierProvider.autoDispose<QrPayViewModel, QrPayState>((ref) {
      return QrPayViewModel(
        ref.watch(accountServiceProvider),
        ref.watch(transferRepositoryProvider),
      );
    });

final notificationViewModelProvider =
    StateNotifierProvider.autoDispose<NotificationViewModel, NotificationState>(
      (ref) {
        return NotificationViewModel(ref.watch(notificationRepositoryProvider));
      },
    );

final navigationIndexProvider = StateProvider<int>((ref) => 0);
