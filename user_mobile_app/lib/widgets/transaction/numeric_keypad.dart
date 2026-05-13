import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NumericKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onDeletePressed;
  final bool isLocked;

  const NumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDeletePressed,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 24),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 24),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 64), // Placeholder for alignment
              _buildKey('0'),
              _buildDeleteKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) => _buildKey(key)).toList(),
    );
  }

  Widget _buildKey(String label) {
    return InkWell(
      onTap: isLocked ? null : () => onDigitPressed(label),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: isLocked ? Colors.white24 : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return InkWell(
      onTap: isLocked ? null : onDeletePressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        child: Icon(
          LucideIcons.delete,
          color: isLocked ? Colors.white24 : Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
