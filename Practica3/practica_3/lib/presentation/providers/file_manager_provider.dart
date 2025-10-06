import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/file_entity.dart';
import '../../domain/repositories/file_repository.dart';
import '../../domain/usecases/list_directory_use_case.dart';
import '../../domain/usecases/create_directory_use_case.dart';
import '../../domain/usecases/search_files_use_case.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/permission_utils.dart';

/// Provider principal para gestionar el estado del explorador de archivos
class FileManagerProvider extends ChangeNotifier {
  final ListDirectoryUseCase _listDirectoryUseCase;
  final CreateDirectoryUseCase _createDirectoryUseCase;
  final SearchFilesUseCase _searchFilesUseCase;
  final FileRepository _fileRepository;

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

  FileManagerProvider(
    this._listDirectoryUseCase,
    this._createDirectoryUseCase,
    this._searchFilesUseCase,
    this._fileRepository,
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
}