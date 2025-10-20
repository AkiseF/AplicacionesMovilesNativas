import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/database_helper.dart';

/// Implementación concreta del FavoriteRepository
class FavoriteRepositoryImpl implements FavoriteRepository {
  final DatabaseHelper _databaseHelper;

  FavoriteRepositoryImpl(this._databaseHelper);

  @override
  Future<List<FavoriteEntity>> getAllFavorites() async {
    return await _databaseHelper.getFavorites();
  }

  @override
  Future<bool> addFavorite(FavoriteEntity favorite) async {
    try {
      await _databaseHelper.addFavorite(favorite);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeFavorite(String filePath) async {
    try {
      await _databaseHelper.removeFavorite(filePath);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isFavorite(String filePath) async {
    return await _databaseHelper.isFavorite(filePath);
  }

  @override
  Future<bool> clearFavorites() async {
    try {
      await _databaseHelper.clearFavorites();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<FavoriteEntity?> getFavoriteByPath(String filePath) async {
    final favorites = await _databaseHelper.getFavorites();
    try {
      return favorites.firstWhere((fav) => fav.filePath == filePath);
    } catch (e) {
      return null;
    }
  }
}