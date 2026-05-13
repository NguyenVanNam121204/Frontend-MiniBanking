import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../core/app/app_colors.dart';
import '../../../app/providers.dart';

class ChangePinScreen extends ConsumerStatefulWidget {
  const ChangePinScreen({super.key});

  @override
  ConsumerState<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends ConsumerState<ChangePinScreen> {
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _confirmFocusNode = FocusNode();
  
  bool _isOldPinVerified = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyOldPin(String pin) async {
    final isValid = await ref.read(securityViewModelProvider.notifier).verifyPin(pin);
    if (isValid && mounted) {
      setState(() => _isOldPinVerified = true);
    } else {
      _oldPinController.clear();
    }
  }

  Future<void> _handleSubmit() async {
    if (_newPinController.text.length < 6 || _confirmPinController.text.length < 6) {
      return;
    }

    if (_newPinController.text != _confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mã PIN mới không khớp")),
      );
      return;
    }

    final success = await ref.read(securityViewModelProvider.notifier).changePin(
          _oldPinController.text,
          _newPinController.text,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đổi mã PIN thành công"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityViewModelProvider);
    
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: GoogleFonts.outfit(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
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
        title: Text(
          "Đổi mã PIN",
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_outlined, color: AppColors.accent, size: 40),
              ),
              const SizedBox(height: 24),
              
              if (!_isOldPinVerified) ...[
                Text(
                  "Nhập mã PIN cũ",
                  style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  "Vui lòng nhập mã PIN hiện tại của bạn để tiếp tục",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 16),
                ),
                const SizedBox(height: 40),
                Pinput(
                  length: 6,
                  controller: _oldPinController,
                  obscureText: true,
                  defaultPinTheme: defaultPinTheme.copyWith(width: 54, height: 54),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    width: 54, height: 54,
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.accent),
                    ),
                  ),
                  onCompleted: _handleVerifyOldPin,
                  autofocus: true,
                ),
              ] else ...[
                Text(
                  "Thiết lập mã PIN mới",
                  style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  "Vui lòng nhập mã PIN mới và xác nhận lại",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 16),
                ),
                const SizedBox(height: 40),
                
                // New PIN
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mã PIN mới",
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),
                Pinput(
                  length: 6,
                  controller: _newPinController,
                  obscureText: true,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.accent),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  onCompleted: (_) {
                    Future.delayed(Duration.zero, () {
                      _confirmFocusNode.requestFocus();
                    });
                  },
                  autofocus: true,
                ),
                
                const SizedBox(height: 32),
                
                // Confirm PIN
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Xác nhận mã PIN mới",
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),
                Pinput(
                  length: 6,
                  controller: _confirmPinController,
                  focusNode: _confirmFocusNode,
                  obscureText: true,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: AppColors.accent),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                
                const SizedBox(height: 48),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_newPinController.text.length == 6 && _confirmPinController.text.length == 6)
                        ? _handleSubmit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: AppColors.slate800,
                      disabledForegroundColor: AppColors.slate600,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: state.isLoading 
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          "Cập nhật mã PIN",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                  ),
                ),
                
                TextButton(
                  onPressed: () => setState(() {
                    _isOldPinVerified = false;
                    _oldPinController.clear();
                    _newPinController.clear();
                    _confirmPinController.clear();
                  }),
                  child: Text(
                    "Quay lại nhập mã cũ",
                    style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
                  ),
                ),
              ],

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
            ],
          ),
        ),
      ),
    );
  }
}
