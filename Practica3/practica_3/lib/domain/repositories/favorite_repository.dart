import '../entities/favorite_entity.dart';

/// Repository abstracto para gestionar archivos favoritos
abstract class FavoriteRepository {
  
  /// Obtener todos los favoritos
  Future<List<FavoriteEntity>> getAllFavorites();
  
  /// Agregar archivo a favoritos
  Future<bool> addFavorite(FavoriteEntity favorite);
  
  /// Remover archivo de favoritos
  Future<bool> removeFavorite(String filePath);
  
  /// Verificar si un archivo está en favoritos
  Future<bool> isFavorite(String filePath);
  
  /// Limpiar todos los favoritos
  Future<bool> clearFavorites();
  
  /// Obtener favorito por ruta
  Future<FavoriteEntity?> getFavoriteByPath(String filePath);
}