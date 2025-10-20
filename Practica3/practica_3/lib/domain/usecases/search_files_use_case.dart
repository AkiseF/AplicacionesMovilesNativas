import '../entities/file_entity.dart';
import '../repositories/file_repository.dart';
import '../../core/constants/app_constants.dart';

/// Caso de uso para buscar archivos
class SearchFilesUseCase {
  final FileRepository _fileRepository;

  SearchFilesUseCase(this._fileRepository);

  /// Búsqueda básica por nombre
  Future<List<FileEntity>> call(String query, {String? directory}) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }
      
      return await _fileRepository.searchFiles(
        directory ?? '/storage/emulated/0',
        query,
      );
    } catch (e) {
      throw Exception('Error al buscar archivos: $e');
    }
  }

  /// Búsqueda avanzada con filtros
  Future<List<FileEntity>> searchAdvanced(
    String directoryPath,
    String query, {
    FileType? fileType,
    DateTime? startDate,
    DateTime? endDate,
    int maxResults = 100,
  }) async {
    try {
      final results = await _fileRepository.searchFiles(
        directoryPath,
        query,
        fileType: fileType,
        startDate: startDate,
        endDate: endDate,
      );
      
      // Limitar resultados
      return results.take(maxResults).toList();
    } catch (e) {
      throw Exception('Error en búsqueda avanzada: $e');
    }
  }

  /// Buscar archivos por extensión
  Future<List<FileEntity>> searchByExtension(
    String directoryPath,
    String extension,
  ) async {
    try {
      final allFiles = await _fileRepository.searchFiles(directoryPath, '');
      return allFiles.where((file) => 
        !file.isDirectory && 
        file.extension?.toLowerCase() == extension.toLowerCase()
      ).toList();
    } catch (e) {
      throw Exception('Error buscando por extensión: $e');
    }
  }

  /// Buscar archivos modificados recientemente
  Future<List<FileEntity>> searchRecentlyModified(
    String directoryPath, {
    Duration within = const Duration(days: 7),
  }) async {
    try {
      final cutoffDate = DateTime.now().subtract(within);
      
      return await _fileRepository.searchFiles(
        directoryPath,
        '',
        startDate: cutoffDate,
      );
    } catch (e) {
      throw Exception('Error buscando archivos recientes: $e');
    }
  }

  /// Buscar archivos de gran tamaño
  Future<List<FileEntity>> searchLargeFiles(
    String directoryPath, {
    int minSizeBytes = 10 * 1024 * 1024, // 10 MB por defecto
  }) async {
    try {
      final allFiles = await _fileRepository.searchFiles(directoryPath, '');
      return allFiles.where((file) => 
        !file.isDirectory && file.size >= minSizeBytes
      ).toList();
    } catch (e) {
      throw Exception('Error buscando archivos grandes: $e');
    }
  }
}