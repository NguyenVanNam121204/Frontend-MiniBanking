import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app/app_colors.dart';

class TransactionConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? color;

  const TransactionConfirmRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14)
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                color: color ?? Colors.white, 
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                fontSize: isBold ? 18 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
