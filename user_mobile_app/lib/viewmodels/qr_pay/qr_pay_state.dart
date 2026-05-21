import '../../../models/account/account_model.dart';
import '../../../models/transaction/transaction_model.dart';

class QrPayState {
  final bool isFlashOn;
  final AccountModel? selectedReceiveAccount;

  /// The real account looked up from backend after scanning/uploading a QR.
  final AccountModel? scannedTargetAccount;

  // Payment flow details
  final String? selectedVendor;
  final String? selectedTargetAccount;
  final double paymentAmount;
  final String? paymentDesc;
  final AccountModel? selectedSourceAccount;
  final String pin;
  final bool isPaying;
  final bool paySuccess;
  final TransactionModel? paymentTransaction;
  final String? errorMessage;
  final int wrongPinAttempts;
  final bool isLocked;

  const QrPayState({
    this.isFlashOn = false,
    this.selectedReceiveAccount,
    this.scannedTargetAccount,
    this.selectedVendor,
    this.selectedTargetAccount,
    this.paymentAmount = 0.0,
    this.paymentDesc,
    this.selectedSourceAccount,
    this.pin = '',
    this.isPaying = false,
    this.paySuccess = false,
    this.paymentTransaction,
    this.errorMessage,
    this.wrongPinAttempts = 0,
    this.isLocked = false,
  });

  QrPayState copyWith({
    bool? isFlashOn,
    AccountModel? selectedReceiveAccount,
    AccountModel? scannedTargetAccount,
    String? selectedVendor,
    String? selectedTargetAccount,
    double? paymentAmount,
    String? paymentDesc,
    AccountModel? selectedSourceAccount,
    String? pin,
    bool? isPaying,
    bool? paySuccess,
    TransactionModel? paymentTransaction,
    String? errorMessage,
    int? wrongPinAttempts,
    bool? isLocked,
  }) {
    return QrPayState(
      isFlashOn: isFlashOn ?? this.isFlashOn,
      selectedReceiveAccount:
          selectedReceiveAccount ?? this.selectedReceiveAccount,
      scannedTargetAccount: scannedTargetAccount ?? this.scannedTargetAccount,
      selectedVendor: selectedVendor ?? this.selectedVendor,
      selectedTargetAccount:
          selectedTargetAccount ?? this.selectedTargetAccount,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      paymentDesc: paymentDesc ?? this.paymentDesc,
      selectedSourceAccount:
          selectedSourceAccount ?? this.selectedSourceAccount,
      pin: pin ?? this.pin,
      isPaying: isPaying ?? this.isPaying,
      paySuccess: paySuccess ?? this.paySuccess,
      paymentTransaction: paymentTransaction ?? this.paymentTransaction,
      errorMessage: errorMessage, // Let it clear if passed null
      wrongPinAttempts: wrongPinAttempts ?? this.wrongPinAttempts,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}
