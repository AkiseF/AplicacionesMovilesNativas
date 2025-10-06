import 'package:permission_handler/permission_handler.dart';

/// Utilidades para manejo de permisos
class PermissionUtils {
  
  /// Verificar si tenemos permisos de almacenamiento
  static Future<bool> hasStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }
  
  /// Solicitar permisos de almacenamiento
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }
  
  /// Verificar permisos de gestión de archivos (Android 11+)
  static Future<bool> hasManageStoragePermission() async {
    final status = await Permission.manageExternalStorage.status;
    return status.isGranted;
  }
  
  /// Solicitar permisos de gestión de archivos (Android 11+)
  static Future<bool> requestManageStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
  
  /// Verificar todos los permisos necesarios
  static Future<bool> checkAllPermissions() async {
    // Para Android 11+ necesitamos permisos especiales
    if (await hasManageStoragePermission()) {
      return true;
    }
    
    // Para versiones anteriores, usar permisos de almacenamiento estándar
    return await hasStoragePermission();
  }
  
  /// Solicitar todos los permisos necesarios
  static Future<bool> requestAllPermissions() async {
    // Intentar primero con permisos de gestión de archivos
    if (await requestManageStoragePermission()) {
      return true;
    }
    
    // Si no se puede, usar permisos de almacenamiento estándar
    return await requestStoragePermission();
  }
  
  /// Verificar si el permiso fue denegado permanentemente
  static Future<bool> isPermissionPermanentlyDenied() async {
    final status = await Permission.storage.status;
    return status.isPermanentlyDenied;
  }
  
  /// Abrir configuración de la app
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}