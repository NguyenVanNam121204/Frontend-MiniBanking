import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF1E3A8A); // Blue 900
  static const Color secondary = Color(0xFF3B82F6); // Blue 500
  static const Color accent = Color(0xFF60A5FA); // Blue 400
  
  // Neutral Colors (Slate equivalent)
  static const Color background = Color(0xFF0F172A); // Same as bgDark
  static const Color bgDark = Color(0xFF0F172A); // Slate 900
  static const Color surface = Color(0xFF1E293B); // Slate 800
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  // Functional Colors
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
}
