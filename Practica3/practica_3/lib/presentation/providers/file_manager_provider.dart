import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/file_entity.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/entities/recent_file_entity.dart';
import '../../domain/repositories/file_repository.dart';
import '../../domain/usecases/list_directory_use_case.dart';
import '../../domain/usecases/create_directory_use_case.dart';
import '../../domain/usecases/search_files_use_case.dart';
import '../../domain/usecases/manage_favorites_use_case.dart';
import '../../domain/usecases/manage_recent_files_use_case.dart';
import '../../domain/usecases/file_operations_use_case.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/permission_utils.dart';

/// Provider principal para gestionar el estado del explorador de archivos
class FileManagerProvider extends ChangeNotifier {
  final ListDirectoryUseCase _listDirectoryUseCase;
  final CreateDirectoryUseCase _createDirectoryUseCase;
  final SearchFilesUseCase _searchFilesUseCase;
  final FileRepository _fileRepository;
  final ManageFavoritesUseCase _manageFavoritesUseCase;
  final ManageRecentFilesUseCase _manageRecentFilesUseCase;
  final FileOperationsUseCase _fileOperationsUseCase;

  // Estado
  List<FileEntity> _files = [];
  String _currentPath = '';
  bool _isLoading = false;
  String? _error;
  ViewMode _viewMode = ViewMode.list;
  SortBy _sortBy = SortBy.name;
  SortOrder _sortOrder = SortOrder.ascending;
  List<String> _breadcrumbs = [];
  bool _showHiddenFiles = false;
  
  // Búsqueda
  String _searchQuery = '';
  bool _isSearching = false;
  List<FileEntity> _searchResults = [];

  // Favoritos y recientes
  List<FavoriteEntity> _favorites = [];
  List<RecentFileEntity> _recentFiles = [];

  // Getters
  List<FileEntity> get files => _files;
  String get currentPath => _currentPath;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ViewMode get viewMode => _viewMode;
  SortBy get sortBy => _sortBy;
  SortOrder get sortOrder => _sortOrder;
  List<String> get breadcrumbs => _breadcrumbs;
  bool get showHiddenFiles => _showHiddenFiles;
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;
  List<FileEntity> get searchResults => _searchResults;
  List<FavoriteEntity> get favorites => _favorites;
  List<RecentFileEntity> get recentFiles => _recentFiles;

  FileManagerProvider(
    this._listDirectoryUseCase,
    this._createDirectoryUseCase,
    this._searchFilesUseCase,
    this._fileRepository,
    this._manageFavoritesUseCase,
    this._manageRecentFilesUseCase,
    this._fileOperationsUseCase,
  ) {
    _initializeFileManager();
  }

  /// Inicializar el gestor de archivos
  Future<void> _initializeFileManager() async {
    try {
      // Verificar permisos
      final hasPermission = await PermissionUtils.checkAllPermissions();
      if (!hasPermission) {
        final granted = await PermissionUtils.requestAllPermissions();
        if (!granted) {
          _error = 'Se requieren permisos de almacenamiento';
          notifyListeners();
          return;
        }
      }

      // Obtener directorio inicial
      final documentsDir = await getApplicationDocumentsDirectory();
      await navigateToPath(documentsDir.path);
    } catch (e) {
      _error = 'Error inicializando gestor de archivos: $e';
      notifyListeners();
    }
  }

  /// Navegar a una ruta específica
  Future<void> navigateToPath(String path) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fileList = await _listDirectoryUseCase.call(path);
      
      _files = _fileRepository.sortFiles(fileList, _sortBy, _sortOrder);
      _currentPath = path;
      _updateBreadcrumbs(path);
      
