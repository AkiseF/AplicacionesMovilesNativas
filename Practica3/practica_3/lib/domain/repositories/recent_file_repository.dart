import '../entities/recent_file_entity.dart';

/// Repository abstracto para gestionar archivos recientes
abstract class RecentFileRepository {
  
  /// Obtener archivos recientes
  Future<List<RecentFileEntity>> getRecentFiles({int? limit});
  
  /// Agregar archivo al historial
  Future<bool> addRecentFile(RecentFileEntity recentFile);
  
  /// Remover archivo del historial
  Future<bool> removeRecentFile(String filePath);
  
  /// Limpiar historial
  Future<bool> clearRecentFiles();
  
  /// Actualizar último acceso de un archivo
  Future<bool> updateLastAccessed(String filePath);
}