import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/app/app_colors.dart';
import '../../app/providers.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_section.dart';
import 'security/change_password_screen.dart';
import 'security/setup_pin_screen.dart';
import 'security/change_pin_screen.dart';
import 'package:user_mobile_app/views/splash_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: state.isLoading && state.user == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => ref.read(profileViewModelProvider.notifier).refresh(),
                backgroundColor: AppColors.surface,
                color: AppColors.accent,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      if (state.user != null)
                        ProfileHeader(
                          name: state.user!.username,
                          email: state.user!.email,
                        ),
                      
                      ProfileSection(
                        title: "BẢO MẬT",
                        children: [
                          ProfileMenuItem(
                            icon: LucideIcons.lock,
                            title: "Đổi mật khẩu",
                            subtitle: "Cập nhật mật khẩu định kỳ để an toàn hơn",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
                              );
                            },
                          ),
                          ProfileMenuItem(
                            icon: LucideIcons.key,
                            title: state.user?.hasPin == true ? "Đổi mã PIN" : "Thiết lập mã PIN",
                            subtitle: state.user?.hasPin == true 
                                ? "Mã PIN 6 số dùng cho giao dịch" 
                                : "Bạn chưa có mã PIN giao dịch",
                            iconColor: state.user?.hasPin == true ? null : Colors.orangeAccent,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => state.user?.hasPin == true 
                                      ? const ChangePinScreen() 
                                      : const SetupPinScreen(),
                                ),
                              );
                            },
                            showDivider: false,
                          ),
                        ],
                      ),

                      ProfileSection(
                        title: "TÀI KHOẢN",
                        children: [
                          ProfileMenuItem(
                            icon: LucideIcons.user,
                            title: "Thông tin cá nhân",
                            onTap: () {},
                          ),
                          ProfileMenuItem(
                            icon: LucideIcons.bell,
                            title: "Cài đặt thông báo",
                            onTap: () {},
                            showDivider: false,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _showLogoutDialog(context, ref),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                              foregroundColor: Colors.redAccent,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.2)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(LucideIcons.logOut, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "Đăng xuất",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      Text(
                        "Phiên bản 1.0.0",
                        style: GoogleFonts.inter(
                          color: AppColors.slate600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Đăng xuất",
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng?",
          style: GoogleFonts.inter(color: AppColors.slate400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Hủy",
              style: GoogleFonts.inter(color: AppColors.slate400),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(authServiceProvider).logout();
              if (context.mounted) {
                // Reset navigation index to Home
                ref.read(navigationIndexProvider.notifier).state = 0;

                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Đăng xuất"),
          ),
        ],
      ),
    );
  }
}
