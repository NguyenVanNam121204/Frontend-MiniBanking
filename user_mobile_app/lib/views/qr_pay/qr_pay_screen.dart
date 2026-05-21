import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import '../../core/app/app_colors.dart';
import '../../app/providers.dart';
import '../../models/account/account_model.dart';
import '../../models/transaction/transaction_model.dart';
import '../../viewmodels/home/home_state.dart';
import '../../viewmodels/qr_pay/qr_pay_state.dart';
import '../../viewmodels/qr_pay/qr_pay_view_model.dart';

class QrPayScreen extends ConsumerStatefulWidget {
  const QrPayScreen({super.key});

  @override
  ConsumerState<QrPayScreen> createState() => _QrPayScreenState();
}

class _QrPayScreenState extends ConsumerState<QrPayScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  /// Key to capture the QR widget as a real PNG image
  final GlobalKey _qrRepaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.repeat(reverse: true);

    // Initialize Viewmodel accounts
    Future.microtask(() {
      ref.read(qrPayViewModelProvider.notifier).init();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Helper to get all accounts
  List<AccountModel> _getAvailableAccounts(HomeState state) {
    return state.accounts;
  }

  Widget _buildAccountSelector({
    required BuildContext context,
    required AccountModel? selectedAccount,
    required List<AccountModel> accounts,
    required Function(AccountModel) onSelected,
    bool showBalance = false,
  }) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    String getAccountTitle(AccountModel a) {
      switch (a.type) {
        case AccountType.savings:
          return 'Tài khoản Tiết kiệm';
        case AccountType.checking:
          return 'Tài khoản Thanh toán';
        case AccountType.business:
          return 'Tài khoản Doanh nghiệp';
      }
    }

    IconData getAccountIcon(AccountModel a) {
      switch (a.type) {
        case AccountType.savings:
          return LucideIcons.wallet;
        case AccountType.checking:
          return LucideIcons.creditCard;
        case AccountType.business:
          return LucideIcons.landmark;
      }
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.bgDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              border: Border(
                top: BorderSide(color: Colors.white12, width: 0.5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Chọn tài khoản',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      final isSelected =
                          selectedAccount?.accountNumber ==
                          account.accountNumber;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            onSelected(account);
                            Navigator.pop(context);
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accent.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              getAccountIcon(account),
                              color: isSelected
                                  ? AppColors.accent
                                  : Colors.white70,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            getAccountTitle(account),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              account.accountNumber,
                              style: GoogleFonts.inter(
                                color: AppColors.slate400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          trailing: Text(
                            currencyFormat.format(account.balance),
                            style: GoogleFonts.inter(
                              color: isSelected
                                  ? AppColors.accent
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                selectedAccount != null
                    ? getAccountIcon(selectedAccount)
                    : LucideIcons.wallet,
                color: AppColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedAccount != null
                        ? getAccountTitle(selectedAccount)
                        : 'Chọn tài khoản',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedAccount != null
                        ? '${selectedAccount.accountNumber}${showBalance ? " - ${currencyFormat.format(selectedAccount.balance)}" : ""}'
                        : 'Không có tài khoản',
                    style: GoogleFonts.inter(
                      color: AppColors.slate400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronDown,
              color: Colors.white70,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Mở thư viện ảnh thật và decode QR bằng mobile_scanner.
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    XFile? picked;
    try {
      picked = await picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(
        'Không thể mở thư viện ảnh. Vui lòng cấp quyền truy cập trong Cài đặt.',
      );
      return;
    }
    if (picked == null || !mounted) return;

    // Hiển thị loading trong khi decode
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Row(
          children: [
            const CircularProgressIndicator(color: AppColors.accent),
            const SizedBox(width: 20),
            Text(
              'Đang giải mã QR...',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ],
        ),
      ),
    );

    // Decode QR code from image using mobile_scanner
    String? decodedData;
    try {
      final controller = MobileScannerController(
        formats: const [BarcodeFormat.qrCode],
      );
      final result = await controller.analyzeImage(picked.path);
      controller.dispose();
      if (result != null && result.barcodes.isNotEmpty) {
        decodedData = result.barcodes.first.rawValue;
      }
    } catch (_) {
      decodedData = null;
    }

    if (!mounted) return;
    Navigator.pop(context); // Đóng loading

    if (decodedData == null || decodedData.isEmpty) {
      _showErrorDialog(
        'Không đọc được mã QR từ ảnh này.\n'
        'Hãy đảm bảo ảnh chứa mã QR hợp lệ được tạo bởi ứng dụng.',
      );
      return;
    }

    // Parse QR data: có thể là "QRPAY:ACCOUNT_NUMBER" hoặc chỉ là số tài khoản
    String accountNumber = decodedData;
    if (decodedData.startsWith('QRPAY:')) {
      accountNumber = decodedData.split(':')[1];
    }

    await _lookupAndShowTransferSheet(accountNumber);
  }

  /// Tra cứu tài khoản từ backend rồi mở form chuyển khoản thật.
  Future<void> _lookupAndShowTransferSheet(String accountNumber) async {
    // Show loading
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      ),
    );

    final success = await ref
        .read(qrPayViewModelProvider.notifier)
        .handleScannedCode(accountNumber);

    if (!mounted) return;
    Navigator.pop(context); // Close loading

    if (!success) {
      final state = ref.read(qrPayViewModelProvider);
      _showErrorDialog(state.errorMessage ?? 'Không tìm thấy tài khoản.');
      return;
    }

    // Show the real transfer input sheet
    _showTransferInputSheet();
  }

  /// Bottom sheet nhập thông tin chuyển khoản — giống các app ngân hàng lớn.
  void _showTransferInputSheet() {
    final amountController = TextEditingController();
    final descController = TextEditingController(text: 'Chuyển tiền');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final state = ref.read(qrPayViewModelProvider);
          final homeState = ref.read(homeViewModelProvider);
          final scanned = state.scannedTargetAccount;
          final availableAccounts = _getAvailableAccounts(homeState);
          final isSelfTransfer =
              scanned != null &&
              state.selectedSourceAccount != null &&
              scanned.accountNumber ==
                  state.selectedSourceAccount!.accountNumber;

          if (scanned == null) return const SizedBox.shrink();

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: const BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(color: Colors.white12, width: 0.5),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      'Chuyển khoản QR',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── RECIPIENT INFO CARD ──────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.03),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(
                                    alpha: 0.15,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    (scanned.ownerName?.isNotEmpty == true)
                                        ? scanned.ownerName![0].toUpperCase()
                                        : 'K',
                                    style: GoogleFonts.outfit(
                                      color: AppColors.accent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      scanned.ownerName?.toUpperCase() ??
                                          'KHÁCH HÀNG',
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          LucideIcons.landmark,
                                          color: AppColors.accent,
                                          size: 13,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Ngân hàng ABC',
                                          style: GoogleFonts.inter(
                                            color: AppColors.accent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.greenAccent.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      LucideIcons.shieldCheck,
                                      color: Colors.greenAccent,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Đã xác thực',
                                      style: GoogleFonts.inter(
                                        color: Colors.greenAccent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Số tài khoản',
                                  style: GoogleFonts.inter(
                                    color: AppColors.slate400,
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  scanned.accountNumber,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── AMOUNT INPUT ─────────────────────────────────────
                    Text(
                      'Số tiền chuyển',
                      style: GoogleFonts.inter(
                        color: AppColors.slate400,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ThousandsSeparatorInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: GoogleFonts.outfit(
                          color: AppColors.slate600,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 16, left: 10),
                          child: Text(
                            'đ',
                            style: GoogleFonts.inter(
                              color: AppColors.accent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.04),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.accent,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── DESCRIPTION INPUT ────────────────────────────────
                    Text(
                      'Nội dung chuyển khoản',
                      style: GoogleFonts.inter(
                        color: AppColors.slate400,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descController,
                      maxLength: 100,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nhập nội dung (tuỳ chọn)',
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.slate600,
                          fontSize: 14,
                        ),
                        counterStyle: GoogleFonts.inter(
                          color: AppColors.slate600,
                          fontSize: 11,
                        ),
                        prefixIcon: const Icon(
                          LucideIcons.messageSquare,
                          color: AppColors.slate500,
                          size: 18,
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.04),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.accent,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── SOURCE ACCOUNT SELECTOR ──────────────────────────
                    Text(
                      'Tài khoản nguồn',
                      style: GoogleFonts.inter(
                        color: AppColors.slate400,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAccountSelector(
                      context: ctx,
                      selectedAccount: state.selectedSourceAccount,
                      accounts: availableAccounts,
                      onSelected: (account) {
                        ref
                            .read(qrPayViewModelProvider.notifier)
                            .selectSourceAccount(account);
                        setSheetState(() {});
                      },
                      showBalance: true,
                    ),
                    if (isSelfTransfer) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.redAccent.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              LucideIcons.alertTriangle,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Không được chuyển tiền vào chính tài khoản của bạn.',
                                style: GoogleFonts.inter(
                                  color: Colors.redAccent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),

                    // ── CONTINUE BUTTON ──────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isSelfTransfer
                            ? null
                            : () async {
                                final rawAmount = amountController.text
                                    .replaceAll(RegExp(r'[^\d]'), '');
                                final amount = double.tryParse(rawAmount) ?? 0;
                                if (amount <= 0) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Vui lòng nhập số tiền hợp lệ',
                                        style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.orangeAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }
                                if (state.selectedSourceAccount == null) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Vui lòng chọn tài khoản nguồn',
                                        style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.orangeAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }
                                // Kiểm tra nếu tài khoản nhận trùng với tài khoản nguồn
                                if (scanned.accountNumber ==
                                    state
                                        .selectedSourceAccount
                                        ?.accountNumber) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Tài khoản nguồn và tài khoản nhận không được trùng nhau',
                                        style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.orangeAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }
                                // Commit transfer info to ViewModel
                                // Capture ScaffoldMessenger before awaiting to avoid using BuildContext across async gaps
                                final messenger = ScaffoldMessenger.of(ctx);
                                await ref
                                    .read(qrPayViewModelProvider.notifier)
                                    .startPaymentFromInput(
                                      amount: amount,
                                      desc: descController.text,
                                    );
                                final updatedState = ref.read(
                                  qrPayViewModelProvider,
                                );
                                if (updatedState.errorMessage != null) {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        updatedState.errorMessage!,
                                        style: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.orangeAccent,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  return;
                                }
                                if (!mounted) return;
                                Navigator.pop(context); // Close this sheet
                                _showPaymentBottomSheet(); // Open confirm + PIN sheet
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          disabledBackgroundColor: Colors.white.withValues(
                            alpha: 0.14,
                          ),
                          disabledForegroundColor: AppColors.slate400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Tiếp tục',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).then((_) {
      ref.read(qrPayViewModelProvider.notifier).clearScannedAccount();
    });
  }

  void _showPaymentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(qrPayViewModelProvider);
            final currencyFormat = NumberFormat.currency(
              locale: 'vi_VN',
              symbol: '₫',
            );

            if (state.paySuccess) {
              return _buildPaymentSuccessView(state, currencyFormat);
            }

            if (state.isPaying) {
              return _buildPaymentLoadingView();
            }

            return _buildPaymentConfirmView(context, state, currencyFormat);
          },
        );
      },
    ).then((value) {
      // Reset viewmodel state when bottom sheet is dismissed by user (not transition to PIN)
      if (value != true) {
        ref.read(qrPayViewModelProvider.notifier).resetPaymentState();
      }
    });
  }

  Widget _buildPaymentConfirmView(
    BuildContext context,
    QrPayState state,
    NumberFormat currencyFormat,
  ) {
    final homeState = ref.watch(homeViewModelProvider);
    final validAccounts = _getAvailableAccounts(homeState);

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Xác nhận Thanh toán QR',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          if (state.errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                state.errorMessage!,
                style: GoogleFonts.inter(
                  color: Colors.redAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Details Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                _buildConfirmRow('Đơn vị nhận', state.selectedVendor ?? ''),
                _buildConfirmRow(
                  'Tài khoản nhận',
                  state.selectedTargetAccount ?? '',
                ),
                const Divider(color: Colors.white10, height: 24),
                _buildConfirmRow(
                  'Số tiền',
                  currencyFormat.format(state.paymentAmount),
                  isBold: true,
                ),
                _buildConfirmRow('Nội dung', state.paymentDesc ?? ''),
                const Divider(color: Colors.white10, height: 24),
                _buildConfirmRow(
                  'Phí giao dịch',
                  'Miễn phí',
                  color: Colors.greenAccent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tài khoản thanh toán',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.slate400,
            ),
          ),
          const SizedBox(height: 8),
          _buildAccountSelector(
            context: context,
            selectedAccount: state.selectedSourceAccount,
            accounts: validAccounts,
            onSelected: (account) {
              ref
                  .read(qrPayViewModelProvider.notifier)
                  .selectSourceAccount(account);
            },
            showBalance: true,
          ),
          const SizedBox(height: 32),
          // Continue Button to open PIN Pad
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                ); // Close confirm sheet, pass true to prevent state reset
                _showPinPadBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Thanh toán',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showPinPadBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(qrPayViewModelProvider);
            final QrPayViewModel viewModel = ref.read(
              qrPayViewModelProvider.notifier,
            );

            // Close the PIN sheet only after a successful payment, then reopen
            // the result sheet to show success state.
            if (state.paySuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pop(context); // Pop PIN sheet
                _showPaymentBottomSheet(); // Show loader/success sheet
              });
            }

            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(color: Colors.white12, width: 0.5),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Nhập mã PIN xác nhận',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final hasDigit = index < state.pin.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasDigit
                                  ? AppColors.accent
                                  : Colors.white.withValues(alpha: 0.15),
                            ),
                          );
                        }),
                      ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          state.errorMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.redAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      if (state.isPaying) ...[
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                      // Keypad
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.75,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          if (index == 9) {
                            return const SizedBox.shrink();
                          }
                          if (index == 11) {
                            return IconButton(
                              onPressed: state.isPaying
                                  ? null
                                  : viewModel.deleteLastPin,
                              icon: const Icon(
                                LucideIcons.delete,
                                color: Colors.white,
                                size: 24,
                              ),
                            );
                          }

                          final value = index == 10 ? 0 : index + 1;
                          return InkWell(
                            onTap: state.isPaying
                                ? null
                                : () => viewModel.updatePin(value.toString()),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.03),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                value.toString(),
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      final state = ref.read(qrPayViewModelProvider);
      if (!state.paySuccess) {
        ref.read(qrPayViewModelProvider.notifier).resetPaymentState();
      }
    });
  }

  Widget _buildPaymentLoadingView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.accent),
          const SizedBox(height: 24),
          Text(
            'Đang xử lý giao dịch...',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng không đóng ứng dụng lúc này.',
            style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSuccessView(
    QrPayState state,
    NumberFormat currencyFormat,
  ) {
    final transaction = state.paymentTransaction;
    final isPending = transaction?.status == TransactionStatus.pending;
    final statusColor = isPending ? Colors.orangeAccent : Colors.greenAccent;
    final statusIcon = isPending ? LucideIcons.clock3 : LucideIcons.check;
    final title = isPending
        ? 'Yêu cầu đang chờ duyệt'
        : 'Thanh toán thành công!';
    final statusText = isPending ? 'Chờ admin duyệt' : 'Thành công';
    final supportText = isPending
        ? 'Khoản chuyển tiền này vượt hạn mức 10.000.000đ nên cần admin phê duyệt. Bạn sẽ nhận thông báo ngay khi có kết quả.'
        : null;
    final createdAt = transaction?.createdAt ?? DateTime.now();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 48),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (supportText != null) ...[
            const SizedBox(height: 12),
            Text(
              supportText,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.slate400,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(state.paymentAmount),
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildConfirmRow('Đơn vị nhận', state.selectedVendor ?? ''),
                _buildConfirmRow(
                  'Mã giao dịch',
                  transaction?.referenceNumber ??
                      '#QR${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                ),
                _buildConfirmRow(
                  'Thời gian',
                  DateFormat('dd/MM/yyyy HH:mm:ss').format(createdAt),
                ),
                _buildConfirmRow('Trạng thái', statusText, color: statusColor),
                _buildConfirmRow(
                  'Nguồn thanh toán',
                  state.selectedSourceAccount?.accountNumber ?? '',
                ),
                _buildConfirmRow('Nội dung', state.paymentDesc ?? ''),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Refresh main account states and exit sheet
                ref.read(homeViewModelProvider.notifier).fetchData();
                ref.read(notificationViewModelProvider.notifier).refresh();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Hoàn tất',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 13),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: color ?? Colors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            const Icon(LucideIcons.alertTriangle, color: AppColors.error),
            const SizedBox(width: 10),
            Text(
              'Lỗi quét mã QR',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(color: AppColors.slate300, height: 1.4),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Đóng',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final validAccounts = _getAvailableAccounts(homeState);
    final state = ref.watch(qrPayViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'QR Pay',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.slate400,
          labelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 14),
          tabs: const [
            Tab(text: 'Quét mã QR'),
            Tab(text: 'Mã QR của tôi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildScanTab(state),
          _buildMyQrTab(homeState, state, validAccounts),
        ],
      ),
    );
  }

  Widget _buildScanTab(QrPayState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double viewfinderSize = constraints.maxWidth * 0.65;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(color: Colors.black.withValues(alpha: 0.4)),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Di chuyển camera đến vùng chứa mã QR',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),

                // Camera grid scan viewfinder box
                Stack(
                  children: [
                    Container(
                      width: viewfinderSize,
                      height: viewfinderSize,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.02),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),

                    Positioned.fill(
                      child: CustomPaint(painter: ViewfinderCornerPainter()),
                    ),

                    // laser line
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        final double topOffset =
                            _scanAnimation.value * (viewfinderSize - 4);
                        return Positioned(
                          top: topOffset,
                          left: 12,
                          right: 12,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.greenAccent.withValues(
                                    alpha: 0.8,
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Quick actions – chỉ 2 nút: Đèn Pin & Thư Viện
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlBtn(
                      state.isFlashOn ? LucideIcons.zap : LucideIcons.zapOff,
                      'Đèn Pin',
                      state.isFlashOn ? Colors.yellowAccent : Colors.white,
                      ref.read(qrPayViewModelProvider.notifier).toggleFlash,
                    ),
                    const SizedBox(width: 48),
                    _buildControlBtn(
                      LucideIcons.image,
                      'Thư Viện',
                      Colors.white,
                      _pickImageFromGallery,
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlBtn(
    IconData icon,
    String label,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.slate400,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMyQrTab(
    HomeState homeState,
    QrPayState state,
    List<AccountModel> accounts,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Select receive account
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Tài khoản nhận tiền',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.slate400,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildAccountSelector(
            context: context,
            selectedAccount: state.selectedReceiveAccount,
            accounts: accounts,
            onSelected: (account) {
              ref
                  .read(qrPayViewModelProvider.notifier)
                  .selectReceiveAccount(account);
            },
            showBalance: false,
          ),
          const SizedBox(height: 24),

          // QR Card
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        LucideIcons.landmark,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'NGÂN HÀNG ABC',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Real QR code using qr_flutter — encodes 'QRPAY:{accountNumber}'
                // so when someone scans/uploads this image the app can decode it correctly.
                RepaintBoundary(
                  key: _qrRepaintKey,
                  child: Container(
                    width: 216,
                    height: 216,
                    color: Colors
                        .white, // white bg for clean PNG export & scanner readability
                    padding: const EdgeInsets.all(12),
                    child: QrImageView(
                      data:
                          'QRPAY:${state.selectedReceiveAccount?.accountNumber ?? ''}',
                      version: QrVersions.auto,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color(0xFF0D1117),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color(0xFF0D1117),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Card details
                Text(
                  homeState.userName.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  state.selectedReceiveAccount?.accountNumber ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Quét mã này bằng bất kỳ ứng dụng ngân hàng nào\nđể chuyển tiền vào tài khoản này.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.slate400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionBtn(
                  LucideIcons.download,
                  'Lưu Mã QR',
                  _saveQrToGallery,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionBtn(
                  LucideIcons.share2,
                  'Chia Sẻ',
                  _shareQrCode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Render the QR RepaintBoundary widget to a PNG file in the temp directory.
  Future<File?> _renderQrToFile() async {
    try {
      final boundary =
          _qrRepaintKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 4.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      final bytes = byteData.buffer.asUint8List();
      final dir = await getTemporaryDirectory();
      final state = ref.read(qrPayViewModelProvider);
      final accountNumber = state.selectedReceiveAccount?.accountNumber ?? 'qr';
      final file = File('${dir.path}/qrpay_$accountNumber.png');
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      return null;
    }
  }

  /// Lưu mã QR vào thư viện ảnh của thiết bị (album QR Pay).
  Future<void> _saveQrToGallery() async {
    // Check & request permission
    final hasAccess = await Gal.hasAccess(toAlbum: true);
    if (!hasAccess) {
      await Gal.requestAccess(toAlbum: true);
    }

    final file = await _renderQrToFile();
    if (file == null || !mounted) return;

    try {
      await Gal.putImage(file.path, album: 'QR Pay');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                LucideIcons.checkCircle,
                color: Colors.black,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                'Đã lưu mã QR vào thư viện ảnh!',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lưu thất bại: ${e.toString()}',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Chia sẻ mã QR kèm thông tin tài khoản qua native share sheet.
  Future<void> _shareQrCode() async {
    final file = await _renderQrToFile();
    if (file == null || !mounted) return;

    final state = ref.read(qrPayViewModelProvider);
    final homeState = ref.read(homeViewModelProvider);
    final accountNumber = state.selectedReceiveAccount?.accountNumber ?? '';
    final ownerName = homeState.userName;

    final shareText =
        'Mã QR thanh toán của $ownerName\n'
        'Số tài khoản: $accountNumber\n'
        'Quét mã này bằng ứng dụng ngân hàng để chuyển tiền.';

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: shareText,
      subject: 'Mã QR Pay - $ownerName',
    );
  }

  Widget _buildActionBtn(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter to draw Viewfinder Corners
class ViewfinderCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 24.0;
    const double radius = 16.0;

    // Top Left Corner
    final pathTL = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, radius)
      ..arcToPoint(
        const Offset(radius, 0),
        radius: const Radius.circular(radius),
      )
      ..lineTo(cornerLength, 0);
    canvas.drawPath(pathTL, paint);

    // Top Right Corner
    final pathTR = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(
        Offset(size.width, radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(size.width, cornerLength);
    canvas.drawPath(pathTR, paint);

    // Bottom Left Corner
    final pathBL = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height - radius)
      ..arcToPoint(
        Offset(radius, size.height),
        radius: const Radius.circular(radius),
      )
      ..lineTo(cornerLength, size.height);
    canvas.drawPath(pathBL, paint);

    // Bottom Right Corner
    final pathBR = Path()
      ..moveTo(size.width - cornerLength, size.height)
      ..lineTo(size.width - radius, size.height)
      ..arcToPoint(
        Offset(size.width, size.height - radius),
        radius: const Radius.circular(radius),
      )
      ..lineTo(size.width, size.height - cornerLength);
    canvas.drawPath(pathBR, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Tự động format số tiền nhập vào dạng phân tách hàng nghìn bằng dấu chấm ( chuẩn Việt Nam )
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = '.';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Lọc bỏ mọi ký tự không phải số
    final numString = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numString.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final buffer = StringBuffer();
    for (int i = 0; i < numString.length; i++) {
      if (i > 0 && (numString.length - i) % 3 == 0) {
        buffer.write(separator);
      }
      buffer.write(numString[i]);
    }

    final formattedText = buffer.toString();

    // Tính toán lại vị trí con trỏ nhập liệu để tránh bị nhảy con trỏ
    int cursorPosition = newValue.selection.end;
    int digitCountBeforeCursor = 0;
    for (int i = 0; i < cursorPosition && i < newValue.text.length; i++) {
      if (newValue.text[i] != separator) {
        digitCountBeforeCursor++;
      }
    }

    int newCursorPosition = 0;
    int digitCount = 0;
    while (digitCount < digitCountBeforeCursor &&
        newCursorPosition < formattedText.length) {
      if (formattedText[newCursorPosition] != separator) {
        digitCount++;
      }
      newCursorPosition++;
    }

    if (newCursorPosition < formattedText.length &&
        formattedText[newCursorPosition] == separator) {
      newCursorPosition++;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
