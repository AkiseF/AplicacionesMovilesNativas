import '../../domain/entities/file_entity.dart';
import '../../domain/repositories/file_repository.dart';
import '../../core/constants/app_constants.dart';
import '../datasources/local_file_datasource.dart';

/// Implementación concreta del FileRepository
class FileRepositoryImpl implements FileRepository {
  final LocalFileDataSource _localDataSource;

  FileRepositoryImpl(this._localDataSource);

  @override
  Future<List<FileEntity>> listDirectory(String path) async {
    final fileModels = await _localDataSource.listDirectory(path);
    return fileModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<FileEntity?> getFileInfo(String path) async {
    final fileModel = await _localDataSource.getFileInfo(path);
    return fileModel?.toEntity();
  }

  @override
  Future<bool> createDirectory(String path, String name) async {
    return await _localDataSource.createDirectory(path, name);
  }

  @override
  Future<bool> renameFile(String oldPath, String newName) async {
    return await _localDataSource.renameFile(oldPath, newName);
  }

  @override
  Future<bool> copyFile(String sourcePath, String destinationPath) async {
    return await _localDataSource.copyFile(sourcePath, destinationPath);
  }

  @override
  Future<bool> moveFile(String sourcePath, String destinationPath) async {
    return await _localDataSource.moveFile(sourcePath, destinationPath);
  }

  @override
  Future<bool> deleteFile(String path) async {
    return await _localDataSource.deleteFile(path);
  }

  @override
  Future<List<FileEntity>> searchFiles(String query, {String? directory}) async {
    final fileModels = await _localDataSource.searchFiles(query, directory: directory);
    return fileModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<String?> readTextFile(String path) async {
    try {
      return await _localDataSource.readTextFile(path);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> writeTextFile(String path, String content) async {
    return await _localDataSource.writeTextFile(path, content);
  }

  @override
  Future<bool> fileExists(String path) async {
    return await _localDataSource.fileExists(path);
  }

  @override
  Future<List<String>> getRootDirectories() async {
    return await _localDataSource.getRootDirectories();
  }

  @override
  List<FileEntity> sortFiles(List<FileEntity> files, SortBy sortBy, SortOrder order) {
    final sortedFiles = List<FileEntity>.from(files);
    
    // Separar directorios y archivos
    final directories = sortedFiles.where((file) => file.isDirectory).toList();
    final regularFiles = sortedFiles.where((file) => !file.isDirectory).toList();
    
    // Función de comparación
    int compare(FileEntity a, FileEntity b) {
      int result;
      
      switch (sortBy) {
        case SortBy.name:
          result = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortBy.size:
          result = a.size.compareTo(b.size);
          break;
        case SortBy.date:
          result = a.lastModified.compareTo(b.lastModified);
          break;
        case SortBy.type:
          result = a.type.toString().compareTo(b.type.toString());
          break;
      }
      
      return order == SortOrder.ascending ? result : -result;
    }
    
    // Ordenar cada grupo
    directories.sort(compare);
    regularFiles.sort(compare);
    
    // Directorios siempre primero
    return [...directories, ...regularFiles];
  }

  @override
  List<FileEntity> filterByType(List<FileEntity> files, FileType? type) {
    if (type == null) return files;
    return files.where((file) => file.type == type).toList();
  }
}