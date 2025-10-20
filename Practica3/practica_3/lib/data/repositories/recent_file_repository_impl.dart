import '../../domain/entities/recent_file_entity.dart';
import '../../domain/repositories/recent_file_repository.dart';
import '../datasources/database_helper.dart';

/// Implementación concreta del RecentFileRepository
class RecentFileRepositoryImpl implements RecentFileRepository {
  final DatabaseHelper _databaseHelper;

  RecentFileRepositoryImpl(this._databaseHelper);

  @override
  Future<List<RecentFileEntity>> getRecentFiles({int? limit}) async {
    return await _databaseHelper.getRecentFiles(limit: limit);
  }

  @override
  Future<bool> addRecentFile(RecentFileEntity recentFile) async {
    try {
      await _databaseHelper.addRecentFile(recentFile);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeRecentFile(String filePath) async {
    try {
      await _databaseHelper.removeRecentFile(filePath);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> clearRecentFiles() async {
    try {
      await _databaseHelper.clearRecentFiles();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateLastAccessed(String filePath) async {
    try {
      await _databaseHelper.updateLastAccessed(filePath);
      return true;
    } catch (e) {
      return false;
    }
  }
}