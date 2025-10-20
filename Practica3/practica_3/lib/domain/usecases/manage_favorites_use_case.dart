import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

/// Caso de uso para gestionar archivos favoritos
class ManageFavoritesUseCase {
  final FavoriteRepository _favoriteRepository;

  ManageFavoritesUseCase(this._favoriteRepository);

  Future<List<FavoriteEntity>> getAllFavorites() async {
    try {
      return await _favoriteRepository.getAllFavorites();
    } catch (e) {
      throw Exception('Error al obtener favoritos: $e');
    }
  }

  Future<bool> addToFavorites(String filePath, String fileName, bool isDirectory) async {
    try {
      // Verificar si ya es favorito
      final isFav = await _favoriteRepository.isFavorite(filePath);
      if (isFav) {
        return false; // Ya es favorito
      }

      final favorite = FavoriteEntity(
        filePath: filePath,
        fileName: fileName,
        dateAdded: DateTime.now(),
        isDirectory: isDirectory,
      );

      return await _favoriteRepository.addFavorite(favorite);
    } catch (e) {
      throw Exception('Error al agregar a favoritos: $e');
    }
  }

  Future<bool> removeFromFavorites(String filePath) async {
    try {
      return await _favoriteRepository.removeFavorite(filePath);
    } catch (e) {
      throw Exception('Error al quitar de favoritos: $e');
    }
  }

  Future<bool> toggleFavorite(String filePath, String fileName, bool isDirectory) async {
    try {
      final isFav = await _favoriteRepository.isFavorite(filePath);
      
      if (isFav) {
        return await removeFromFavorites(filePath);
      } else {
        return await addToFavorites(filePath, fileName, isDirectory);
      }
    } catch (e) {
      throw Exception('Error al cambiar estado de favorito: $e');
    }
  }

  Future<bool> isFavorite(String filePath) async {
    try {
      return await _favoriteRepository.isFavorite(filePath);
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearAllFavorites() async {
    try {
      return await _favoriteRepository.clearFavorites();
    } catch (e) {
      throw Exception('Error al limpiar favoritos: $e');
    }
  }
}