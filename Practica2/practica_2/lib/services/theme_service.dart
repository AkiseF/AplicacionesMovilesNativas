import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'isDarkModeEnabled';
  
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeService() {
    _loadTheme();
  }
  
  // Cargar tema desde SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }
  
  // Cambiar tema y guardarlo
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }
  
  // Colores para tema claro
  AppColors get lightColors => AppColors(
    // Colores para círculos interactivos
    circleColor: const Color.fromRGBO(255, 255, 255, 0.8),
    circleBorderColor: Colors.white,
    circleIconColor: const Color.fromARGB(255, 19, 168, 14),
    
    // Colores para PageIndicator
    pageIndicatorDotColor: const Color.fromARGB(255, 200, 200, 200),
    pageIndicatorActiveDotColor: const Color.fromARGB(255, 76, 175, 80),
    
    // Colores para pantallas de información Base2
    base2BackgroundColor: const Color(0xFF4CAF50),
    base2BorderColor: const Color(0xFF2E7D32),
    base2HeaderColor: const Color(0xFF2E7D32),
    
    // Colores para pantallas de información Base3
    base3BackgroundColor: const Color(0xFF4CAF50),
    base3BorderColor: const Color(0xFF2E7D32),
    base3HeaderColor: const Color(0xFF2E7D32),
    
    // Colores para SubAlterScreen (colores marrones)
    subAlterBackgroundColor: const Color(0xFF4CAF50),
    subAlterBorderColor: const Color(0xFF2E7D32),
    subAlterHeaderColor: const Color(0xFF2E7D32),
    
    // Colores para visitantes de Base3
    visitante1BackgroundColor: const Color(0xFF4CAF50),
    visitante1BorderColor: const Color(0xFF2E7D32),
    visitante1HeaderColor: const Color(0xFF2E7D32),
    
    visitante2BackgroundColor: const Color(0xFF4CAF50),
    visitante2BorderColor: const Color(0xFF2E7D32),
    visitante2HeaderColor: const Color(0xFF2E7D32),
    
    visitante5BackgroundColor: const Color(0xFF4CAF50),
    visitante5BorderColor: const Color(0xFF2E7D32),
    visitante5HeaderColor: const Color(0xFF2E7D32),
    
    // Colores para PVB3 Detalle (verde)
    pvb3DetalleBackgroundColor: const Color(0xFF4CAF50),
    pvb3DetalleBorderColor: const Color(0xFF2E7D32),
    pvb3DetalleHeaderColor: const Color(0xFF2E7D32),
    
    // Colores para MainScreen visitante (verde)
    mainVisitanteBackgroundColor: const Color(0xFF4CAF50),
    mainVisitanteBorderColor: const Color(0xFF2E7D32),
    mainVisitanteHeaderColor: const Color(0xFF2E7D32),
    
    // Colores para frutos (verde)
    frutoBackgroundColor: const Color(0xFF4CAF50),
    frutoBorderColor: const Color(0xFF2E7D32),
    frutoHeaderColor: const Color(0xFF2E7D32),
    
    // Colores para fruto no maduro (naranja)
    frutoNoMaduroBackgroundColor: const Color(0xFF4CAF50),
    frutoNoMaduroBorderColor: const Color(0xFF2E7D32),
    frutoNoMaduroHeaderColor: const Color(0xFF2E7D32),
    
    // Colores generales
    textColor: Colors.white,
    shadowColor: Colors.black,
  );
  
  // Colores para tema oscuro
  AppColors get darkColors => AppColors(
    // Colores para círculos interactivos (más brillantes para contrastar)
    circleColor: const Color.fromRGBO(80, 80, 80, 0.9),
    circleBorderColor: const Color(0xFFBB86FC),
    circleIconColor: const Color(0xFF03DAC6),
    
    // Colores para PageIndicator
    pageIndicatorDotColor: const Color.fromARGB(255, 100, 100, 100),
    pageIndicatorActiveDotColor: const Color(0xFFBB86FC),
    
    // Colores para pantallas de información Base2 (tema oscuro)
    base2BackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    base2BorderColor: const Color.fromARGB(255, 140, 89, 203),
    base2HeaderColor: const Color.fromARGB(255, 140, 89, 203),
    
    // Colores para pantallas de información Base3 (tema oscuro)
    base3BackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    base3BorderColor: const Color.fromARGB(255, 140, 89, 203),
    base3HeaderColor: const Color.fromARGB(255, 140, 89, 203),

    // Colores para SubAlterScreen (tema oscuro - marrones más oscuros)
    subAlterBackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    subAlterBorderColor: const Color.fromARGB(255, 140, 89, 203),
    subAlterHeaderColor: const Color.fromARGB(255, 140, 89, 203),
    
    // Colores para visitantes de Base3 (tema oscuro)
    visitante1BackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    visitante1BorderColor: const Color.fromARGB(255, 140, 89, 203),
    visitante1HeaderColor: const Color.fromARGB(255, 140, 89, 203),
    
    visitante2BackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    visitante2BorderColor: const Color.fromARGB(255, 140, 89, 203),
    visitante2HeaderColor: const Color.fromARGB(255, 140, 89, 203),

    visitante5BackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    visitante5BorderColor: const Color.fromARGB(255, 140, 89, 203), 
    visitante5HeaderColor: const Color.fromARGB(255, 140, 89, 203),
    
    // Colores para PVB3 Detalle (tema oscuro - verde más oscuro)
    pvb3DetalleBackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    pvb3DetalleBorderColor: const Color.fromARGB(255, 140, 89, 203),
    pvb3DetalleHeaderColor: const Color.fromARGB(255, 140, 89, 203),
    
    // Colores para MainScreen visitante (tema oscuro - verde más oscuro)
    mainVisitanteBackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    mainVisitanteBorderColor: const Color.fromARGB(255, 140, 89, 203),
    mainVisitanteHeaderColor: const Color.fromARGB(255, 140, 89, 203),

    // Colores para frutos (tema oscuro - verde más oscuro)  
    frutoBackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    frutoBorderColor: const Color.fromARGB(255, 140, 89, 203),
    frutoHeaderColor: const Color.fromARGB(255, 140, 89, 203),
    
    // Colores para fruto no maduro (tema oscuro - naranja más oscuro)
    frutoNoMaduroBackgroundColor: const Color.fromARGB(255, 72, 77, 73),
    frutoNoMaduroBorderColor: const Color.fromARGB(255, 140, 89, 203),
    frutoNoMaduroHeaderColor: const Color.fromARGB(255, 140, 89, 203),
    
    // Colores generales
    textColor: Colors.white,
    shadowColor: const Color(0xFF121212),
  );
  
  // Obtener colores actuales según el tema
  AppColors get currentColors => _isDarkMode ? darkColors : lightColors;
}