      if (!_showHiddenFiles) {
        _files = _files.where((file) => !file.isHidden).toList();
      }
      
    } catch (e) {
      _error = 'Error al acceder al directorio: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Navegar hacia atrás
  Future<void> navigateBack() async {
    if (_currentPath.isEmpty) return;
    
    final parentPath = _currentPath.substring(0, _currentPath.lastIndexOf('/'));
    if (parentPath.isNotEmpty) {
      await navigateToPath(parentPath);
    }
  }

  /// Refrescar directorio actual
  Future<void> refresh() async {
    if (_currentPath.isNotEmpty) {
      await navigateToPath(_currentPath);
    }
  }

  /// Crear nuevo directorio
  Future<bool> createDirectory(String name) async {
    try {
      final success = await _createDirectoryUseCase.call(_currentPath, name);
      if (success) {
        await refresh();
      }
      return success;
    } catch (e) {
      _error = 'Error al crear directorio: $e';
      notifyListeners();
      return false;
    }
  }

  /// Eliminar archivo o directorio
  Future<bool> deleteFile(String path) async {
    try {
      final success = await _fileRepository.deleteFile(path);
      if (success) {
        await refresh();
      }
      return success;
    } catch (e) {
      _error = 'Error al eliminar: $e';
      notifyListeners();
      return false;
    }
  }

  /// Renombrar archivo o directorio
  Future<bool> renameFile(String path, String newName) async {
    try {
      final success = await _fileRepository.renameFile(path, newName);
      if (success) {
        await refresh();
      }
      return success;
    } catch (e) {
      _error = 'Error al renombrar: $e';
      notifyListeners();
      return false;
    }
  }

  /// Buscar archivos
  Future<void> searchFiles(String query) async {
    _searchQuery = query;
    
    if (query.trim().isEmpty) {
      _isSearching = false;
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      _searchResults = await _searchFilesUseCase.call(query, directory: _currentPath);
    } catch (e) {
      _error = 'Error en búsqueda: $e';
      _searchResults = [];
    }

    notifyListeners();
  }

  /// Limpiar búsqueda
  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    _searchResults = [];
    notifyListeners();
  }

  /// Cambiar modo de vista
  void setViewMode(ViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  /// Cambiar ordenamiento
  void setSorting(SortBy sortBy, SortOrder order) {
    _sortBy = sortBy;
    _sortOrder = order;
    _files = _fileRepository.sortFiles(_files, _sortBy, _sortOrder);
    notifyListeners();
  }

  /// Alternar mostrar archivos ocultos
  void toggleHiddenFiles() {
    _showHiddenFiles = !_showHiddenFiles;
    if (_currentPath.isNotEmpty) {
      navigateToPath(_currentPath);
    }
  }

  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Actualizar breadcrumbs
  void _updateBreadcrumbs(String path) {
    _breadcrumbs = path.split('/').where((part) => part.isNotEmpty).toList();
    if (_breadcrumbs.isEmpty) {
      _breadcrumbs = ['Inicio'];
    }
  }

  /// Obtener archivos filtrados según el estado actual
  List<FileEntity> getFilteredFiles() {
    if (_isSearching) {
      return _searchResults;
    }
    return _files;
  }

  // Métodos para favoritos
  Future<void> loadFavorites() async {
    try {
      _favorites = await _manageFavoritesUseCase.getAllFavorites();
      notifyListeners();
    } catch (e) {
      _error = 'Error cargando favoritos: $e';
      notifyListeners();
    }
  }

  Future<void> addToFavorites(String filePath, String fileName, bool isDirectory) async {
    try {
      await _manageFavoritesUseCase.addToFavorites(filePath, fileName, isDirectory);
      await loadFavorites();
    } catch (e) {
      _error = 'Error agregando a favoritos: $e';
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(String filePath) async {
    try {
      await _manageFavoritesUseCase.removeFromFavorites(filePath);
      await loadFavorites();
    } catch (e) {
      _error = 'Error quitando de favoritos: $e';
      notifyListeners();
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      await _manageFavoritesUseCase.clearAllFavorites();
      await loadFavorites();
    } catch (e) {
      _error = 'Error limpiando favoritos: $e';
      notifyListeners();
    }
  }

  bool isFavorite(String filePath) {
    return _favorites.any((fav) => fav.filePath == filePath);
  }

  // Métodos para archivos recientes
  Future<void> loadRecentFiles() async {
    try {
      _recentFiles = await _manageRecentFilesUseCase.getRecentFiles();
      notifyListeners();
    } catch (e) {
      _error = 'Error cargando archivos recientes: $e';
      notifyListeners();
    }
  }

  Future<void> addToRecentFiles(String filePath, String fileName, String fileType, bool isDirectory) async {
    try {
      await _manageRecentFilesUseCase.addRecentFile(filePath, fileName, fileType, isDirectory);
      await loadRecentFiles();
    } catch (e) {
      _error = 'Error agregando archivo reciente: $e';
      notifyListeners();
    }
  }

  Future<void> removeFromRecentFiles(String filePath) async {
    try {
      await _manageRecentFilesUseCase.removeRecentFile(filePath);
      await loadRecentFiles();
    } catch (e) {
      _error = 'Error quitando archivo reciente: $e';
      notifyListeners();
    }
  }

  Future<void> clearAllRecentFiles() async {
    try {
      await _manageRecentFilesUseCase.clearRecentFiles();
      await loadRecentFiles();
    } catch (e) {
      _error = 'Error limpiando archivos recientes: $e';
      notifyListeners();
    }
  }

  // Métodos para operaciones de archivo
  Future<bool> copyFile(String sourcePath, String destinationPath) async {
    try {
      final success = await _fileOperationsUseCase.copyFile(sourcePath, destinationPath);
      if (success) {
        await refresh();
      }
      return success;
    } catch (e) {
      _error = 'Error copiando archivo: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> moveFile(String sourcePath, String destinationPath) async {
    try {
      final success = await _fileOperationsUseCase.moveFile(sourcePath, destinationPath);
      if (success) {
        await refresh();
      }
      return success;
    } catch (e) {
      _error = 'Error moviendo archivo: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> shareFile(String filePath) async {
    try {
      await _fileOperationsUseCase.shareFile(filePath);
    } catch (e) {
      _error = 'Error compartiendo archivo: $e';
      notifyListeners();
    }
  }

  Future<String> getFileInfo(String filePath) async {
    try {
      return await _fileOperationsUseCase.getFileInfo(filePath);
    } catch (e) {
      _error = 'Error obteniendo información del archivo: $e';
      notifyListeners();
      return '';
    }
  }

  /// Abre archivo con aplicación externa
  Future<bool> openFileWithExternalApp(String filePath) async {
    try {
      return await _fileOperationsUseCase.openFile(filePath);
    } catch (e) {
      _error = 'Error abriendo archivo: $e';
      notifyListeners();
      return false;
    }
  }

  /// Verifica si un archivo puede abrirse en la app
  bool canOpenInApp(String filePath) {
    return _fileOperationsUseCase.canOpenInApp(filePath);
  }
}