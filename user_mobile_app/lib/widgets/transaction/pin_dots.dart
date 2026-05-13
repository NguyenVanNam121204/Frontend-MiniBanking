import 'package:flutter/material.dart';
import '../../core/app/app_colors.dart';

class PinDots extends StatelessWidget {
  final int length;
  final int maxLength;

  const PinDots({
    super.key,
    required this.length,
    this.maxLength = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        bool isFilled = length > index;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.accent : Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: isFilled ? AppColors.accent : Colors.white.withValues(alpha: 0.2),
              width: 2,
            ),
            boxShadow: isFilled ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ] : [],
          ),
        );
      }),
    );
  }
}
