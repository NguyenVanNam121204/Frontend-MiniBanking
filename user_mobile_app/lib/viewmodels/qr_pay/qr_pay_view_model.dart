import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/account/account_service.dart';
import '../../../repositories/transaction/transfer/transfer_repository.dart';
import '../../../models/account/account_model.dart';
import 'qr_pay_state.dart';

class QrPayViewModel extends StateNotifier<QrPayState> {
  final AccountService _accountService;
  final ITransferRepository _transferRepository;

  QrPayViewModel(this._accountService, this._transferRepository)
    : super(const QrPayState());

  Future<void> init() async {
    try {
      final accounts = await _accountService.getMyAccounts();
      state = state.copyWith(
        selectedReceiveAccount: accounts.isNotEmpty ? accounts.first : null,
        selectedSourceAccount: accounts.isNotEmpty ? accounts.first : null,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void toggleFlash() {
    state = state.copyWith(isFlashOn: !state.isFlashOn);
  }

  void selectReceiveAccount(AccountModel account) {
    state = state.copyWith(selectedReceiveAccount: account);
  }

  void selectSourceAccount(AccountModel account) {
    state = state.copyWith(selectedSourceAccount: account);
  }

  void resetPaymentState() {
    state = state.copyWith(
      scannedTargetAccount: null,
      selectedVendor: null,
      selectedTargetAccount: null,
      paymentAmount: 0.0,
      paymentDesc: null,
      pin: '',
      isPaying: false,
      paySuccess: false,
      paymentTransaction: null,
      errorMessage: null,
    );
  }

  void clearScannedAccount() {
    state = state.copyWith(scannedTargetAccount: null, errorMessage: null);
  }

  Future<void> startPaymentFromInput({
    required double amount,
    required String desc,
  }) async {
    final target = state.scannedTargetAccount;
    if (target == null) return;

    final sourceAccount = state.selectedSourceAccount;
    if (sourceAccount == null) {
      state = state.copyWith(errorMessage: 'Vui lòng chọn tài khoản nguồn.');
      return;
    }

    if (_isSameAccount(sourceAccount.accountNumber, target.accountNumber)) {
      state = state.copyWith(
        errorMessage: 'Không được chuyển tiền vào chính tài khoản của bạn.',
      );
      return;
    }

    await startPaymentFlow(
      vendor: target.ownerName?.toUpperCase() ?? 'KHACH HANG',
      targetAccount: target.accountNumber,
      amount: amount,
      desc: desc.trim().isEmpty ? 'Chuyen tien QR Pay' : desc.trim(),
    );
  }

  Future<void> startPaymentFlow({
    required String vendor,
    required String targetAccount,
    required double amount,
    required String desc,
  }) async {
    state = state.copyWith(
      selectedVendor: vendor,
      selectedTargetAccount: targetAccount,
      paymentAmount: amount,
      paymentDesc: desc,
      pin: '',
      isPaying: false,
      paySuccess: false,
      paymentTransaction: null,
      errorMessage: null,
    );
  }

  Future<bool> handleScannedCode(String code) async {
    state = state.copyWith(isPaying: true, errorMessage: null);
    try {
      final cleanCode = code.trim();
      final targetAccount = await _accountService.searchAccount(cleanCode);

      state = state.copyWith(
        isPaying: false,
        scannedTargetAccount: targetAccount,
      );
      return true;
    } catch (e) {
      String errorMsg = e
          .toString()
          .replaceFirst(RegExp(r'^Exception: '), '')
          .replaceFirst(RegExp(r'^error: '), '')
          .replaceFirst(RegExp(r'^DioException.*: '), '');
      if (errorMsg.toLowerCase().contains('unexpected error')) {
        errorMsg =
            'Không tìm thấy tài khoản từ mã QR này. Vui lòng kiểm tra mã QR có được tạo từ ứng dụng và tài khoản nhận còn hoạt động.';
      }
      state = state.copyWith(
        isPaying: false,
        errorMessage: errorMsg.trim().isNotEmpty
            ? errorMsg.trim()
            : 'Mã QR không hợp lệ hoặc không tồn tại.',
      );
      return false;
    }
  }

  void updatePin(String digit) {
    if (state.isLocked) return;
    if (state.pin.length < 6) {
      final newPin = state.pin + digit;
      state = state.copyWith(pin: newPin, errorMessage: null);
      if (newPin.length == 6) {
        performPayment();
      }
    }
  }

  void deleteLastPin() {
    if (state.pin.isNotEmpty) {
      state = state.copyWith(pin: state.pin.substring(0, state.pin.length - 1));
    }
  }

  Future<void> performPayment() async {
    if (state.selectedSourceAccount == null ||
        state.selectedTargetAccount == null) {
      return;
    }

    final cleanTargetNumber = state.selectedTargetAccount!.split(' ').first;
    if (_isSameAccount(
      state.selectedSourceAccount!.accountNumber,
      cleanTargetNumber,
    )) {
      state = state.copyWith(
        isPaying: false,
        errorMessage: 'Không được chuyển tiền vào chính tài khoản của bạn.',
        pin: '',
      );
      return;
    }

    state = state.copyWith(isPaying: true, errorMessage: null);

    try {
      final transaction = await _transferRepository.transfer(
        fromAccountNumber: state.selectedSourceAccount!.accountNumber,
        toAccountNumber: cleanTargetNumber,
        amount: state.paymentAmount,
        description: state.paymentDesc ?? 'Chuyen tien QR Pay',
        pin: state.pin,
      );

      state = state.copyWith(
        isPaying: false,
        paySuccess: true,
        paymentTransaction: transaction,
        wrongPinAttempts: 0,
      );
    } catch (e) {
      String errorMsg = e
          .toString()
          .replaceFirst(RegExp(r'^Exception: '), '')
          .replaceFirst(RegExp(r'^error: '), '')
          .replaceFirst(RegExp(r'^DioException.*: '), '');
      final isPinError = _isPinError(errorMsg);
      final attempts = isPinError
          ? state.wrongPinAttempts + 1
          : state.wrongPinAttempts;
      final locked = isPinError && attempts >= 5;

      if (isPinError) {
        if (locked) {
          errorMsg =
              'Bạn đã nhập sai mã PIN 5 lần. Tính năng chuyển tiền tạm thời bị khóa.';
        } else {
          errorMsg =
              'Mã PIN không chính xác. Bạn còn ${5 - attempts} lần thử lại.';
        }
      }

      state = state.copyWith(
        isPaying: false,
        errorMessage: errorMsg.trim(),
        wrongPinAttempts: attempts,
        isLocked: locked,
        pin: '',
      );
    }
  }

  bool _isSameAccount(String sourceAccountNumber, String targetAccountNumber) {
    return sourceAccountNumber.trim() == targetAccountNumber.trim();
  }

  bool _isPinError(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('pin') &&
        (normalized.contains('khong chinh xac') ||
            normalized.contains('không chính xác') ||
            normalized.contains('incorrect'));
  }
}
