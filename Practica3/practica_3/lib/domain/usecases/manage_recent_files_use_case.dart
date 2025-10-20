import '../entities/recent_file_entity.dart';
import '../repositories/recent_file_repository.dart';

/// Caso de uso para gestionar archivos recientes
class ManageRecentFilesUseCase {
  final RecentFileRepository _recentFileRepository;

  ManageRecentFilesUseCase(this._recentFileRepository);

  Future<List<RecentFileEntity>> getRecentFiles({int? limit}) async {
    try {
      return await _recentFileRepository.getRecentFiles(limit: limit);
    } catch (e) {
      throw Exception('Error al obtener archivos recientes: $e');
    }
  }

  Future<bool> addRecentFile(String filePath, String fileName, String fileType, bool isDirectory) async {
    try {
      final recentFile = RecentFileEntity(
        filePath: filePath,
        fileName: fileName,
        lastAccessed: DateTime.now(),
        isDirectory: isDirectory,
        fileType: fileType,
      );

      return await _recentFileRepository.addRecentFile(recentFile);
    } catch (e) {
      throw Exception('Error al agregar archivo reciente: $e');
    }
  }

  Future<bool> updateFileAccess(String filePath) async {
    try {
      return await _recentFileRepository.updateLastAccessed(filePath);
    } catch (e) {
      throw Exception('Error al actualizar acceso: $e');
    }
  }

  Future<bool> removeRecentFile(String filePath) async {
    try {
      return await _recentFileRepository.removeRecentFile(filePath);
    } catch (e) {
      throw Exception('Error al quitar archivo reciente: $e');
    }
  }

  Future<bool> clearRecentFiles() async {
    try {
      return await _recentFileRepository.clearRecentFiles();
    } catch (e) {
      throw Exception('Error al limpiar archivos recientes: $e');
    }
  }
}