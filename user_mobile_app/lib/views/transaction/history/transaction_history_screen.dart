import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/app/app_colors.dart';
import '../../../models/transaction/transaction_model.dart';
import '../../../app/providers.dart';
import '../../../widgets/transaction/account_selector.dart';
import '../../../viewmodels/transaction/history/transaction_history_state.dart';
import '../../../viewmodels/transaction/history/transaction_history_view_model.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  final bool isTab;
  const TransactionHistoryScreen({super.key, this.isTab = false});

  @override
  ConsumerState<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends ConsumerState<TransactionHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(transactionHistoryViewModelProvider.notifier).fetchTransactions(isLoadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionHistoryViewModelProvider);
    final viewModel = ref.read(transactionHistoryViewModelProvider.notifier);
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.isTab ? null : IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: !widget.isTab,
        title: Text(
          "Lịch sử giao dịch",
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        color: AppColors.accent,
        child: Column(
          children: [
            _buildHeader(state, viewModel),
            Expanded(
              child: _buildTransactionList(state, format),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(TransactionHistoryState state, TransactionHistoryViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AccountSelector(
              selectedAccount: state.selectedAccount,
              accounts: state.accounts,
              label: "Chọn tài khoản",
              onAccountSelected: (acc) => viewModel.selectAccount(acc.id),
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                _buildFilterChip("Tất cả", null, state.filterType == null, viewModel),
                const SizedBox(width: 12),
                _buildFilterChip("Chuyển khoản", "TRANSFER", state.filterType == "TRANSFER", viewModel),
                const SizedBox(width: 12),
                _buildFilterChip("Nạp tiền", "DEPOSIT", state.filterType == "DEPOSIT", viewModel),
                const SizedBox(width: 12),
                _buildFilterChip("Rút tiền", "WITHDRAW", state.filterType == "WITHDRAW", viewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? type, bool isSelected, TransactionHistoryViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.setFilter(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.black : AppColors.slate400,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(TransactionHistoryState state, NumberFormat format) {
    if (state.isLoading && state.transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    if (state.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.listX, size: 64, color: AppColors.slate700),
            const SizedBox(height: 16),
            Text(
              "Không có giao dịch nào",
              style: GoogleFonts.inter(color: AppColors.slate400),
            ),
          ],
        ),
      );
    }

    // Group transactions by date
    final Map<String, List<TransactionModel>> grouped = {};
    for (var tx in state.transactions) {
      final dateStr = DateFormat('dd/MM/yyyy').format(tx.createdAt);
      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }
      grouped[dateStr]!.add(tx);
    }

    final dateKeys = grouped.keys.toList();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: dateKeys.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == dateKeys.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
          );
        }

        final date = dateKeys[index];
        final dayTransactions = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                _getDisplayDate(date),
                style: GoogleFonts.outfit(
                  color: AppColors.slate400,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...dayTransactions.map((tx) => _buildTransactionItem(tx, format)),
          ],
        );
      },
    );
  }

  String _getDisplayDate(String dateStr) {
    final now = DateTime.now();
    final today = DateFormat('dd/MM/yyyy').format(now);
    final yesterday = DateFormat('dd/MM/yyyy').format(now.subtract(const Duration(days: 1)));

    if (dateStr == today) return "Hôm nay";
    if (dateStr == yesterday) return "Hôm qua";
    return dateStr;
  }

  Widget _buildTransactionItem(TransactionModel tx, NumberFormat format) {
    final bool isPositive = tx.type == TransactionType.deposit || 
                           (tx.type == TransactionType.transfer && tx.toAccountId == ref.read(transactionHistoryViewModelProvider).selectedAccount?.id);
    
    return GestureDetector(
      onTap: () => _showTransactionDetails(context, tx, format),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            _buildIcon(tx, isPositive),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTransactionTitle(tx, isPositive),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tx.type == TransactionType.transfer
                        ? "${tx.fromAccountOwner} → ${tx.toAccountOwner}"
                        : (tx.description?.isEmpty ?? true ? "Giao dịch ngân hàng" : tx.description!),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppColors.slate400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${isPositive ? '+' : '-'}${format.format(tx.amount)}",
                  style: GoogleFonts.outfit(
                    color: isPositive ? Colors.greenAccent : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(tx.createdAt),
                  style: GoogleFonts.inter(
                    color: AppColors.slate600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, TransactionModel tx, NumberFormat format) {
    final bool isPositive = tx.type == TransactionType.deposit || 
                           (tx.type == TransactionType.transfer && tx.toAccountId == ref.read(transactionHistoryViewModelProvider).selectedAccount?.id);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.bgDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            _buildIcon(tx, isPositive),
            const SizedBox(height: 16),
            Text(
              _getTransactionTitle(tx, isPositive),
              style: GoogleFonts.outfit(color: AppColors.slate400, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "${isPositive ? '+' : '-'}${format.format(tx.amount)}",
              style: GoogleFonts.outfit(
                color: isPositive ? Colors.greenAccent : Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _buildDetailRow("Trạng thái", "Thành công", color: Colors.greenAccent),
                  _buildDetailRow("Mã giao dịch", "#${tx.id}"),
                  _buildDetailRow("Thời gian", DateFormat('dd/MM/yyyy HH:mm').format(tx.createdAt)),
                  _buildDetailRow("Từ tài khoản", tx.fromAccountNumber ?? 'N/A'),
                  _buildDetailRow("Đến tài khoản", tx.toAccountNumber ?? 'N/A'),
                  const Divider(color: Colors.white10, height: 32),
                  _buildDetailRow("Nội dung", tx.description?.isEmpty ?? true ? "Giao dịch ngân hàng" : tx.description!),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  "Đóng",
                  style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14)),
          Text(
            value,
            style: GoogleFonts.inter(
              color: color ?? Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildIcon(TransactionModel tx, bool isPositive) {
    IconData icon;
    Color color;

    switch (tx.type) {
      case TransactionType.deposit:
        icon = LucideIcons.arrowDownLeft;
        color = Colors.greenAccent;
        break;
      case TransactionType.withdraw:
        icon = LucideIcons.arrowUpRight;
        color = Colors.orangeAccent;
        break;
      case TransactionType.transfer:
        icon = LucideIcons.arrowLeftRight;
        color = AppColors.accent;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  String _getTransactionTitle(TransactionModel tx, bool isPositive) {
    switch (tx.type) {
      case TransactionType.deposit: return "Nạp tiền";
      case TransactionType.withdraw: return "Rút tiền";
      case TransactionType.transfer: return isPositive ? "Nhận tiền" : "Chuyển tiền";
    }
  }
}
