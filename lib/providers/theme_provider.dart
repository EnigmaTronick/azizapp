import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  custom,
}

class ThemeProvider with ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.light;
  bool _isDarkMode = false; // Separate dark mode state for custom theme
  Color _customPrimaryColor = const Color(0xFF6C5CE7);
  Color _customAccentColor = const Color(0xFF00D4AA);
  
  static const String _themeModeKey = 'theme_mode';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _customPrimaryKey = 'custom_primary_color';
  static const String _customAccentKey = 'custom_accent_color';
  
  AppThemeMode get themeMode => _themeMode;
  Color get customPrimaryColor => _customPrimaryColor;
  Color get customAccentColor => _customAccentColor;
  
  bool get isDarkMode => _themeMode == AppThemeMode.dark || (_themeMode == AppThemeMode.custom && _isDarkMode);
  bool get isLightMode => _themeMode == AppThemeMode.light || (_themeMode == AppThemeMode.custom && !_isDarkMode);
  bool get isCustomMode => _themeMode == AppThemeMode.custom;
  
  ThemeProvider() {
    _loadTheme();
  }
  
  void setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _saveTheme();
  }
  
  void toggleTheme() {
    if (_themeMode == AppThemeMode.custom) {
      // For custom mode, just toggle the dark mode flag
      _isDarkMode = !_isDarkMode;
    } else if (_themeMode == AppThemeMode.light) {
      setThemeMode(AppThemeMode.dark);
    } else {
      setThemeMode(AppThemeMode.light);
    }
    notifyListeners();
    _saveTheme();
  }
  
  void setCustomColors({
    Color? primaryColor,
    Color? accentColor,
  }) async {
    if (primaryColor != null) {
      _customPrimaryColor = primaryColor;
    }
    if (accentColor != null) {
      _customAccentColor = accentColor;
    }
    
    // When setting custom colors, preserve current dark mode preference
    if (_themeMode == AppThemeMode.dark) {
      _isDarkMode = true;
    } else if (_themeMode == AppThemeMode.light) {
      _isDarkMode = false;
    }
    // If already in custom mode, keep existing _isDarkMode state
    
    _themeMode = AppThemeMode.custom;
    notifyListeners();
    await _saveTheme();
  }
  
  void resetToSystemTheme() async {
    _themeMode = AppThemeMode.light;
    _isDarkMode = false; // Reset dark mode state
    notifyListeners();
    await _saveTheme();
  }
  
  ThemeMode get materialThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.custom:
        // For custom mode, respect the isDarkMode setting
        return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }
  
  ColorScheme getCustomColorScheme(bool isDark) {
    if (_themeMode != AppThemeMode.custom) {
      return isDark 
        ? const ColorScheme.dark() 
        : const ColorScheme.light();
    }
    
    return ColorScheme.fromSeed(
      seedColor: _customPrimaryColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
      secondary: _customAccentColor,
    );
  }
  
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final themeIndex = prefs.getInt(_themeModeKey) ?? 0;
      _themeMode = AppThemeMode.values[themeIndex];
      
      _isDarkMode = prefs.getBool(_isDarkModeKey) ?? false;
      
      final primaryColorValue = prefs.getInt(_customPrimaryKey);
      if (primaryColorValue != null) {
        _customPrimaryColor = Color(primaryColorValue);
      }
      
      final accentColorValue = prefs.getInt(_customAccentKey);
      if (accentColorValue != null) {
        _customAccentColor = Color(accentColorValue);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }
  
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setInt(_themeModeKey, _themeMode.index);
      await prefs.setBool(_isDarkModeKey, _isDarkMode);
      await prefs.setInt(_customPrimaryKey, _customPrimaryColor.value);
      await prefs.setInt(_customAccentKey, _customAccentColor.value);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
}
