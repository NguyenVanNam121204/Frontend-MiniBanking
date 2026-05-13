import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Thêm để dùng LogicalKeyboardKey
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../core/app/app_colors.dart';
import '../../../widgets/auth/auth_widgets.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isForgotPassword;
  final String? newPassword;

  const VerifyOtpScreen({
    super.key, 
    required this.email, 
    this.isForgotPassword = false,
    this.newPassword,
  });

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
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
    // Chỉ xử lý nhảy tới khi nhập
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    if (_otpCode.length == 6) {
      FocusScope.of(context).unfocus();
    }
    setState(() {});
  }

  // Xử lý phím xóa (Backspace)
  void _handleKeyPress(int index, KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_otpControllers[index].text.isEmpty && index > 0) {
        // Nếu ô hiện tại trống, nhảy về ô trước và xóa nội dung ô đó
        _focusNodes[index - 1].requestFocus();
        _otpControllers[index - 1].clear();
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verifyOtpViewModelProvider);
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const Scaffold();

    ref.listen(verifyOtpViewModelProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xác thực thành công! Vui lòng đăng nhập.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!), 
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
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
                      l10n.verifyCode,
                      style: GoogleFonts.outfit(
                        fontSize: 36, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSubTitle(l10n),
                    const SizedBox(height: 56),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) => _buildOtpBox(index)),
                    ),
                    
                    const SizedBox(height: 56),
                    
                    PrimaryButton(
                      text: l10n.verifyContinue,
                      isLoading: state.isLoading,
                      onPressed: _otpCode.length == 6 ? () {
                        if (widget.isForgotPassword) {
                          ref.read(verifyOtpViewModelProvider.notifier).resetPassword(
                            widget.email, 
                            _otpCode, 
                            widget.newPassword!
                          );
                        } else {
                          ref.read(verifyOtpViewModelProvider.notifier).verifyOtp(widget.email, _otpCode);
                        }
                      } : null,
                    ),
                    
                    const SizedBox(height: 32),
                    Center(
                      child: _buildResendSection(l10n, state.isLoading),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubTitle(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${l10n.otpSubtitle} (Hiệu lực trong 3 phút)",
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
      focusNode: FocusNode(), // Node phụ để bắt phím
      onKeyEvent: (event) => _handleKeyPress(index, event),
      child: Container(
        width: 50,
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focusNodes[index].hasFocus 
                ? AppColors.accent 
                : Colors.white.withValues(alpha: 0.1),
            width: _focusNodes[index].hasFocus ? 2 : 1,
          ),
          boxShadow: _focusNodes[index].hasFocus ? [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.2),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ] : null,
        ),
        child: Center(
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: GoogleFonts.outfit(
              fontSize: 28, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              counterText: '', 
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => _onOtpChanged(index, value),
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection(AppLocalizations l10n, bool isLoading) {
    return Column(
      children: [
        Text(
          l10n.didNotReceiveCode,
          style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
        ),
        const SizedBox(height: 8),
        _canResend
            ? TextButton(
                onPressed: isLoading ? null : () async {
                  await ref.read(verifyOtpViewModelProvider.notifier).resendOtp(widget.email);
                  
                  // Xóa trắng tất cả các ô nhập
                  for (var controller in _otpControllers) {
                    controller.clear();
                  }
                  // Đưa focus về ô đầu tiên
                  _focusNodes[0].requestFocus();
                  
                  _startTimer();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mã OTP mới đã được gửi!'),
                        backgroundColor: AppColors.accent,
                      ),
                    );
                  }
                },
                child: Text(
                  l10n.resendCode,
                  style: GoogleFonts.inter(
                    color: AppColors.accent, 
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.resendIn,
                    style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
                  ),
                  Text(
                    '${_start}s',
                    style: GoogleFonts.inter(
                      color: AppColors.accent, 
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
