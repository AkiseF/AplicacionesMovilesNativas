# 📱 Gestor de Archivos - Documentación Técnica

## 🏗️ Arquitectura del Proyecto

Este proyecto implementa **Clean Architecture** con una separación clara de responsabilidades en tres capas principales:

### **Estructura de Capas**

```
lib/
├── core/                          # 🔧 Núcleo de la aplicación
│   ├── constants/                 # Constantes globales
│   ├── theme/                     # Configuración de temas
│   └── utils/                     # Utilidades y helpers
├── presentation/                  # 🎨 Capa de Presentación
│   ├── pages/                     # Pantallas de la aplicación
│   ├── widgets/                   # Componentes reutilizables
│   └── providers/                 # Gestión de estado
├── domain/                        # 🧠 Capa de Dominio
│   ├── entities/                  # Entidades de negocio
│   ├── repositories/              # Interfaces de repositorios
│   └── usecases/                  # Casos de uso
└── data/                          # 💾 Capa de Datos
    ├── models/                    # Modelos de datos
    ├── repositories/              # Implementación de repositorios
    └── datasources/               # Fuentes de datos
```

## 🎯 Funcionalidades Principales

### **1. Exploración de Archivos** 📂

#### **FileManagerProvider** - Gestión de Estado Principal
```dart
/// Proveedor principal que maneja el estado de la exploración de archivos
/// Implementa el patrón Provider para reactividad en tiempo real
class FileManagerProvider extends ChangeNotifier {
  // Lista de archivos del directorio actual
  List<FileSystemEntity> _files = [];
  
  // Directorio actual siendo explorado
  Directory? _currentDirectory;
  
  // Estado de carga para mostrar indicadores visuales
  bool _isLoading = false;
  
  /// Método principal para cargar archivos de un directorio
  /// Maneja permisos, filtros y ordenamiento automáticamente
  Future<void> loadFiles(String path) async {
    try {
      _isLoading = true;
      notifyListeners(); // Notifica cambios a los widgets
      
      // Verificación de permisos antes de acceder al directorio
      if (!await _hasStoragePermission()) {
        await _requestStoragePermission();
      }
      
      final directory = Directory(path);
      if (await directory.exists()) {
        _currentDirectory = directory;
        
        // Carga archivos con manejo robusto de excepciones
        _files = await _loadDirectoryContents(directory);
        
        // Actualiza historial de navegación
        await _updateNavigationHistory(path);
      }
    } catch (e) {
      // Manejo centralizado de errores con logging
      _handleError('Error al cargar directorio', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

#### **LocalFileDataSource** - Acceso a Sistema de Archivos
```dart
/// Fuente de datos que maneja operaciones directas con el sistema de archivos
/// Implementa validaciones de seguridad y manejo de permisos
class LocalFileDataSource {
  
  /// Obtiene lista de archivos con filtrado automático
  /// Excluye archivos del sistema y directorios inaccesibles
  Future<List<FileSystemEntity>> getFilesInDirectory(String path) async {
    try {
      final directory = Directory(path);
      
      // Lista con filtros aplicados para evitar archivos problemáticos
      final entities = await directory
          .list(recursive: false, followLinks: false)
          .where((entity) => _isValidFile(entity))
          .toList();
      
      // Ordenamiento alfabético con directorios primero
      entities.sort((a, b) => _compareFileEntities(a, b));
      
      return entities;
    } catch (e) {
      // Los errores de permisos se registran pero no interrumpen la app
      debugPrint('Error accediendo a directorio $path: $e');
      return [];
    }
  }
  
  /// Valida si un archivo es seguro para mostrar en la interfaz
  bool _isValidFile(FileSystemEntity entity) {
    final name = path.basename(entity.path);
    
    // Excluye archivos ocultos del sistema (que empiecen con .)
    if (name.startsWith('.')) return false;
    
    // Excluye archivos temporales y de sistema
    if (name.contains('~') || name.contains('.tmp')) return false;
    
    return true;
  }
}
```

### **2. Visualización de Archivos** 👁️

#### **TextViewerPage** - Editor de Texto Completo
```dart
/// Pantalla para visualizar y editar archivos de texto
/// Soporta múltiples formatos: .txt, .md, .json, .dart, .java, etc.
class TextViewerPage extends StatefulWidget {
  final String filePath;
  final String fileName;
  
