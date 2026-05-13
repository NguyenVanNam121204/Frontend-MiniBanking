import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../app/providers.dart';
import '../../../core/app/app_colors.dart';
import '../../../viewmodels/transaction/deposit/deposit_state.dart';
import '../../../viewmodels/transaction/deposit/deposit_view_model.dart';
import '../../../widgets/transaction/account_selector.dart';
import '../../../widgets/transaction/currency_input_field.dart';
import '../../../widgets/transaction/transaction_confirm_row.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(depositViewModelProvider);
    final viewModel = ref.read(depositViewModelProvider.notifier);
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
              if (state.currentStep > 1 && state.currentStep < 3) {
                viewModel.previousStep();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            state.currentStep == 3 ? "Giao dịch thành công" : "Nạp tiền",
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: _buildBody(state, viewModel, format),
      ),
    );
  }

  Widget _buildBody(DepositState state, DepositViewModel viewModel, NumberFormat format) {
    switch (state.currentStep) {
      case 1: return _buildInputStep(state, viewModel);
      case 2: return _buildConfirmStep(state, viewModel, format);
      case 3: return _buildSuccessStep(state, viewModel, format);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildInputStep(DepositState state, DepositViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Nạp vào tài khoản"),
          const SizedBox(height: 12),
          AccountSelector(
            selectedAccount: state.selectedAccount,
            accounts: state.myAccounts,
            label: "Chọn tài khoản thụ hưởng",
            onAccountSelected: viewModel.selectAccount,
          ),
          
          const SizedBox(height: 32),
          CurrencyInputField(
            controller: _amountController,
            label: "Số tiền nạp",
            onChanged: (val) => viewModel.setAmount(double.tryParse(val.replaceAll('.', '')) ?? 0),
            errorText: (state.amount > 0 && state.amount < 10000) ? "Số tiền tối thiểu là 10.000đ" : null,
          ),

          const SizedBox(height: 32),
          _buildSectionTitle("Nội dung (Tùy chọn)"),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            onChanged: viewModel.setDescription,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Nạp tiền vào tài khoản",
              hintStyle: GoogleFonts.inter(color: AppColors.slate600),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 48),
          _buildMainButton(
            "Tiếp tục", 
            onTap: (state.selectedAccount != null && state.amount >= 10000) 
              ? () => viewModel.nextStep() 
              : null,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmStep(DepositState state, DepositViewModel viewModel, NumberFormat format) {
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
                TransactionConfirmRow(label: "Tài khoản thụ hưởng", value: state.selectedAccount?.accountNumber ?? ""),
                TransactionConfirmRow(label: "Chủ tài khoản", value: state.selectedAccount?.ownerName?.toUpperCase() ?? ""),
                const Divider(color: Colors.white10, height: 32),
                TransactionConfirmRow(label: "Số tiền", value: format.format(state.amount), isBold: true),
                TransactionConfirmRow(label: "Nội dung", value: state.description.isEmpty ? "Nạp tiền" : state.description),
                const Divider(color: Colors.white10, height: 32),
                TransactionConfirmRow(label: "Phí giao dịch", value: "Miễn phí", color: Colors.greenAccent),
              ],
            ),
          ),
          const Spacer(),
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(state.errorMessage!, style: GoogleFonts.inter(color: Colors.redAccent)),
            ),
          _buildMainButton(
            "Xác nhận nạp tiền", 
            isLoading: state.isLoading,
            onTap: () => viewModel.performDeposit(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStep(DepositState state, DepositViewModel viewModel, NumberFormat format) {
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
                TransactionConfirmRow(label: "Tài khoản nhận", value: state.selectedAccount?.accountNumber ?? ""),
                TransactionConfirmRow(label: "Nội dung", value: state.description.isEmpty ? "Nạp tiền" : state.description),
              ],
            ),
          ),
          const Spacer(),
          _buildMainButton("Về trang chủ", onTap: () {
             viewModel.reset();
             ref.read(homeViewModelProvider.notifier).fetchData();
             Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildMainButton(String title, {VoidCallback? onTap, bool isLoading = false}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
          : Text(
              title,
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: onTap == null ? Colors.white38 : Colors.black),
            ),
      ),
    );
  }
}
