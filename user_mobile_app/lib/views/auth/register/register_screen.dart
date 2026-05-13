import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../core/app/app_colors.dart';
import '../../../widgets/auth/auth_widgets.dart';
import '../verify_otp/verify_otp_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerViewModelProvider);
    final l10n = AppLocalizations.of(context);

    if (l10n == null) return const Scaffold();

    ref.listen(registerViewModelProvider, (previous, next) {
      if (next.isSuccess) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerifyOtpScreen(email: _emailController.text)),
        );
      }
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: AppColors.error),
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
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.createAccount,
                        style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        l10n.joinUsSubtitle,
                        style: GoogleFonts.inter(fontSize: 16, color: AppColors.slate400),
                      ),
                      const SizedBox(height: 40),
                      
                      AuthTextField(
                        controller: _usernameController,
                        label: l10n.username,
                        icon: LucideIcons.user,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        controller: _emailController,
                        label: l10n.email,
                        icon: LucideIcons.mail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        controller: _passwordController,
                        label: l10n.password,
                        icon: LucideIcons.lock,
                        isPassword: true,
                        isVisible: _isPasswordVisible,
                        onVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      PrimaryButton(
                        text: l10n.register,
                        isLoading: state.isLoading,
                        onPressed: () => ref.read(registerViewModelProvider.notifier).register(
                          _usernameController.text, 
                          _emailController.text,
                          _passwordController.text
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      _buildLoginLink(l10n),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.alreadyHaveAccount, style: GoogleFonts.inter(color: AppColors.slate400)),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            l10n.signIn, 
            style: GoogleFonts.inter(color: AppColors.accent, fontWeight: FontWeight.bold)
          ),
        ),
      ],
    );
  }
}