  const TextViewerPage({
    Key? key,
    required this.filePath,
    required this.fileName,
  }) : super(key: key);
}

class _TextViewerPageState extends State<TextViewerPage> {
  late TextEditingController _controller;
  bool _isEditing = false;
  bool _hasChanges = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
        actions: [
          // Botón para alternar entre modo lectura y edición
          IconButton(
            icon: Icon(_isEditing ? Icons.visibility : Icons.edit),
            onPressed: _toggleEditMode,
            tooltip: _isEditing ? 'Modo Lectura' : 'Editar Archivo',
          ),
          
          // Botón de guardado (solo visible en modo edición)
          if (_isEditing && _hasChanges)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveFile,
              tooltip: 'Guardar Cambios',
            ),
            
          // Menú de opciones adicionales
          _buildOptionsMenu(),
        ],
      ),
      body: _buildTextEditor(),
    );
  }
  
  /// Editor de texto con resaltado básico de sintaxis
  Widget _buildTextEditor() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        enabled: _isEditing,
        maxLines: null, // Permite múltiples líneas
        expands: true,  // Ocupa todo el espacio disponible
        decoration: InputDecoration(
          border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
          hintText: _isEditing ? 'Escriba su contenido aquí...' : null,
        ),
        style: TextStyle(
          fontFamily: 'monospace', // Fuente monoespaciada para código
          fontSize: 14,
          color: _getTextColorForFileType(),
        ),
        onChanged: (value) {
          if (!_hasChanges) {
            setState(() => _hasChanges = true);
          }
        },
      ),
    );
  }
  
  /// Determina el color del texto según el tipo de archivo
  Color _getTextColorForFileType() {
    final extension = path.extension(widget.filePath).toLowerCase();
    
    switch (extension) {
      case '.dart':
        return Colors.blue.shade700;
      case '.java':
      case '.kt':
        return Colors.orange.shade700;
      case '.json':
        return Colors.green.shade700;
      case '.xml':
        return Colors.purple.shade700;
      default:
        return Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    }
  }
}
```

#### **ImageViewerPage** - Visor de Imágenes Avanzado
```dart
/// Pantalla para visualizar imágenes con funciones de zoom y navegación
/// Utiliza PhotoView para controles avanzados de imagen
class ImageViewerPage extends StatefulWidget {
  final String imagePath;
  final List<String> imageFiles; // Lista para navegación entre imágenes
  final int initialIndex;
  
