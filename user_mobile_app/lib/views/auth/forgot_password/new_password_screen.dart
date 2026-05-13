import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../app/providers.dart';
import '../../../core/app/app_colors.dart';
import '../../../widgets/auth/auth_widgets.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordViewModelProvider);

    ref.listen(forgotPasswordViewModelProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt lại mật khẩu thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        // Quay về màn hình đăng nhập
        Navigator.of(context).popUntil((route) => route.isFirst);
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
                    "Mật khẩu mới",
                    style: GoogleFonts.outfit(
                      fontSize: 36, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Vui lòng thiết lập mật khẩu mới cho tài khoản của bạn.",
                    style: GoogleFonts.inter(fontSize: 16, color: AppColors.slate400),
                  ),
                  const SizedBox(height: 48),
                  AuthTextField(
                    label: "Mật khẩu mới",
                    controller: _passwordController,
                    icon: LucideIcons.lock,
                    isPassword: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                        color: AppColors.slate400,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Vui lòng nhập mật khẩu";
                      if (value.length < 8) return "Mật khẩu phải từ 8 ký tự";
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(
                    label: "Xác nhận mật khẩu",
                    controller: _confirmPasswordController,
                    icon: LucideIcons.checkCircle,
                    isPassword: _obscurePassword,
                    validator: (value) {
                      if (value != _passwordController.text) return "Mật khẩu không khớp";
                      return null;
                    },
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: "Hoàn tất",
                    isLoading: state.isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(forgotPasswordViewModelProvider.notifier)
                            .resetPassword(_passwordController.text);
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
