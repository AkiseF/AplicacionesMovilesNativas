import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Provider para gestionar el tema de la aplicación
class ThemeProvider extends ChangeNotifier {
  AppTheme _appTheme = AppTheme.guinda;
  ThemeMode _themeMode = ThemeMode.system;

  AppTheme get appTheme => _appTheme;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemePreference();
  }

  /// Cambiar tema de la aplicación
  Future<void> setAppTheme(AppTheme theme) async {
    _appTheme = theme;
    await _saveThemePreference();
    notifyListeners();
  }

  /// Cambiar modo de tema (claro/oscuro)
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveThemePreference();
    notifyListeners();
  }

  /// Alternar entre tema claro y oscuro
  Future<void> toggleThemeMode() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      // Si está en system, cambiar a light
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Cargar preferencias del tema
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Cargar tema de color
      final themeIndex = prefs.getInt('app_theme') ?? 0;
      _appTheme = AppTheme.values[themeIndex];
      
      // Cargar modo de tema
      final themeModeIndex = prefs.getInt('theme_mode') ?? 0;
      _themeMode = ThemeMode.values[themeModeIndex];
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error cargando preferencias de tema: $e');
    }
  }

  /// Guardar preferencias del tema
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('app_theme', _appTheme.index);
      await prefs.setInt('theme_mode', _themeMode.index);
    } catch (e) {
      debugPrint('Error guardando preferencias de tema: $e');
    }
  }

  /// Verificar si está en modo oscuro
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Obtener nombre del tema actual
  String get themeDisplayName {
    switch (_appTheme) {
      case AppTheme.guinda:
        return 'Tema Guinda (IPN)';
      case AppTheme.azul:
        return 'Tema Azul (ESCOM)';
    }
  }

  /// Obtener nombre del modo de tema actual
  String get themeModeDisplayName {
    switch (_themeMode) {
      case ThemeMode.system:
        return 'Sistema';
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
    }
  }
}