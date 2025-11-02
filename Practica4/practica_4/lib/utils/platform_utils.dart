import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformUtils {
  /// Verifica si la app está corriendo en Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  
  /// Verifica si la app está corriendo en iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  
  /// Verifica si la app está corriendo en Web
  static bool get isWeb => kIsWeb;
  
  /// Verifica si Bluetooth está disponible en esta plataforma
  /// Solo Android soporta flutter_bluetooth_serial
  static bool get isBluetoothAvailable => isAndroid;
  
  /// Obtiene el nombre de la plataforma
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Desconocido';
  }
  
  /// Muestra info de la plataforma en consola
  static void printPlatformInfo() {
    print('🖥️ Plataforma: $platformName');
    print('📱 Android: $isAndroid');
    print('🍎 iOS: $isIOS');
    print('🌐 Web: $isWeb');
    print('📡 Bluetooth disponible: $isBluetoothAvailable');
  }
}