class AppColors {
  final Color circleColor;
  final Color circleBorderColor;
  final Color circleIconColor;
  final Color pageIndicatorDotColor;
  final Color pageIndicatorActiveDotColor;
  final Color base2BackgroundColor;
  final Color base2BorderColor;
  final Color base2HeaderColor;
  final Color base3BackgroundColor;
  final Color base3BorderColor;
  final Color base3HeaderColor;
  final Color subAlterBackgroundColor;
  final Color subAlterBorderColor;
  final Color subAlterHeaderColor;
  final Color visitante1BackgroundColor;
  final Color visitante1BorderColor;
  final Color visitante1HeaderColor;
  final Color visitante2BackgroundColor;
  final Color visitante2BorderColor;
  final Color visitante2HeaderColor;
  final Color visitante5BackgroundColor;
  final Color visitante5BorderColor;
  final Color visitante5HeaderColor;
  final Color pvb3DetalleBackgroundColor;
  final Color pvb3DetalleBorderColor;
  final Color pvb3DetalleHeaderColor;
  final Color mainVisitanteBackgroundColor;
  final Color mainVisitanteBorderColor;
  final Color mainVisitanteHeaderColor;
  final Color frutoBackgroundColor;
  final Color frutoBorderColor;
  final Color frutoHeaderColor;
  final Color frutoNoMaduroBackgroundColor;
  final Color frutoNoMaduroBorderColor;
  final Color frutoNoMaduroHeaderColor;
  final Color textColor;
  final Color shadowColor;
  
  AppColors({
    required this.circleColor,
    required this.circleBorderColor,
    required this.circleIconColor,
    required this.pageIndicatorDotColor,
    required this.pageIndicatorActiveDotColor,
    required this.base2BackgroundColor,
    required this.base2BorderColor,
    required this.base2HeaderColor,
    required this.base3BackgroundColor,
    required this.base3BorderColor,
    required this.base3HeaderColor,
    required this.subAlterBackgroundColor,
    required this.subAlterBorderColor,
    required this.subAlterHeaderColor,
    required this.visitante1BackgroundColor,
    required this.visitante1BorderColor,
    required this.visitante1HeaderColor,
    required this.visitante2BackgroundColor,
    required this.visitante2BorderColor,
    required this.visitante2HeaderColor,
    required this.visitante5BackgroundColor,
    required this.visitante5BorderColor,
    required this.visitante5HeaderColor,
    required this.pvb3DetalleBackgroundColor,
    required this.pvb3DetalleBorderColor,
    required this.pvb3DetalleHeaderColor,
    required this.mainVisitanteBackgroundColor,
    required this.mainVisitanteBorderColor,
    required this.mainVisitanteHeaderColor,
    required this.frutoBackgroundColor,
    required this.frutoBorderColor,
    required this.frutoHeaderColor,
    required this.frutoNoMaduroBackgroundColor,
    required this.frutoNoMaduroBorderColor,
    required this.frutoNoMaduroHeaderColor,
    required this.textColor,
    required this.shadowColor,
  });
}