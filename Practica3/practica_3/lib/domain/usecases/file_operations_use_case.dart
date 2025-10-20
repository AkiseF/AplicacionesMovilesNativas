import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../repositories/file_repository.dart';
import '../../core/utils/intent_utils.dart';

/// Caso de uso para operaciones avanzadas de archivos
class FileOperationsUseCase {
  final FileRepository _fileRepository;

  FileOperationsUseCase(this._fileRepository);

  /// Renombrar archivo o directorio
  Future<bool> renameFile(String oldPath, String newName) async {
    try {
      if (newName.trim().isEmpty) {
        throw Exception('El nombre no puede estar vacío');
      }

      // Validar caracteres válidos
      final invalidChars = RegExp(r'[<>:"/\\|?*]');
      if (invalidChars.hasMatch(newName)) {
        throw Exception('El nombre contiene caracteres no válidos');
      }

      return await _fileRepository.renameFile(oldPath, newName);
    } catch (e) {
      throw Exception('Error al renombrar: $e');
    }
  }

  /// Copiar archivo o directorio
  Future<bool> copyFile(String sourcePath, String destinationPath) async {
    try {
      // Verificar que el archivo origen existe
      final exists = await _fileRepository.fileExists(sourcePath);
      if (!exists) {
        throw Exception('El archivo origen no existe');
      }

      // Verificar que el destino no existe
      final destExists = await _fileRepository.fileExists(destinationPath);
      if (destExists) {
        throw Exception('Ya existe un archivo en el destino');
      }

      return await _fileRepository.copyFile(sourcePath, destinationPath);
    } catch (e) {
      throw Exception('Error al copiar: $e');
    }
  }

  /// Mover archivo o directorio
  Future<bool> moveFile(String sourcePath, String destinationPath) async {
    try {
      // Verificar que el archivo origen existe
      final exists = await _fileRepository.fileExists(sourcePath);
      if (!exists) {
        throw Exception('El archivo origen no existe');
      }

      // Verificar que el destino no existe
      final destExists = await _fileRepository.fileExists(destinationPath);
      if (destExists) {
        throw Exception('Ya existe un archivo en el destino');
      }

      return await _fileRepository.moveFile(sourcePath, destinationPath);
    } catch (e) {
      throw Exception('Error al mover: $e');
    }
  }

  /// Eliminar archivo o directorio
  Future<bool> deleteFile(String path) async {
    try {
      // Verificar que el archivo existe
      final exists = await _fileRepository.fileExists(path);
      if (!exists) {
        throw Exception('El archivo no existe');
      }

      return await _fileRepository.deleteFile(path);
    } catch (e) {
      throw Exception('Error al eliminar: $e');
    }
  }

  /// Eliminar múltiples archivos
  Future<List<String>> deleteMultipleFiles(List<String> paths) async {
    final failedDeletions = <String>[];

    for (final path in paths) {
      try {
        final success = await deleteFile(path);
        if (!success) {
          failedDeletions.add(path);
        }
      } catch (e) {
        failedDeletions.add(path);
      }
    }

    return failedDeletions;
  }

  /// Obtener tamaño total de un directorio
  Future<int> getDirectorySize(String path) async {
    try {
      final files = await _fileRepository.listDirectory(path);
      int totalSize = 0;

      for (final file in files) {
        if (file.isDirectory) {
          totalSize += await getDirectorySize(file.path);
        } else {
          totalSize += file.size;
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Contar archivos en un directorio
  Future<Map<String, int>> getDirectoryStats(String path) async {
    try {
      final files = await _fileRepository.listDirectory(path);
      int fileCount = 0;
      int folderCount = 0;
      int totalSize = 0;

      for (final file in files) {
        if (file.isDirectory) {
          folderCount++;
          final subStats = await getDirectoryStats(file.path);
          fileCount += subStats['files'] ?? 0;
          folderCount += subStats['folders'] ?? 0;
          totalSize += subStats['size'] ?? 0;
        } else {
          fileCount++;
          totalSize += file.size;
        }
      }

      return {
        'files': fileCount,
        'folders': folderCount,
        'size': totalSize,
      };
    } catch (e) {
      return {'files': 0, 'folders': 0, 'size': 0};
    }
  }

  /// Compartir archivo
  Future<void> shareFile(String filePath) async {
    try {
      await Share.shareXFiles([XFile(filePath)]);
    } catch (e) {
      throw Exception('Error al compartir archivo: $e');
    }
  }

  /// Obtener información del archivo
  Future<String> getFileInfo(String filePath) async {
    try {
      final file = File(filePath);
      final stat = await file.stat();
      final size = stat.size;
      final modified = stat.modified;
      final created = stat.changed;
      
      final sizeFormatted = _formatBytes(size);
      final modifiedFormatted = _formatDate(modified);
      final createdFormatted = _formatDate(created);
      
      return '''
Ruta: $filePath
Tamaño: $sizeFormatted
Modificado: $modifiedFormatted
Creado: $createdFormatted
''';
    } catch (e) {
      throw Exception('Error obteniendo información: $e');
    }
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = (bytes.bitLength - 1) ~/ 10;
    return '${(bytes / (1 << (i * 10))).toStringAsFixed(1)} ${suffixes[i]}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Abre un archivo con la aplicación apropiada
  Future<bool> openFile(String filePath) async {
    final action = IntentUtils.getRecommendedAction(filePath);
    
    switch (action) {
      case FileOpenAction.openInApp:
        // Será manejado por el UI (navegación a viewers)
        return true;
      case FileOpenAction.openWithIntent:
        return await IntentUtils.openFileWithDefaultApp(filePath);
      case FileOpenAction.showInfo:
        // Mostrar información del archivo
        return true;
    }
  }
  
  /// Verifica si un archivo puede ser abierto por la aplicación
  bool canOpenInApp(String filePath) {
    return IntentUtils.canOpenInApp(filePath);
  }
}