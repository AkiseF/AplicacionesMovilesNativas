#!/usr/bin/env dart

/*
Este script actualiza automáticamente las pantallas finales para usar el sistema de temas.
Aplica las transformaciones necesarias para que cada pantalla responda a los temas claro/oscuro.
*/

import 'dart:io';

void main() {
  final screenUpdates = [
    {
      'file': 'lib/screens/Main/SubMainScreen_FrutoMaduro.dart',
      'bgColorVar': 'frutoBackgroundColor',
      'borderColorVar': 'frutoBorderColor', 
      'headerColorVar': 'frutoHeaderColor',
      'originalBg': '0xFF8BC34A',
      'originalBorder': '0xFF689F38',
      'originalHeader': '0xFF689F38'
    },
    {
      'file': 'lib/screens/Main/SubMainScreen_FrutoNoMaduro.dart',
      'bgColorVar': 'frutoBackgroundColor',
      'borderColorVar': 'frutoBorderColor',
      'headerColorVar': 'frutoHeaderColor', 
      'originalBg': '0xFF8BC34A',
      'originalBorder': '0xFF689F38',
      'originalHeader': '0xFF689F38'
    }
  ];

  for (final update in screenUpdates) {
    print('Actualizando ${update['file']}...');
    updateScreenFile(update);
  }
  
  print('✅ Todas las pantallas han sido actualizadas para usar temas!');
}

void updateScreenFile(Map<String, String> config) {
  final file = File(config['file']!);
  if (!file.existsSync()) {
    print('❌ Archivo no encontrado: ${config['file']}');
    return;
  }
  
  String content = file.readAsStringSync();
  
  // Agregar imports
  if (!content.contains('import \'package:provider/provider.dart\';')) {
    content = content.replaceFirst(
      'import \'package:flutter/material.dart\';',
      'import \'package:flutter/material.dart\';\nimport \'package:provider/provider.dart\';\nimport \'../../services/theme_service.dart\';'
    );
  }
  
  // Actualizar el método build con Consumer
  final classMatch = RegExp(r'class (\w+) extends StatelessWidget').firstMatch(content);
  if (classMatch != null) {
    final className = classMatch.group(1);
    
    // Reemplazar el build method
    content = content.replaceFirst(
      RegExp(r'@override\s+Widget build\(BuildContext context\) \{\s+return Scaffold\('),
      '''@override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        final colors = themeService.currentColors;
        
        return Scaffold('''
    );
    
    // Actualizar colores en decoraciones
    content = content.replaceAll(
      'Color(${config['originalBg']})',
      'colors.${config['bgColorVar']}'
    );
    
    content = content.replaceAll(
      'const Color(${config['originalBorder']})',
      'colors.${config['borderColorVar']}'
    );
    
    content = content.replaceAll(
      'const Color(${config['originalHeader']})',
      'colors.${config['headerColorVar']}'
    );
    
    content = content.replaceAll(
      'Colors.black.withOpacity(0.5)',
      'colors.shadowColor.withOpacity(0.5)'
    );
    
    // Cerrar Consumer correctamente
    content = content.replaceAll(
      RegExp(r'\s+\);\s+\}\s+\}$'),
      '''
    );
      },
    );
  }
}'''
    );
  }
  
  file.writeAsStringSync(content);
  print('✅ ${config['file']} actualizado');
}