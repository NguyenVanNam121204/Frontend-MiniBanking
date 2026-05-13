import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../app/providers.dart';
import '../../../app/locale_provider.dart';
import '../../../core/app/app_colors.dart';
import '../widgets/auth_widgets.dart';
import '../register/register_screen.dart';
import '../forgot_password/forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final List<Map<String, dynamic>> _languages = [
    {'code': 'vi', 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'ko', 'name': 'Korean', 'flag': '🇰🇷'},
    {'code': 'zh', 'name': '简体中文', 'flag': '🇨🇳'},
    {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showLanguagePicker(BuildContext context, Locale currentLocale) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Ngôn ngữ',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF800000)),
              ),
              const SizedBox(height: 20),
              ..._languages.map((lang) {
                final isSelected = currentLocale.languageCode == lang['code'];
                return ListTile(
                  leading: Text(lang['flag'], style: const TextStyle(fontSize: 24)),
                  title: Text(
                    lang['name'],
                    style: GoogleFonts.inter(
                      fontSize: 16, 
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF800000) : Colors.black87,
                    ),
                  ),
                  trailing: isSelected 
                    ? const Icon(Icons.radio_button_checked, color: Color(0xFF800000))
                    : const Icon(Icons.radio_button_off, color: Colors.grey),
                  onTap: () {
                    ref.read(localeStateProvider.notifier).setLocale(Locale(lang['code']));
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeStateProvider);

    if (l10n == null) return const Scaffold(backgroundColor: AppColors.bgDark);

    ref.listen(loginViewModelProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Success!')),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildLogo(),
                          _buildLanguageSwitcher(currentLocale),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Text(
                        l10n.welcomeBack,
                        style: GoogleFonts.outfit(
                          fontSize: 36, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.signInSubtitle,
                        style: GoogleFonts.inter(
                          fontSize: 16, 
                          color: AppColors.slate400,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 50),
                      
                      AuthTextField(
                        controller: _usernameController,
                        label: l10n.username,
                        icon: LucideIcons.user,
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
                      
                      _buildForgotPassword(l10n),
                      
                      const SizedBox(height: 40),
                      
                      PrimaryButton(
                        text: l10n.signIn,
                        isLoading: state.isLoading,
                        onPressed: () => ref.read(loginViewModelProvider.notifier).login(
                          _usernameController.text, 
                          _passwordController.text
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      _buildRegisterLink(l10n),
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

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(LucideIcons.landmark, color: Colors.blue, size: 32),
    );
  }

  Widget _buildLanguageSwitcher(Locale currentLocale) {
    final currentLang = _languages.firstWhere(
      (element) => element['code'] == currentLocale.languageCode,
      orElse: () => _languages.first,
    );
    return GestureDetector(
      onTap: () => _showLanguagePicker(context, currentLocale),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          children: [
            Text(currentLang['flag'], style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              currentLang['code'].toUpperCase(),
              style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPassword(AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
          );
        },
        child: Text(
          l10n.forgotPassword,
          style: GoogleFonts.inter(color: AppColors.accent, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildRegisterLink(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.dontHaveAccount, style: GoogleFonts.inter(color: AppColors.slate400)),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
          child: Text(
            l10n.registerNow, 
            style: GoogleFonts.inter(color: AppColors.accent, fontWeight: FontWeight.bold)
          ),
        ),
      ],
    );
  }
}
