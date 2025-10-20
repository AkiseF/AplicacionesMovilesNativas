import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ThumbnailCache {
  static ThumbnailCache? _instance;
  static ThumbnailCache get instance => _instance ??= ThumbnailCache._();
  
  ThumbnailCache._();
  
  Directory? _cacheDir;
  final Map<String, Uint8List> _memoryCache = {};
  final int maxMemoryCacheSize = 50; // Máximo de thumbnails en memoria
  
  /// Inicializa el directorio de caché
  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory(path.join(appDir.path, 'thumbnails'));
    
    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }
  }
  
  /// Genera un hash único para el archivo basado en ruta y fecha de modificación
  String _generateCacheKey(String filePath, DateTime lastModified) {
    final key = '$filePath-${lastModified.millisecondsSinceEpoch}';
    final bytes = utf8.encode(key);
    final digest = md5.convert(bytes);
    return digest.toString();
  }
  
  /// Obtiene thumbnail desde caché o lo genera
  Future<Uint8List?> getThumbnail(String filePath) async {
    try {
      if (_cacheDir == null) await initialize();
      
      final file = File(filePath);
      if (!await file.exists()) return null;
      
      final stat = await file.stat();
      final cacheKey = _generateCacheKey(filePath, stat.modified);
      
      // Buscar en caché de memoria primero
      if (_memoryCache.containsKey(cacheKey)) {
        return _memoryCache[cacheKey];
      }
      
      // Buscar en caché de disco
      final cacheFile = File(path.join(_cacheDir!.path, '$cacheKey.jpg'));
      if (await cacheFile.exists()) {
        final thumbnail = await cacheFile.readAsBytes();
        _addToMemoryCache(cacheKey, thumbnail);
        return thumbnail;
      }
      
      // Generar nuevo thumbnail
      final thumbnail = await _generateThumbnail(filePath);
      if (thumbnail != null) {
        // Guardar en disco
        await cacheFile.writeAsBytes(thumbnail);
        // Guardar en memoria
        _addToMemoryCache(cacheKey, thumbnail);
      }
      
      return thumbnail;
    } catch (e) {
      print('Error obteniendo thumbnail: $e');
      return null;
    }
  }
  
  /// Genera thumbnail para imagen
  Future<Uint8List?> _generateThumbnail(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      
      // Verificar si es imagen
      final extension = path.extension(filePath).toLowerCase();
      if (!['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(extension)) {
        return null;
      }
      
      // Decodificar imagen
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: 200,
        targetHeight: 200,
      );
      final frame = await codec.getNextFrame();
      
      // Convertir a bytes
      final byteData = await frame.image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error generando thumbnail: $e');
      return null;
    }
  }
  
  /// Añade thumbnail al caché de memoria
  void _addToMemoryCache(String key, Uint8List thumbnail) {
    if (_memoryCache.length >= maxMemoryCacheSize) {
      // Remover el más antiguo (simple FIFO)
      final firstKey = _memoryCache.keys.first;
      _memoryCache.remove(firstKey);
    }
    _memoryCache[key] = thumbnail;
  }
  
  /// Limpia caché antiguo (llamar periódicamente)
  Future<void> cleanOldCache({Duration maxAge = const Duration(days: 7)}) async {
    try {
      if (_cacheDir == null) return;
      
      final now = DateTime.now();
      final entities = await _cacheDir!.list().toList();
      
      for (final entity in entities) {
        if (entity is File) {
          final stat = await entity.stat();
          if (now.difference(stat.modified) > maxAge) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      print('Error limpiando caché: $e');
    }
  }
  
  /// Limpia todo el caché
  Future<void> clearCache() async {
    try {
      _memoryCache.clear();
      
      if (_cacheDir != null && await _cacheDir!.exists()) {
        await _cacheDir!.delete(recursive: true);
        await _cacheDir!.create();
      }
    } catch (e) {
      print('Error limpiando caché completo: $e');
    }
  }
  
  /// Obtiene el tamaño del caché en bytes
  Future<int> getCacheSize() async {
    try {
      if (_cacheDir == null || !await _cacheDir!.exists()) return 0;
      
      int totalSize = 0;
      await for (final entity in _cacheDir!.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }
      
      return totalSize;
    } catch (e) {
      return 0;
    }
  }
}