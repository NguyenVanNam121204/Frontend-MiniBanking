import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../app/providers.dart';
import '../../../core/app/app_colors.dart';
import '../../../viewmodels/transaction/transfer/transfer_state.dart';
import '../../../viewmodels/transaction/transfer/transfer_view_model.dart';
import '../../../models/account/account_model.dart';
import '../../../widgets/transaction/account_selector.dart';
import '../../../widgets/transaction/currency_input_field.dart';
import '../../../widgets/transaction/numeric_keypad.dart';
import '../../../widgets/transaction/pin_dots.dart';
import '../../../widgets/transaction/transaction_confirm_row.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transferViewModelProvider);
    final viewModel = ref.read(transferViewModelProvider.notifier);
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
            onPressed: () {
              if (state.currentStep > 1 && state.currentStep < 4) {
                viewModel.previousStep();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            state.currentStep == 4 ? "Giao dịch thành công" : "Chuyển tiền",
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: _buildBody(state, viewModel, format),
      ),
    );
  }

  Widget _buildBody(TransferState state, TransferViewModel viewModel, NumberFormat format) {
    switch (state.currentStep) {
      case 1: return _buildInputStep(state, viewModel);
      case 2: return _buildConfirmStep(state, viewModel, format);
      case 3: return _buildPinStep(state, viewModel);
      case 4: return _buildSuccessStep(state, viewModel, format);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildInputStep(TransferState state, TransferViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Từ tài khoản"),
          const SizedBox(height: 12),
          AccountSelector(
            selectedAccount: state.selectedSourceAccount,
            accounts: state.myAccounts,
            label: "Chọn tài khoản nguồn",
            onAccountSelected: viewModel.selectSourceAccount,
          ),
          
          const SizedBox(height: 32),
          _buildSectionTitle("Đến tài khoản"),
          const SizedBox(height: 12),
          _buildRecipientInput(state, viewModel),
          
          if (state.recipientAccount != null) ...[
            const SizedBox(height: 12),
            _buildRecipientInfo(state.recipientAccount!),
          ],

          const SizedBox(height: 32),
          CurrencyInputField(
            controller: _amountController,
            label: "Số tiền chuyển",
            onChanged: (val) => viewModel.setAmount(double.tryParse(val.replaceAll('.', '')) ?? 0),
            errorText: (state.amount > 0 && state.amount < 10000)
              ? "Số tiền tối thiểu là 10.000đ"
              : (state.amount > (state.selectedSourceAccount?.balance ?? 0))
                ? "Số dư không đủ"
                : null,
          ),

          const SizedBox(height: 32),
          _buildSectionTitle("Nội dung (Tùy chọn)"),
          const SizedBox(height: 12),
          _buildDescriptionInput(viewModel),

          const SizedBox(height: 48),
          _buildMainButton(
            "Tiếp tục", 
            onTap: (state.recipientAccount != null && 
                    state.amount >= 10000 && 
                    state.amount <= (state.selectedSourceAccount?.balance ?? 0) &&
                    state.recipientAccount!.accountNumber != state.selectedSourceAccount?.accountNumber) 
              ? () => viewModel.nextStep() 
              : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        color: AppColors.slate400,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildRecipientInput(TransferState state, TransferViewModel viewModel) {
    final bool isSameAccount = state.recipientAccount != null && 
                               state.selectedSourceAccount != null && 
                               state.recipientAccount!.accountNumber == state.selectedSourceAccount!.accountNumber;
    final String? displayError = isSameAccount ? "Không thể chuyển tiền cho chính tài khoản này" : (state.currentStep == 1 ? state.errorMessage : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _recipientController,
          onChanged: viewModel.searchRecipient,
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: "Nhập số tài khoản",
            hintStyle: GoogleFonts.inter(color: AppColors.slate600),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: displayError != null
                  ? Colors.redAccent.withValues(alpha: 0.5) 
                  : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: displayError != null
                  ? Colors.redAccent 
                  : AppColors.accent, 
                width: 1.5,
              ),
            ),
            suffixIcon: state.isSearchingRecipient 
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(
                      strokeWidth: 2, 
                      color: AppColors.accent.withValues(alpha: 0.8)
                    )
                  ),
                )
              : null,
          ),
        ),
        if (displayError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                const Icon(LucideIcons.alertCircle, color: Colors.redAccent, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    displayError,
                    style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRecipientInfo(AccountModel account) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.accent,
            child: Icon(LucideIcons.user, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.ownerName?.toUpperCase() ?? "KHÁCH HÀNG",
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                "Ngân hàng ABC",
                style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionInput(TransferViewModel viewModel) {
    return TextField(
      controller: _descController,
      onChanged: viewModel.setDescription,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Nội dung chuyển khoản",
        hintStyle: GoogleFonts.inter(color: AppColors.slate600),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildConfirmStep(TransferState state, TransferViewModel viewModel, NumberFormat format) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                TransactionConfirmRow(label: "Từ tài khoản", value: state.selectedSourceAccount?.accountNumber ?? ""),
                TransactionConfirmRow(label: "Tên người gửi", value: state.selectedSourceAccount?.ownerName?.toUpperCase() ?? ""),
                const Divider(color: Colors.white10, height: 32),
                TransactionConfirmRow(label: "Đến tài khoản", value: state.recipientAccount?.accountNumber ?? ""),
                TransactionConfirmRow(label: "Tên người nhận", value: state.recipientAccount?.ownerName?.toUpperCase() ?? ""),
                const Divider(color: Colors.white10, height: 32),
                TransactionConfirmRow(label: "Số tiền", value: format.format(state.amount), isBold: true),
                TransactionConfirmRow(label: "Nội dung", value: state.description.isEmpty ? "Chuyển tiền" : state.description),
                const Divider(color: Colors.white10, height: 32),
                TransactionConfirmRow(label: "Phí giao dịch", value: "Miễn phí", color: Colors.greenAccent),
              ],
            ),
          ),
          const Spacer(),
          _buildMainButton("Xác nhận", onTap: () => viewModel.nextStep()),
        ],
      ),
    );
  }

  Widget _buildPinStep(TransferState state, TransferViewModel viewModel) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Text(
          "Xác nhận mã PIN",
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 48),
        PinDots(length: state.pin.length),
        const Spacer(),
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.redAccent, fontSize: 13),
            ),
          ),
        if (state.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        // Custom Keypad
        if (!state.isLocked)
          NumericKeypad(
            onDigitPressed: viewModel.updatePin,
            onDeletePressed: viewModel.deleteLastPin,
          )
        else
          Padding(
            padding: const EdgeInsets.all(32),
            child: _buildMainButton(
              "Liên hệ hỗ trợ", 
              onTap: () {
                // In reality, this would open phone dialer or chat
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSuccessStep(TransferState state, TransferViewModel viewModel, NumberFormat format) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.greenAccent,
            child: Icon(LucideIcons.check, color: Colors.black, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            "Giao dịch thành công",
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            format.format(state.amount),
            style: GoogleFonts.outfit(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.accent),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                TransactionConfirmRow(label: "Mã giao dịch", value: "#${state.successTransaction?.id ?? '123456'}"),
                TransactionConfirmRow(label: "Thời gian", value: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())),
                TransactionConfirmRow(label: "Người thụ hưởng", value: state.recipientAccount?.ownerName?.toUpperCase() ?? ""),
                TransactionConfirmRow(label: "Nội dung", value: state.description.isEmpty ? "Chuyển tiền" : state.description),
              ],
            ),
          ),
          const Spacer(),
          _buildMainButton("Về trang chủ", onTap: () {
             viewModel.reset();
             ref.read(homeViewModelProvider.notifier).fetchData(); // Refresh balances
             Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildMainButton(String title, {VoidCallback? onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: onTap == null ? Colors.white38 : Colors.black,
          ),
        ),
      ),
    );
  }
}
