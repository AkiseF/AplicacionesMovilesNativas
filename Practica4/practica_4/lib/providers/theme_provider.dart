import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme {
  red,     // Stationary Guard
  blue,    // Scouting Legion  
  green,   // Military Police
}

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'selected_theme';
  static const String _darkModeKey = 'dark_mode';
  
  AppTheme _currentTheme = AppTheme.red;
  bool _isDarkMode = false;

  AppTheme get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  // Load saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    final darkMode = prefs.getBool(_darkModeKey) ?? false;
    
    _currentTheme = AppTheme.values[themeIndex];
    _isDarkMode = darkMode;
    notifyListeners();
  }

  // Save theme to SharedPreferences
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _currentTheme.index);
    await prefs.setBool(_darkModeKey, _isDarkMode);
  }

  // Change the current theme
  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    await _saveTheme();
    notifyListeners();
  }

  // Toggle dark mode manually
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _saveTheme();
    notifyListeners();
  }

  // Set dark mode explicitly
  Future<void> setDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    await _saveTheme();
    notifyListeners();
  }

  // Get theme data based on current theme and dark mode setting
  ThemeData getThemeData() {
    Color primaryColor;
    Color primaryColorLight;
    Color primaryColorDark;
    
    switch (_currentTheme) {
      case AppTheme.red:
        primaryColor = const Color(0xFFAA281A); // Stationary Guard
        primaryColorLight = const Color(0xFFD32F2F);
        primaryColorDark = const Color(0xFF8B0000);
        break;
      case AppTheme.blue:
        primaryColor = const Color(0xFF10357B); // Scouting Legion
        primaryColorLight = const Color(0xFF1976D2);
        primaryColorDark = const Color(0xFF0D47A1);
        break;
      case AppTheme.green:
        primaryColor = const Color(0xFF1D4F34); // Military Police
        primaryColorLight = const Color(0xFF388E3C);
        primaryColorDark = const Color(0xFF1B5E20);
        break;
    }

    final baseTheme = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    
    return baseTheme.copyWith(
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: primaryColor,
        secondary: primaryColorLight,
      ),
      // Solo el fondo debe cambiar según el modo claro/oscuro - COLORES NEUTROS
      scaffoldBackgroundColor: _isDarkMode 
          ? Colors.black              // Fondo negro para modo oscuro
          : Colors.white,             // Fondo blanco para modo claro
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor, // El AppBar siempre usa el color del tema
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Botones siempre usan el color del tema
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Cards mantienen colores neutros, el tema se aplicará vía ThemedCard
        color: _isDarkMode 
            ? const Color(0xFF1E1E1E)  // Cards oscuras en modo oscuro
            : Colors.white,           // Cards blancas en modo claro
        // Sin color de tema en las cards por defecto
        margin: const EdgeInsets.all(4),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor, // Botones outlined usan color del tema
          side: BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        headlineLarge: TextStyle(
          color: primaryColor, // Títulos usan color del tema
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: primaryColor, // Títulos usan color del tema
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: _isDarkMode ? Colors.white : const Color(0xFF2F2F2F),
        ),
        bodyMedium: TextStyle(
          color: _isDarkMode ? Colors.white70 : const Color(0xFF2F2F2F),
        ),
      ),
      iconTheme: IconThemeData(
        color: primaryColor, // Iconos usan color del tema
      ),
    );
  }

  // Get theme display name
  String getThemeName(AppTheme theme) {
    switch (theme) {
      case AppTheme.red:
        return 'Stationary Guard';
      case AppTheme.blue:
        return 'Scouting Legion';
      case AppTheme.green:
        return 'Military Police';
    }
  }

  // Get gradient colors for home screen - COLORES NEUTROS
  List<Color> getGradientColors() {
    // Fondo uniforme sin gradiente para evitar división visual
    if (_isDarkMode) {
      return [Colors.black, Colors.black]; // Fondo negro uniforme
    } else {
      return [Colors.white, Colors.white]; // Fondo blanco uniforme
    }
  }
}