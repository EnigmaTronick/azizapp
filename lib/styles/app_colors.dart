import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF5B4BD6);
  static const Color primaryLight = Color(0xFF8A7FF8);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFE2E8F0);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  
  // Accent Colors
  static const Color accent = Color(0xFF00D4AA);
  static const Color accentSecondary = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFEBB00);
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  
  // Navigation Colors
  static const Color navBarLight = Color(0xFFFFFFFF);
  static const Color navBarDark = Color(0xFF1E293B);
  static const Color navIconActive = Color(0xFF6C5CE7);
  static const Color navIconInactive = Color(0xFF64748B);
  
  // Sidebar Colors
  static const Color sidebarLight = Color(0xFFF1F5F9);
  static const Color sidebarDark = Color(0xFF0F172A);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF00D4AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient darkSurfaceGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Theme-aware color getters
  static Color getPrimaryColor(BuildContext context) {
    try {
      final themeProvider = context.read<ThemeProvider>();
      return themeProvider.isCustomMode ? themeProvider.customPrimaryColor : primary;
    } catch (e) {
      return primary;
    }
  }
  
  static Color getAccentColor(BuildContext context) {
    try {
      final themeProvider = context.read<ThemeProvider>();
      return themeProvider.isCustomMode ? themeProvider.customAccentColor : accent;
    } catch (e) {
      return accent;
    }
  }
  
  static LinearGradient getPrimaryGradient(BuildContext context) {
    final primaryColor = getPrimaryColor(context);
    final accentColor = getAccentColor(context);
    return LinearGradient(
      colors: [primaryColor, accentColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
