import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../app/providers.dart';
import '../../../core/app/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../widgets/auth_widgets.dart';
import 'reset_otp_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(forgotPasswordViewModelProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordViewModelProvider);
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const Scaffold();

    ref.listen(forgotPasswordViewModelProvider, (previous, next) {
      if (next.emailSent && !(previous?.emailSent ?? false)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetOtpScreen(email: next.email!),
          ),
        );
      }
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage && !next.emailSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    l10n.forgotPasswordTitle,
                    style: GoogleFonts.outfit(
                      fontSize: 36, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Nhập email của bạn để nhận mã xác thực đặt lại mật khẩu.",
                    style: GoogleFonts.inter(fontSize: 16, color: AppColors.slate400),
                  ),
                  const SizedBox(height: 48),
                  AuthTextField(
                    label: l10n.email,
                    controller: _emailController,
                    icon: LucideIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Vui lòng nhập email";
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return "Email không hợp lệ";
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: "Tiếp tục",
                    isLoading: state.isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(forgotPasswordViewModelProvider.notifier)
                            .sendForgotPasswordOtp(_emailController.text.trim());
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
