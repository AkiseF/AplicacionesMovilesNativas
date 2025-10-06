import 'dart:io';
import 'package:path/path.dart' as path_utils;
import '../constants/app_constants.dart';

/// Utilidades para manejo de archivos
class FileUtils {
  
  /// Obtener el tipo de archivo basado en la extensión
  static FileType getFileType(String filePath) {
    final extension = path_utils.extension(filePath).toLowerCase();
    
    if (AppConstants.supportedTextExtensions.contains(extension)) {
      return FileType.text;
    } else if (AppConstants.supportedImageExtensions.contains(extension)) {
      return FileType.image;
    } else if (AppConstants.supportedVideoExtensions.contains(extension)) {
      return FileType.video;
    } else if (AppConstants.supportedAudioExtensions.contains(extension)) {
      return FileType.audio;
    } else if (extension == '.pdf' || extension == '.doc' || extension == '.docx') {
      return FileType.document;
    } else {
      return FileType.other;
    }
  }
  
  /// Formatear tamaño de archivo
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    
    double size = bytes / 1024;
    List<String> units = ['KB', 'MB', 'GB', 'TB'];
    
    for (int i = 0; i < units.length; i++) {
      if (size < 1024) {
        return '${size.toStringAsFixed(2)} ${units[i]}';
      }
      size /= 1024;
    }
    
    return '${size.toStringAsFixed(2)} TB';
  }
  
  /// Formatear fecha de modificación
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Hoy ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ayer ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
  
  /// Verificar si un archivo es una imagen
  static bool isImageFile(String filePath) {
    return getFileType(filePath) == FileType.image;
  }
  
  /// Verificar si un archivo es de texto
  static bool isTextFile(String filePath) {
    return getFileType(filePath) == FileType.text;
  }
  
  /// Obtener icono para tipo de archivo
  static String getFileIcon(String filePath, {bool isDirectory = false}) {
    if (isDirectory) return '📁';
    
    final fileType = getFileType(filePath);
    final extension = path_utils.extension(filePath).toLowerCase();
    
    switch (fileType) {
      case FileType.text:
        return '📄';
      case FileType.image:
        return '🖼️';
      case FileType.video:
        return '🎥';
      case FileType.audio:
        return '🎵';
      case FileType.document:
        return '📋';
      case FileType.folder:
        return '📁';
      case FileType.other:
        switch (extension) {
          case '.zip':
          case '.rar':
          case '.7z':
            return '📦';
          case '.exe':
          case '.msi':
            return '⚙️';
          case '.apk':
            return '📱';
          default:
            return '📄';
        }
    }
  }
  
  /// Verificar si se puede previsualizar el archivo
  static bool canPreview(String filePath) {
    final fileType = getFileType(filePath);
    return fileType == FileType.text || fileType == FileType.image;
  }
  
  /// Obtener nombre del archivo sin extensión
  static String getFileNameWithoutExtension(String filePath) {
    return path_utils.basenameWithoutExtension(filePath);
  }
  
  /// Validar nombre de archivo/carpeta
  static bool isValidFileName(String name) {
    if (name.isEmpty) return false;
    
    // Caracteres no permitidos en nombres de archivo
    final invalidChars = RegExp(r'[<>:"/\\|?*]');
    return !invalidChars.hasMatch(name) && name.trim() == name;
  }
  
  /// Obtener extensión del archivo
  static String? getFileExtension(String filePath) {
    final extension = path_utils.extension(filePath);
    return extension.isEmpty ? null : extension;
  }

  /// Generar nombre único para archivo
  static String generateUniqueFileName(String directory, String originalName) {
    String baseName = getFileNameWithoutExtension(originalName);
    String extension = path_utils.extension(originalName);
    String newName = originalName;
    int counter = 1;
    
    while (File(path_utils.join(directory, newName)).existsSync()) {
      newName = '${baseName}_$counter$extension';
      counter++;
    }
    
    return newName;
  }
}