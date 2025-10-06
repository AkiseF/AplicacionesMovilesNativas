import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path_utils;
import 'package:path_provider/path_provider.dart';
import '../models/file_model.dart';
import '../../domain/entities/file_entity.dart';

/// Datasource local para operaciones con archivos del sistema
class LocalFileDataSource {
  
  /// Listar contenido de un directorio
  Future<List<FileModel>> listDirectory(String path) async {
    try {
      final directory = Directory(path);
      
      if (!await directory.exists()) {
        throw Exception('El directorio no existe: $path');
      }
      
      final entities = await directory.list().toList();
      final fileModels = <FileModel>[];
      
      for (final entity in entities) {
        try {
          final fileEntity = FileEntity.fromFileSystemEntity(entity);
          fileModels.add(FileModel.fromEntity(fileEntity));
        } catch (e) {
          // Continuar si hay error con un archivo específico
          debugPrint('Error procesando archivo ${entity.path}: $e');
        }
      }
      
      return fileModels;
    } catch (e) {
      throw Exception('Error al listar directorio: $e');
    }
  }
  
  /// Obtener información de un archivo específico
  Future<FileModel?> getFileInfo(String path) async {
    try {
      final file = File(path);
      final directory = Directory(path);
      
      FileSystemEntity entity;
      if (await file.exists()) {
        entity = file;
      } else if (await directory.exists()) {
        entity = directory;
      } else {
        return null;
      }
      
      final fileEntity = FileEntity.fromFileSystemEntity(entity);
      return FileModel.fromEntity(fileEntity);
    } catch (e) {
      return null;
    }
  }
  
  /// Crear un nuevo directorio
  Future<bool> createDirectory(String parentPath, String name) async {
    try {
      final newPath = path_utils.join(parentPath, name);
      final directory = Directory(newPath);
      
      if (await directory.exists()) {
        throw Exception('Ya existe un directorio con ese nombre');
      }
      
      await directory.create(recursive: true);
      return true;
    } catch (e) {
      throw Exception('Error al crear directorio: $e');
    }
  }
  
  /// Renombrar archivo o directorio
  Future<bool> renameFile(String oldPath, String newName) async {
    try {
      final file = File(oldPath);
      final directory = Directory(oldPath);
      
      String parentPath = path_utils.dirname(oldPath);
      String newPath = path_utils.join(parentPath, newName);
      
      if (await file.exists()) {
        await file.rename(newPath);
      } else if (await directory.exists()) {
        await directory.rename(newPath);
      } else {
        throw Exception('El archivo no existe');
      }
      
      return true;
    } catch (e) {
      throw Exception('Error al renombrar: $e');
    }
  }
  
  /// Copiar archivo
  Future<bool> copyFile(String sourcePath, String destinationPath) async {
    try {
      final sourceFile = File(sourcePath);
      final sourceDir = Directory(sourcePath);
      
      if (await sourceFile.exists()) {
        await sourceFile.copy(destinationPath);
      } else if (await sourceDir.exists()) {
        // Para directorios, copiamos recursivamente
        await _copyDirectory(sourceDir, Directory(destinationPath));
      } else {
        throw Exception('El archivo fuente no existe');
      }
      
      return true;
    } catch (e) {
      throw Exception('Error al copiar: $e');
    }
  }
  
  /// Mover archivo o directorio
  Future<bool> moveFile(String sourcePath, String destinationPath) async {
    try {
      final file = File(sourcePath);
      final directory = Directory(sourcePath);
      
      if (await file.exists()) {
        await file.rename(destinationPath);
      } else if (await directory.exists()) {
        await directory.rename(destinationPath);
      } else {
        throw Exception('El archivo fuente no existe');
      }
      
      return true;
    } catch (e) {
      throw Exception('Error al mover: $e');
    }
  }
  
  /// Eliminar archivo o directorio
  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      final directory = Directory(path);
      
      if (await file.exists()) {
        await file.delete();
      } else if (await directory.exists()) {
        await directory.delete(recursive: true);
      } else {
        throw Exception('El archivo no existe');
      }
      
      return true;
    } catch (e) {
      throw Exception('Error al eliminar: $e');
    }
  }
  
  /// Leer contenido de archivo de texto
  Future<String> readTextFile(String path) async {
    try {
      final file = File(path);
      return await file.readAsString();
    } catch (e) {
      throw Exception('Error al leer archivo: $e');
    }
  }
  
  /// Escribir contenido a archivo de texto
  Future<bool> writeTextFile(String path, String content) async {
    try {
      final file = File(path);
      await file.writeAsString(content);
      return true;
    } catch (e) {
      throw Exception('Error al escribir archivo: $e');
    }
  }
  
  /// Buscar archivos por nombre
  Future<List<FileModel>> searchFiles(String query, {String? directory}) async {
    try {
      final searchDir = directory ?? (await getExternalStorageDirectory())?.path ?? '/storage/emulated/0';
      final dir = Directory(searchDir);
      
      if (!await dir.exists()) {
        return [];
      }
      
      final results = <FileModel>[];
      final queryLower = query.toLowerCase();
      
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        try {
          final name = path_utils.basename(entity.path).toLowerCase();
          if (name.contains(queryLower)) {
            final fileEntity = FileEntity.fromFileSystemEntity(entity);
            results.add(FileModel.fromEntity(fileEntity));
          }
          
          // Limitar resultados para evitar sobrecarga
          if (results.length >= 100) break;
        } catch (e) {
          // Continuar si hay error con un archivo específico
          continue;
        }
      }
      
      return results;
    } catch (e) {
      throw Exception('Error en búsqueda: $e');
    }
  }
  
  /// Verificar si un archivo existe
  Future<bool> fileExists(String path) async {
    final file = File(path);
    final directory = Directory(path);
    
    return await file.exists() || await directory.exists();
  }
  
  /// Obtener directorios raíz disponibles
  Future<List<String>> getRootDirectories() async {
    final directories = <String>[];
    
    try {
      // Directorio de documentos
      final documentsDir = await getApplicationDocumentsDirectory();
      directories.add(documentsDir.path);
      
      // Directorio externo si está disponible
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        directories.add(externalDir.path);
      }
      
      // Directorio de descargas (Android)
      if (Platform.isAndroid) {
        directories.add('/storage/emulated/0/Download');
        directories.add('/storage/emulated/0/Pictures');
        directories.add('/storage/emulated/0/Documents');
      }
      
    } catch (e) {
      debugPrint('Error obteniendo directorios raíz: $e');
    }
    
    return directories;
  }
  
  /// Copiar directorio recursivamente
  Future<void> _copyDirectory(Directory source, Directory destination) async {
    if (!await destination.exists()) {
      await destination.create(recursive: true);
    }
    
    await for (final entity in source.list()) {
      if (entity is File) {
        final newPath = path_utils.join(destination.path, path_utils.basename(entity.path));
        await entity.copy(newPath);
      } else if (entity is Directory) {
        final newPath = path_utils.join(destination.path, path_utils.basename(entity.path));
        await _copyDirectory(entity, Directory(newPath));
      }
    }
  }
}