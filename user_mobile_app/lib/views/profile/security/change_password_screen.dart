import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app/app_colors.dart';
import '../../../app/providers.dart';
import 'widgets/security_field.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(securityViewModelProvider.notifier).changePassword(
          _oldPasswordController.text,
          _newPasswordController.text,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đổi mật khẩu thành công"), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(securityViewModelProvider);

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
          "Đổi mật khẩu",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ cái và số.",
                style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
              ),
              const SizedBox(height: 32),
              SecurityField(
                label: "Mật khẩu hiện tại",
                hint: "Nhập mật khẩu cũ",
                controller: _oldPasswordController,
                isPassword: true,
                validator: (v) => v == null || v.isEmpty ? "Vui lòng nhập mật khẩu cũ" : null,
              ),
              const SizedBox(height: 24),
              SecurityField(
                label: "Mật khẩu mới",
                hint: "Nhập mật khẩu mới",
                controller: _newPasswordController,
                isPassword: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Vui lòng nhập mật khẩu mới";
                  if (v.length < 8) return "Mật khẩu phải từ 8 ký tự";
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SecurityField(
                label: "Xác nhận mật khẩu",
                hint: "Nhập lại mật khẩu mới",
                controller: _confirmPasswordController,
                isPassword: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Vui lòng xác nhận mật khẩu";
                  if (v != _newPasswordController.text) return "Mật khẩu xác nhận không trùng khớp";
                  return null;
                },
              ),
              const SizedBox(height: 48),
              if (state.errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
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
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: state.isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          "Cập nhật mật khẩu",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
