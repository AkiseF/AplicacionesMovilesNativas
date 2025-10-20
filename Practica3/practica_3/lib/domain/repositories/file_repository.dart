import '../entities/file_entity.dart';
import '../../core/constants/app_constants.dart';

/// Repository abstracto para operaciones con archivos
abstract class FileRepository {
  
  /// Listar archivos y directorios de una ruta
  Future<List<FileEntity>> listDirectory(String path);
  
  /// Obtener información de un archivo específico
  Future<FileEntity?> getFileInfo(String path);
  
  /// Crear un nuevo directorio
  Future<bool> createDirectory(String path, String name);
  
  /// Renombrar archivo o directorio
  Future<bool> renameFile(String oldPath, String newName);
  
  /// Copiar archivo o directorio
  Future<bool> copyFile(String sourcePath, String destinationPath);
  
  /// Mover archivo o directorio
  Future<bool> moveFile(String sourcePath, String destinationPath);
  
  /// Eliminar archivo o directorio
  Future<bool> deleteFile(String path);
  
  /// Buscar archivos por nombre, tipo o fecha
  Future<List<FileEntity>> searchFiles(
    String directoryPath,
    String query, {
    FileType? fileType,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Obtener el contenido de un archivo de texto
  Future<String?> readTextFile(String path);
  
  /// Escribir contenido a un archivo de texto
  Future<bool> writeTextFile(String path, String content);
  
  /// Verificar si un archivo existe
  Future<bool> fileExists(String path);
  
  /// Obtener directorios raíz disponibles
  Future<List<String>> getRootDirectories();
  
  /// Ordenar lista de archivos
  List<FileEntity> sortFiles(List<FileEntity> files, SortBy sortBy, SortOrder order);
  
  /// Filtrar archivos por tipo
  List<FileEntity> filterByType(List<FileEntity> files, FileType? type);
}