  const ImageViewerPage({
    Key? key,
    required this.imagePath,
    required this.imageFiles,
    this.initialIndex = 0,
  }) : super(key: key);
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  
  /// Construye el visor principal con PhotoView
  Widget _buildPhotoViewer() {
    return PhotoViewGallery.builder(
      pageController: _pageController,
      itemCount: widget.imageFiles.length,
      onPageChanged: (index) {
        setState(() => _currentIndex = index);
        _updateImageInfo(); // Actualiza información de la imagen actual
      },
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: FileImage(File(widget.imageFiles[index])),
          
          // Configuración de zoom y escalado
          minScale: PhotoViewComputedScale.contained * 0.5,
          maxScale: PhotoViewComputedScale.covered * 3.0,
          
          // Texto de error personalizado
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error al cargar la imagen'),
                ],
              ),
            );
          },
        );
      },
      
      // Configuración de comportamiento de scroll
      scrollPhysics: const BouncingScrollPhysics(),
      backgroundDecoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
  
  /// Obtiene y muestra metadatos de la imagen actual
  Future<void> _updateImageInfo() async {
    try {
      final file = File(widget.imageFiles[_currentIndex]);
      final stat = await file.stat();
      
      // Obtiene dimensiones de la imagen
      final image = await decodeImageFromList(await file.readAsBytes());
      
      setState(() {
        _imageInfo = ImageInfo(
          width: image.width,
          height: image.height,
          size: stat.size,
          modified: stat.modified,
        );
      });
    } catch (e) {
      debugPrint('Error obteniendo información de imagen: $e');
    }
  }
}
```

### **3. Base de Datos y Almacenamiento** 💾

#### **DatabaseHelper** - Gestión de SQLite
```dart
/// Helper para gestión de base de datos SQLite local
/// Implementa patrón Singleton para evitar múltiples instancias
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;
  
  // Constructor privado para implementar Singleton
  DatabaseHelper._internal();
  
  /// Getter que implementa el patrón Singleton
  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }
  
  /// Inicializa la base de datos con las tablas necesarias
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  
  /// Configuración inicial de la base de datos
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'file_manager.db');
    
    return await openDatabase(
      path,
      version: 2, // Versión para migración de esquemas
      onCreate: _createTables,
      onUpgrade: _upgradeDatabase,
    );
  }
  
  /// Crea todas las tablas necesarias para la aplicación
  Future<void> _createTables(Database db, int version) async {
    // Tabla para archivos favoritos
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_path TEXT UNIQUE NOT NULL,
        file_name TEXT NOT NULL,
        file_type TEXT NOT NULL,
        added_date INTEGER NOT NULL,
        file_size INTEGER DEFAULT 0
      )
    ''');
    
    // Tabla para historial de archivos recientes
    await db.execute('''
      CREATE TABLE recent_files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        file_path TEXT UNIQUE NOT NULL,
        file_name TEXT NOT NULL,
        file_type TEXT NOT NULL,
        last_accessed INTEGER NOT NULL,
        access_count INTEGER DEFAULT 1
      )
    ''');
    
    // Índices para mejorar rendimiento de consultas
    await db.execute('CREATE INDEX idx_favorites_path ON favorites(file_path)');
    await db.execute('CREATE INDEX idx_recent_accessed ON recent_files(last_accessed DESC)');
  }
}
```

#### **ThumbnailCache** - Sistema de Caché de Miniaturas
```dart
/// Sistema de caché para miniaturas de imágenes
/// Implementa caché en memoria y disco para optimizar rendimiento
class ThumbnailCache {
  static ThumbnailCache? _instance;
  
  // Caché en memoria con límite de elementos (LRU)
  final Map<String, Uint8List> _memoryCache = {};
  static const int _memoryCacheLimit = 50;
  
  // Directorio para caché persistente en disco
  late Directory _cacheDirectory;
  
  /// Constructor Singleton
  static ThumbnailCache get instance {
    _instance ??= ThumbnailCache._internal();
    return _instance!;
  }
  
  ThumbnailCache._internal();
  
  /// Inicializa el sistema de caché
  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDirectory = Directory('${appDir.path}/thumbnails');
    
    // Crea directorio si no existe
    if (!await _cacheDirectory.exists()) {
      await _cacheDirectory.create(recursive: true);
    }
    
    // Limpia archivos de caché antiguos (más de 7 días)
    await _cleanOldCacheFiles();
  }
  
  /// Obtiene miniatura con sistema de caché híbrido
  Future<Uint8List?> getThumbnail(String imagePath) async {
    final cacheKey = _generateCacheKey(imagePath);
    
    // 1. Busca en caché de memoria (más rápido)
    if (_memoryCache.containsKey(cacheKey)) {
      return _memoryCache[cacheKey];
    }
    
    // 2. Busca en caché de disco
    final cachedFile = File('${_cacheDirectory.path}/$cacheKey.jpg');
    if (await cachedFile.exists()) {
      final thumbnail = await cachedFile.readAsBytes();
      _addToMemoryCache(cacheKey, thumbnail);
      return thumbnail;
    }
    
    // 3. Genera nueva miniatura si no existe en caché
    return await _generateAndCacheThumbnail(imagePath, cacheKey);
  }
  
  /// Genera miniatura optimizada para la imagen
  Future<Uint8List?> _generateAndCacheThumbnail(String imagePath, String cacheKey) async {
    try {
      final originalFile = File(imagePath);
      if (!await originalFile.exists()) return null;
      
      // Decodifica imagen original
      final bytes = await originalFile.readAsBytes();
      final image = await decodeImageFromList(bytes);
      
      // Calcula dimensiones para miniatura (máximo 200x200)
      const maxSize = 200;
      final aspectRatio = image.width / image.height;
      
      int thumbnailWidth, thumbnailHeight;
      if (aspectRatio > 1) {
        thumbnailWidth = maxSize;
        thumbnailHeight = (maxSize / aspectRatio).round();
      } else {
        thumbnailHeight = maxSize;
        thumbnailWidth = (maxSize * aspectRatio).round();
      }
      
      // Redimensiona imagen usando algoritmo de interpolación
      final resizedImage = await _resizeImage(
        bytes, 
        thumbnailWidth, 
        thumbnailHeight
      );
      
      // Guarda en ambos cachés
      await _saveToDiskCache(cacheKey, resizedImage);
      _addToMemoryCache(cacheKey, resizedImage);
      
      return resizedImage;
    } catch (e) {
      debugPrint('Error generando miniatura para $imagePath: $e');
      return null;
    }
  }
  
  /// Genera clave única basada en ruta y fecha de modificación
  String _generateCacheKey(String imagePath) {
    final file = File(imagePath);
    final stat = file.statSync();
    final lastModified = stat.modified.millisecondsSinceEpoch;
    
    // Combina ruta y timestamp para detectar cambios en archivo
    final combined = '$imagePath-$lastModified';
    return crypto.md5.convert(utf8.encode(combined)).toString();
  }
}
```

### **4. Gestión de Archivos** 📁

#### **FileOperationsUseCase** - Operaciones CRUD
```dart
/// Caso de uso que encapsula todas las operaciones de gestión de archivos
/// Implementa validaciones de seguridad y manejo de errores robusto
class FileOperationsUseCase {
  final LocalFileDataSource _dataSource;
  
  FileOperationsUseCase(this._dataSource);
  
  /// Crea una nueva carpeta con validación de nombres
  Future<bool> createFolder(String parentPath, String folderName) async {
    try {
      // Validaciones de entrada
      if (folderName.trim().isEmpty) {
        throw FileOperationException('El nombre de la carpeta no puede estar vacío');
      }
      
      if (_containsInvalidCharacters(folderName)) {
        throw FileOperationException('Nombre contiene caracteres no válidos');
      }
      
      final newFolderPath = path.join(parentPath, folderName);
      final folder = Directory(newFolderPath);
      
      // Verifica si ya existe
      if (await folder.exists()) {
        throw FileOperationException('Ya existe una carpeta con ese nombre');
      }
      
      // Crea carpeta con permisos apropiados
      await folder.create(recursive: true);
      
      // Registra operación en logs para auditoría
      await _logOperation('CREATE_FOLDER', newFolderPath);
      
      return true;
    } catch (e) {
      debugPrint('Error creando carpeta: $e');
      return false;
    }
  }
  
  /// Copia archivo o directorio de forma recursiva
  Future<bool> copyFileOrDirectory(String sourcePath, String destinationPath) async {
    try {
      final source = FileSystemEntity.typeSync(sourcePath);
      
      if (source == FileSystemEntityType.file) {
        return await _copyFile(sourcePath, destinationPath);
      } else if (source == FileSystemEntityType.directory) {
        return await _copyDirectory(sourcePath, destinationPath);
      }
      
      return false;
    } catch (e) {
      debugPrint('Error en operación de copia: $e');
      return false;
    }
  }
  
  /// Copia directorio completo de manera recursiva
  Future<bool> _copyDirectory(String sourcePath, String destinationPath) async {
    final sourceDir = Directory(sourcePath);
    final destDir = Directory(destinationPath);
    
    // Crea directorio destino si no existe
    if (!await destDir.exists()) {
      await destDir.create(recursive: true);
    }
    
    // Copia todos los elementos del directorio
    await for (final entity in sourceDir.list(recursive: false)) {
      final fileName = path.basename(entity.path);
      final newDestPath = path.join(destinationPath, fileName);
      
      if (entity is File) {
        await entity.copy(newDestPath);
      } else if (entity is Directory) {
        // Llamada recursiva para subdirectorios
        await _copyDirectory(entity.path, newDestPath);
      }
    }
    
    return true;
  }
  
  /// Valida caracteres no permitidos en nombres de archivo
  bool _containsInvalidCharacters(String fileName) {
    // Caracteres no permitidos en sistemas de archivos
    const invalidChars = ['/', '\\', ':', '*', '?', '"', '<', '>', '|'];
    return invalidChars.any((char) => fileName.contains(char));
  }
}
```

### **5. Búsqueda Avanzada** 🔍

#### **SearchProvider** - Motor de Búsqueda
```dart
/// Proveedor que maneja la lógica de búsqueda avanzada de archivos
/// Implementa múltiples filtros y algoritmos de búsqueda eficientes
class SearchProvider extends ChangeNotifier {
  List<FileSystemEntity> _searchResults = [];
  bool _isSearching = false;
  String _currentQuery = '';
  
  // Filtros de búsqueda configurables
  Set<String> _fileTypeFilters = {};
  DateTime? _dateFrom;
  DateTime? _dateTo;
  int? _minSizeBytes;
  int? _maxSizeBytes;
  
  /// Ejecuta búsqueda con múltiples criterios
  Future<void> searchFiles({
    required String query,
    String? rootPath,
    Set<String>? fileTypes,
    DateTime? dateFrom,
    DateTime? dateTo,
    int? minSize,
    int? maxSize,
  }) async {
    _isSearching = true;
    _currentQuery = query;
    _fileTypeFilters = fileTypes ?? {};
    _dateFrom = dateFrom;
    _dateTo = dateTo;
    _minSizeBytes = minSize;
    _maxSizeBytes = maxSize;
    
    notifyListeners();
    
    try {
      _searchResults = await _performSearch(rootPath ?? '/storage/emulated/0');
    } catch (e) {
      debugPrint('Error en búsqueda: $e');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
  
  /// Algoritmo de búsqueda optimizado con filtros aplicados
  Future<List<FileSystemEntity>> _performSearch(String rootPath) async {
    final results = <FileSystemEntity>[];
    final searchQueue = Queue<Directory>();
    searchQueue.add(Directory(rootPath));
    
    // Búsqueda iterativa para evitar stack overflow en directorios profundos
    while (searchQueue.isNotEmpty && results.length < 1000) { // Límite de resultados
      final currentDir = searchQueue.removeFirst();
      
      try {
        await for (final entity in currentDir.list(recursive: false)) {
          // Aplica filtros antes de añadir a resultados
          if (await _matchesSearchCriteria(entity)) {
            results.add(entity);
          }
          
          // Añade subdirectorios a la cola de búsqueda
          if (entity is Directory && !_isSystemDirectory(entity.path)) {
            searchQueue.add(entity);
          }
        }
      } catch (e) {
        // Ignora directorios inaccesibles sin interrumpir búsqueda
        continue;
      }
    }
    
    // Ordena resultados por relevancia
    results.sort((a, b) => _calculateRelevanceScore(b, _currentQuery)
        .compareTo(_calculateRelevanceScore(a, _currentQuery)));
    
    return results;
  }
  
  /// Verifica si el archivo coincide con todos los criterios de búsqueda
  Future<bool> _matchesSearchCriteria(FileSystemEntity entity) async {
    final fileName = path.basename(entity.path).toLowerCase();
    final query = _currentQuery.toLowerCase();
    
    // 1. Filtro por nombre (búsqueda fuzzy)
    if (query.isNotEmpty && !_fuzzyMatch(fileName, query)) {
      return false;
    }
    
    // 2. Filtro por tipo de archivo
    if (_fileTypeFilters.isNotEmpty) {
      final extension = path.extension(entity.path).toLowerCase();
      if (!_fileTypeFilters.contains(extension)) {
        return false;
      }
    }
    
    // 3. Filtros por fecha y tamaño (solo para archivos)
    if (entity is File) {
      try {
        final stat = await entity.stat();
        
        // Filtro por fecha de modificación
        if (_dateFrom != null && stat.modified.isBefore(_dateFrom!)) {
          return false;
        }
        if (_dateTo != null && stat.modified.isAfter(_dateTo!.add(const Duration(days: 1)))) {
          return false;
        }
        
        // Filtro por tamaño de archivo
        if (_minSizeBytes != null && stat.size < _minSizeBytes!) {
          return false;
        }
        if (_maxSizeBytes != null && stat.size > _maxSizeBytes!) {
          return false;
        }
      } catch (e) {
        // Si no se puede obtener información del archivo, se excluye
        return false;
      }
    }
    
    return true;
  }
  
  /// Implementa algoritmo de búsqueda fuzzy para coincidencias aproximadas
  bool _fuzzyMatch(String text, String pattern) {
    if (pattern.isEmpty) return true;
    if (text.isEmpty) return false;
    
    // Búsqueda exacta tiene prioridad
    if (text.contains(pattern)) return true;
    
    // Búsqueda fuzzy: verifica si todos los caracteres del patrón 
    // aparecen en orden en el texto
    int patternIndex = 0;
    for (int i = 0; i < text.length && patternIndex < pattern.length; i++) {
      if (text[i] == pattern[patternIndex]) {
        patternIndex++;
      }
    }
    
    return patternIndex == pattern.length;
  }
  
  /// Calcula puntuación de relevancia para ordenar resultados
  int _calculateRelevanceScore(FileSystemEntity entity, String query) {
    final fileName = path.basename(entity.path).toLowerCase();
    final queryLower = query.toLowerCase();
    
    int score = 0;
    
    // Coincidencia exacta en el nombre: máxima puntuación
    if (fileName == queryLower) {
      score += 1000;
    }
    // Comienza con la consulta: alta puntuación
    else if (fileName.startsWith(queryLower)) {
      score += 500;
    }
    // Contiene la consulta: puntuación media
    else if (fileName.contains(queryLower)) {
      score += 200;
    }
    
    // Bonificación por tipo de archivo común
    final extension = path.extension(entity.path).toLowerCase();
    if (['.txt', '.pdf', '.jpg', '.png', '.doc', '.docx'].contains(extension)) {
      score += 50;
    }
    
    // Penalización por archivos ocultos o de sistema
    if (fileName.startsWith('.') || fileName.contains('cache')) {
      score -= 100;
    }
    
    return score;
  }
}
```

## 🎨 Personalización de Temas

### **ThemeProvider** - Gestión de Temas Institucionales
```dart
/// Proveedor que maneja los temas personalizados institucionales
/// Implementa temas IPN/ESCOM con adaptación automática claro/oscuro
class ThemeProvider extends ChangeNotifier {
  // Colores institucionales
  static const Color _ipnGuinda = Color(0xFF6B2E5F);
  static const Color _escomAzul = Color(0xFF003D6D);
  
  InstitutionalTheme _currentTheme = InstitutionalTheme.ipn;
  bool _isDarkMode = false;
  
  /// Obtiene el tema actual configurado
  ThemeData get currentThemeData {
    switch (_currentTheme) {
      case InstitutionalTheme.ipn:
        return _buildIPNTheme();
      case InstitutionalTheme.escom:
        return _buildESCOMTheme();
    }
  }
  
  /// Construye tema personalizado para IPN con color guinda
  ThemeData _buildIPNTheme() {
    final brightness = _isDarkMode ? Brightness.dark : Brightness.light;
    final baseTheme = ThemeData(brightness: brightness);
    
    return baseTheme.copyWith(
      primarySwatch: _createMaterialColor(_ipnGuinda),
      primaryColor: _ipnGuinda,
      
      // Configuración de AppBar con degradado institucional
      appBarTheme: AppBarTheme(
        backgroundColor: _ipnGuinda,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Botones flotantes con color institucional
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _ipnGuinda,
        foregroundColor: Colors.white,
      ),
      
      // Configuración de iconos y elementos interactivos
      iconTheme: IconThemeData(
        color: _isDarkMode ? Colors.white70 : _ipnGuinda,
      ),
      
      // Tema de cards y superficies
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: _isDarkMode ? Colors.grey[800] : Colors.white,
      ),
      
      // Configuración de texto institucional
      textTheme: baseTheme.textTheme.copyWith(
        titleLarge: TextStyle(
          color: _isDarkMode ? Colors.white : _ipnGuinda,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(
          color: _isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }
  
  /// Crea MaterialColor personalizado para uso en temas
  MaterialColor _createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;
    
    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    
    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    
    return MaterialColor(color.value, swatch);
  }
}

/// Enumeración para temas institucionales disponibles
enum InstitutionalTheme {
  ipn,    // Tema guinda del IPN
  escom,  // Tema azul de ESCOM
}
```

## 🔧 Utilidades y Helpers

### **IntentUtils** - Apertura con Aplicaciones Externas
```dart
/// Utilidad para abrir archivos con aplicaciones externas del sistema
/// Maneja detección automática de tipos MIME y manejo de errores
class IntentUtils {
  
  /// Abre archivo con la aplicación por defecto del sistema
  static Future<bool> openWithExternalApp(String filePath) async {
    try {
      final file = File(filePath);
      
      // Verifica que el archivo existe antes de intentar abrirlo
      if (!await file.exists()) {
        debugPrint('Archivo no encontrado: $filePath');
        return false;
      }
      
      // Detecta tipo MIME automáticamente
      final mimeType = _getMimeType(filePath);
      
      // Intenta abrir con OpenFilex (Android)
      final result = await OpenFilex.open(
        filePath,
        type: mimeType,
        uti: _getUTI(filePath), // Para iOS
      );
      
      // Maneja diferentes códigos de resultado
      switch (result.type) {
        case ResultType.done:
          debugPrint('Archivo abierto exitosamente: $filePath');
          return true;
          
        case ResultType.noAppToOpen:
          debugPrint('No hay aplicación para abrir: $filePath');
          await _showNoAppDialog(filePath);
          return false;
          
        case ResultType.permissionDenied:
          debugPrint('Permisos denegados para: $filePath');
          await _showPermissionDialog();
          return false;
          
        case ResultType.error:
        default:
          debugPrint('Error abriendo archivo: $filePath');
          return false;
      }
    } catch (e) {
      debugPrint('Excepción abriendo archivo: $e');
      return false;
    }
  }
  
  /// Detecta tipo MIME basado en extensión de archivo
  static String _getMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    
    // Mapeo de extensiones a tipos MIME comunes
    const mimeMap = {
      // Documentos
      '.pdf': 'application/pdf',
      '.doc': 'application/msword',
      '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      '.xls': 'application/vnd.ms-excel',
      '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      '.ppt': 'application/vnd.ms-powerpoint',
      '.pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      
      // Imágenes
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.png': 'image/png',
      '.gif': 'image/gif',
      '.bmp': 'image/bmp',
      '.webp': 'image/webp',
      '.svg': 'image/svg+xml',
      
      // Videos
      '.mp4': 'video/mp4',
      '.avi': 'video/avi',
      '.mov': 'video/quicktime',
      '.wmv': 'video/x-ms-wmv',
      '.flv': 'video/x-flv',
      '.webm': 'video/webm',
      
      // Audio
      '.mp3': 'audio/mpeg',
      '.wav': 'audio/wav',
      '.ogg': 'audio/ogg',
      '.aac': 'audio/aac',
      '.flac': 'audio/flac',
      
      // Archivos comprimidos
      '.zip': 'application/zip',
      '.rar': 'application/vnd.rar',
      '.7z': 'application/x-7z-compressed',
      '.tar': 'application/x-tar',
      '.gz': 'application/gzip',
      
      // Texto y código
      '.txt': 'text/plain',
      '.json': 'application/json',
      '.xml': 'application/xml',
      '.html': 'text/html',
      '.css': 'text/css',
      '.js': 'application/javascript',
      '.dart': 'text/plain',
      '.java': 'text/plain',
      '.kt': 'text/plain',
      '.py': 'text/plain',
    };
    
    return mimeMap[extension] ?? 'application/octet-stream';
  }
  
  /// Muestra diálogo cuando no hay aplicación disponible
  static Future<void> _showNoAppDialog(String filePath) async {
    // Implementación del diálogo informativo
    // Se omite por brevedad, pero incluiría opciones para:
    // - Sugerir aplicaciones de la Play Store
    // - Explicar cómo asociar aplicaciones
    // - Permitir compartir el archivo por otras vías
  }
}
```

## 📊 Métricas y Rendimiento

### **Optimizaciones Implementadas**

1. **Lazy Loading**: Los archivos se cargan bajo demanda
2. **Caché Inteligente**: Sistema híbrido memoria/disco para miniaturas
3. **Paginación**: Límites en resultados de búsqueda para evitar sobrecarga
4. **Async/Await**: Operaciones no bloqueantes en toda la aplicación
5. **Error Boundaries**: Manejo robusto que no interrumpe la experiencia
6. **Memory Management**: Límites en caché y limpieza automática

### **Patrones de Diseño Aplicados**

- **🏗️ Repository Pattern**: Abstracción de fuentes de datos
- **🎯 Use Case Pattern**: Lógica de negocio encapsulada
- **🔄 Provider Pattern**: Gestión reactiva de estado
- **🏭 Factory Pattern**: Creación flexible de objetos
- **🔒 Singleton Pattern**: Instancias únicas para recursos compartidos
- **👀 Observer Pattern**: Notificaciones automáticas de cambios
- **⚡ Strategy Pattern**: Algoritmos intercambiables de ordenamiento

---

**© 2025 - Documentación Técnica - Gestor de Archivos Flutter/Kotlin**