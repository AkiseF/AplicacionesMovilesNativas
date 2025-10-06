/// Constantes globales de la aplicación
class AppConstants {
  // Información de la app
  static const String appName = 'Gestor de Archivos';
  static const String appVersion = '1.0.0';
  
  // Colores institucionales
  static const int ipnGuindaColor = 0xFF6B2E5F;
  static const int escomAzulColor = 0xFF003D6D;
  
  // Extensiones de archivo soportadas
  static const List<String> supportedTextExtensions = [
    '.txt', '.md', '.log', '.json', '.xml', '.dart', '.java', '.js', '.html', '.css'
  ];
  
  static const List<String> supportedImageExtensions = [
    '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'
  ];
  
  static const List<String> supportedVideoExtensions = [
    '.mp4', '.avi', '.mov', '.mkv', '.webm'
  ];
  
  static const List<String> supportedAudioExtensions = [
    '.mp3', '.wav', '.flac', '.aac', '.ogg'
  ];
  
  // Configuración de base de datos
  static const String databaseName = 'file_manager.db';
  static const int databaseVersion = 1;
  
  // Claves para SharedPreferences
  static const String themePreferenceKey = 'theme_preference';
  static const String lastDirectoryKey = 'last_directory';
  static const String viewModeKey = 'view_mode';
  
  // Configuración de caché
  static const int maxCacheSize = 50 * 1024 * 1024; // 50 MB
  static const int thumbnailSize = 120;
  
  // Configuración de búsqueda
  static const int maxRecentSearches = 10;
  static const int searchDebounceTime = 300; // milliseconds
}

/// Enums para la aplicación
enum AppTheme { guinda, azul }
enum ViewMode { list, grid }
enum SortBy { name, size, date, type }
enum SortOrder { ascending, descending }
enum FileType { text, image, video, audio, document, folder, other }