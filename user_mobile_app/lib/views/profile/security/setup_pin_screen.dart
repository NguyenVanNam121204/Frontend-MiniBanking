import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../core/app/app_colors.dart';
import '../../../app/providers.dart';

class SetupPinScreen extends ConsumerStatefulWidget {
  const SetupPinScreen({super.key});

  @override
  ConsumerState<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends ConsumerState<SetupPinScreen> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isConfirmStage = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(String pin) async {
    if (!_isConfirmStage) {
      setState(() => _isConfirmStage = true);
      return;
    }

    if (pin != _pinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mã PIN không khớp, vui lòng thử lại")),
      );
      _confirmController.clear();
      return;
    }

    final success = await ref.read(securityViewModelProvider.notifier).setupPin(pin);

    if (success && mounted) {
      ref.read(profileViewModelProvider.notifier).refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thiết lập mã PIN thành công"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityViewModelProvider);
    
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.outfit(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, color: AppColors.accent, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              _isConfirmStage ? "Xác nhận mã PIN" : "Thiết lập mã PIN",
              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              _isConfirmStage 
                  ? "Nhập lại mã PIN 6 số để xác nhận" 
                  : "Thiết lập mã PIN 6 số để bảo mật giao dịch của bạn",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 16),
            ),
            const SizedBox(height: 48),
            Pinput(
              length: 6,
              controller: _isConfirmStage ? _confirmController : _pinController,
              obscureText: true,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: AppColors.accent),
                ),
              ),
              onCompleted: _handleSubmit,
              autofocus: true,
            ),
            const SizedBox(height: 32),
            if (state.errorMessage != null)
              Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: GoogleFonts.inter(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            if (_isConfirmStage)
              TextButton(
                onPressed: () => setState(() => _isConfirmStage = false),
                child: Text(
                  "Quay lại",
                  style: GoogleFonts.inter(color: AppColors.accent),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
