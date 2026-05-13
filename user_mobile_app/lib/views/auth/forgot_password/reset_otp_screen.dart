import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../app/providers.dart';
import '../../../core/app/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../widgets/auth/auth_widgets.dart';
import 'new_password_screen.dart';

class ResetOtpScreen extends ConsumerStatefulWidget {
  final String email;

  const ResetOtpScreen({super.key, required this.email});

  @override
  ConsumerState<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends ConsumerState<ResetOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  Timer? _timer;
  int _start = 180;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
    });
  }

  void _startTimer() {
    if (!mounted) return;
    setState(() {
      _canResend = false;
      _start = 180;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_start == 0) {
        setState(() {
          _canResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((e) => e.text).join();

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
  }

  void _handleKeyPress(int index, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_otpControllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _otpControllers[index - 1].clear();
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordViewModelProvider);
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const Scaffold();

    // Lắng nghe trạng thái xác thực thành công để chuyển màn
    ref.listen(forgotPasswordViewModelProvider, (previous, next) {
      if (next.otpVerified && !(previous?.otpVerified ?? false)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewPasswordScreen(),
          ),
        );
      }
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.bgDark, AppColors.primary],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(LucideIcons.arrowLeft, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Xác thực mã",
                      style: GoogleFonts.outfit(
                        fontSize: 36, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSubTitle(),
                    const SizedBox(height: 56),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) => _buildOtpBox(index)),
                    ),
                    const SizedBox(height: 56),
                    PrimaryButton(
                      text: "Xác thực",
                      isLoading: state.isLoading,
                      onPressed: _otpCode.length == 6 ? () {
                        ref.read(forgotPasswordViewModelProvider.notifier).verifyOtp(_otpCode);
                      } : null,
                    ),
                    const SizedBox(height: 32),
                    Center(child: _buildResendSection(l10n)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nhập mã xác thực 6 chữ số đã được gửi tới email (Hiệu lực trong 3 phút)",
          style: GoogleFonts.inter(fontSize: 15, color: AppColors.slate400, height: 1.5),
        ),
        const SizedBox(height: 8),
        Text(
          widget.email,
          style: GoogleFonts.inter(
            fontSize: 16, 
            color: AppColors.accent, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpBox(int index) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (event) => _handleKeyPress(index, event),
      child: Container(
        width: 50, height: 62,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focusNodes[index].hasFocus ? AppColors.accent : Colors.white.withValues(alpha: 0.1),
            width: _focusNodes[index].hasFocus ? 2 : 1,
          ),
        ),
        child: Center(
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            decoration: const InputDecoration(counterText: '', border: InputBorder.none),
            onChanged: (value) => _onOtpChanged(index, value),
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection(AppLocalizations l10n) {
    return Column(
      children: [
        Text("Bạn không nhận được mã?", style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14)),
        const SizedBox(height: 8),
        _canResend
            ? TextButton(
                onPressed: () {
                  // Xóa các ô nhập cũ
                  for (var controller in _otpControllers) {
                    controller.clear();
                  }
                  // Đưa focus về ô đầu tiên
                  _focusNodes[0].requestFocus();
                  
                  ref.read(forgotPasswordViewModelProvider.notifier).sendForgotPasswordOtp(widget.email);
                  _startTimer();
                },
                child: Text("Gửi lại mã", style: GoogleFonts.inter(color: AppColors.accent, fontWeight: FontWeight.bold)),
              )
            : Text("Gửi lại sau ${_start}s", style: GoogleFonts.inter(color: AppColors.accent, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
