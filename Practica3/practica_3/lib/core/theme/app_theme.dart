import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Configuración de temas para la aplicación
class AppThemes {
  
  /// Tema Guinda (IPN)
  static ThemeData get guindaLight {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(AppConstants.ipnGuindaColor),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Color(AppConstants.ipnGuindaColor),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(AppConstants.ipnGuindaColor),
        foregroundColor: Colors.white,
      ),
    );
  }
  
  static ThemeData get guindaDark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(AppConstants.ipnGuindaColor),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
      ),
    );
  }
  
  /// Tema Azul (ESCOM)
  static ThemeData get azulLight {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(AppConstants.escomAzulColor),
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Color(AppConstants.escomAzulColor),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(AppConstants.escomAzulColor),
        foregroundColor: Colors.white,
      ),
    );
  }
  
  static ThemeData get azulDark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(AppConstants.escomAzulColor),
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
      ),
    );
  }
  
  /// Obtener tema según configuración
  static ThemeData getTheme(AppTheme appTheme, bool isDark) {
    switch (appTheme) {
      case AppTheme.guinda:
        return isDark ? guindaDark : guindaLight;
      case AppTheme.azul:
        return isDark ? azulDark : azulLight;
    }
  }
}