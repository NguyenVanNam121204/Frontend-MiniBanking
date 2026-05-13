import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/app/app_colors.dart';
import '../../models/account/account_model.dart';
import '../../app/providers.dart';

class OpenAccountScreen extends ConsumerStatefulWidget {
  const OpenAccountScreen({super.key});

  @override
  ConsumerState<OpenAccountScreen> createState() => _OpenAccountScreenState();
}

class _OpenAccountScreenState extends ConsumerState<OpenAccountScreen> {
  AccountType _selectedType = AccountType.checking;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(openAccountViewModelProvider);
    final viewModel = ref.read(openAccountViewModelProvider.notifier);

    // Listen for success
    ref.listen(openAccountViewModelProvider, (previous, next) {
      if (next.isSuccess) {
        _showSuccessDialog(context);
      }
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Mở tài khoản mới",
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chọn loại tài khoản bạn muốn mở",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.slate400,
              ),
            ),
            const SizedBox(height: 32),
            _buildTypeCard(
              AccountType.checking,
              "Tài khoản thanh toán",
              "Sử dụng cho các giao dịch hàng ngày, chuyển tiền và thanh toán hóa đơn.",
              LucideIcons.creditCard,
              Colors.blueAccent,
            ),
            const SizedBox(height: 16),
            _buildTypeCard(
              AccountType.savings,
              "Tài khoản tiết kiệm",
              "Dành cho việc tích lũy tài sản với lãi suất hấp dẫn hơn.",
              LucideIcons.piggyBank,
              Colors.greenAccent,
            ),
            const SizedBox(height: 16),
            _buildTypeCard(
              AccountType.business,
              "Tài khoản doanh nghiệp",
              "Giải pháp tối ưu cho quản lý tài chính kinh doanh của bạn.",
              LucideIcons.briefcase,
              Colors.orangeAccent,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () => viewModel.openAccount(_selectedType),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: state.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        "Xác nhận mở tài khoản",
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard(
    AccountType type,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withValues(alpha: 0.1) 
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.white.withValues(alpha: 0.05),
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.slate800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.slate400,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.slate400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(LucideIcons.checkCircle2, color: color, size: 24),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.check,
                color: Colors.greenAccent,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Thành công!",
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Tài khoản của bạn đã được mở thành công. Bạn có thể bắt đầu sử dụng ngay bây giờ.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.slate400,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Reset ViewModel state
                  ref.read(openAccountViewModelProvider.notifier).reset();
                  // Refresh Home Accounts
                  ref.read(homeViewModelProvider.notifier).fetchAccounts();
                  // Pop back twice (Dialog and Screen)
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Tuyệt vời",
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
