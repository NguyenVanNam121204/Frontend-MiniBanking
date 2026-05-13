import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/app/app_colors.dart';
import '../../models/account/account_model.dart';

class AccountSelector extends StatelessWidget {
  final AccountModel? selectedAccount;
  final List<AccountModel> accounts;
  final String label;
  final Function(AccountModel) onAccountSelected;

  const AccountSelector({
    super.key,
    this.selectedAccount,
    required this.accounts,
    this.label = "Chọn tài khoản",
    required this.onAccountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAccountPicker(context),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: selectedAccount == null 
                ? Text(label, style: GoogleFonts.inter(color: AppColors.slate400))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getAccountTitle(selectedAccount!.type),
                        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${selectedAccount!.accountNumber} • ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(selectedAccount!.balance)}",
                        style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 12),
                      ),
                    ],
                  ),
            ),
            const Icon(LucideIcons.chevronDown, color: AppColors.slate400, size: 20),
          ],
        ),
      ),
    );
  }

  void _showAccountPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, color: AppColors.slate400, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...accounts.map((acc) {
                final isSelected = selectedAccount?.id == acc.id;
                return GestureDetector(
                  onTap: () {
                    onAccountSelected(acc);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppColors.accent.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getAccountColor(acc.type).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_getAccountIcon(acc.type), color: _getAccountColor(acc.type), size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getAccountTitle(acc.type),
                                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${acc.accountNumber}${acc.ownerName != null ? ' • ${acc.ownerName}' : ''}",
                                style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(acc.balance),
                          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  String _getAccountTitle(AccountType type) {
    switch (type) {
      case AccountType.savings: return "Tài khoản Tiết kiệm";
      case AccountType.business: return "Tài khoản Doanh nghiệp";
      default: return "Tài khoản Thanh toán";
    }
  }

  Color _getAccountColor(AccountType type) {
    switch (type) {
      case AccountType.savings: return Colors.orange;
      case AccountType.business: return Colors.purple;
      default: return AppColors.accent;
    }
  }

  IconData _getAccountIcon(AccountType type) {
    switch (type) {
      case AccountType.savings: return LucideIcons.piggyBank;
      case AccountType.business: return LucideIcons.briefcase;
      default: return LucideIcons.wallet;
    }
  }
}
