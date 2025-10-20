import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:mime/mime.dart';

class IntentUtils {
  /// Abre un archivo con la aplicación por defecto del sistema
  static Future<bool> openFileWithDefaultApp(String filePath) async {
    try {
      final file = File(filePath);
      
      // Verificar que el archivo exista
      if (!await file.exists()) {
        throw Exception('El archivo no existe');
      }
      
      // Intentar abrir con la app por defecto
      final result = await OpenFilex.open(filePath);
      
      switch (result.type) {
        case ResultType.done:
          return true;
        case ResultType.noAppToOpen:
          throw Exception('No hay aplicación disponible para abrir este tipo de archivo');
        case ResultType.fileNotFound:
          throw Exception('Archivo no encontrado');
        case ResultType.permissionDenied:
          throw Exception('Permisos denegados para abrir el archivo');
        case ResultType.error:
          throw Exception('Error al abrir el archivo: ${result.message}');
      }
    } catch (e) {
      print('Error abriendo archivo: $e');
      return false;
    }
  }
  
  /// Obtiene el tipo MIME de un archivo
  static String? getMimeType(String filePath) {
    return lookupMimeType(filePath);
  }
  
  /// Verifica si un archivo puede ser abierto por la aplicación
  static bool canOpenInApp(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
    
    // Tipos que nuestra app puede abrir
    const supportedText = ['txt', 'md', 'log', 'json', 'xml', 'csv', 'html', 'css', 'js', 'dart'];
    const supportedImages = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    
    return supportedText.contains(extension) || supportedImages.contains(extension);
  }
  
  /// Determina la acción recomendada para un archivo
  static FileOpenAction getRecommendedAction(String filePath) {
    if (canOpenInApp(filePath)) {
      return FileOpenAction.openInApp;
    }
    
    final mimeType = getMimeType(filePath);
    if (mimeType != null) {
      return FileOpenAction.openWithIntent;
    }
    
    return FileOpenAction.showInfo;
  }
}

enum FileOpenAction {
  openInApp,
  openWithIntent,
  showInfo,
}