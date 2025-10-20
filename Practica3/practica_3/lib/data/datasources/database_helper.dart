import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/entities/recent_file_entity.dart';

/// Helper para gestionar la base de datos local
class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'file_manager.db';
  static const int _databaseVersion = 1;
  
  // Tablas
  static const String _favoritesTable = 'favorites';
  static const String _recentFilesTable = 'recent_files';
  
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createTables,
    );
  }
  
  Future<void> _createTables(Database db, int version) async {
    // Tabla de favoritos
    await db.execute('''
      CREATE TABLE $_favoritesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        filePath TEXT UNIQUE NOT NULL,
        fileName TEXT NOT NULL,
        dateAdded INTEGER NOT NULL,
        isDirectory INTEGER NOT NULL
      )
    ''');
    
    // Tabla de archivos recientes
    await db.execute('''
      CREATE TABLE $_recentFilesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        filePath TEXT UNIQUE NOT NULL,
        fileName TEXT NOT NULL,
        lastAccessed INTEGER NOT NULL,
        isDirectory INTEGER NOT NULL,
        fileType TEXT NOT NULL
      )
    ''');
  }
  
  // ===================== OPERACIONES DE FAVORITOS =====================
  
  Future<void> addFavorite(FavoriteEntity favorite) async {
    final db = await database;
    await db.insert(
      _favoritesTable,
      favorite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<void> removeFavorite(String filePath) async {
    final db = await database;
    await db.delete(
      _favoritesTable,
      where: 'filePath = ?',
      whereArgs: [filePath],
    );
  }
  
  Future<List<FavoriteEntity>> getFavorites() async {
    final db = await database;
    final maps = await db.query(_favoritesTable, orderBy: 'dateAdded DESC');
    
    return List.generate(maps.length, (i) {
      return FavoriteEntity.fromMap(maps[i]);
    });
  }
  
  Future<bool> isFavorite(String filePath) async {
    final db = await database;
    final result = await db.query(
      _favoritesTable,
      where: 'filePath = ?',
      whereArgs: [filePath],
    );
    return result.isNotEmpty;
  }
  
  Future<void> clearFavorites() async {
    final db = await database;
    await db.delete(_favoritesTable);
  }
  
  // ===================== OPERACIONES DE ARCHIVOS RECIENTES =====================
  
  Future<void> addRecentFile(RecentFileEntity recentFile) async {
    final db = await database;
    await db.insert(
      _recentFilesTable,
      recentFile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // Mantener solo los últimos 50 archivos
    await _cleanupRecentFiles();
  }
  
  Future<List<RecentFileEntity>> getRecentFiles({int? limit}) async {
    final db = await database;
    final maps = await db.query(
      _recentFilesTable, 
      orderBy: 'lastAccessed DESC',
      limit: limit ?? 20,
    );
    
    return List.generate(maps.length, (i) {
      return RecentFileEntity.fromMap(maps[i]);
    });
  }
  
  Future<void> removeRecentFile(String filePath) async {
    final db = await database;
    await db.delete(
      _recentFilesTable,
      where: 'filePath = ?',
      whereArgs: [filePath],
    );
  }
  
  Future<void> clearRecentFiles() async {
    final db = await database;
    await db.delete(_recentFilesTable);
  }
  
  Future<void> updateLastAccessed(String filePath) async {
    final db = await database;
    await db.update(
      _recentFilesTable,
      {'lastAccessed': DateTime.now().millisecondsSinceEpoch},
      where: 'filePath = ?',
      whereArgs: [filePath],
    );
  }
  
  Future<void> _cleanupRecentFiles() async {
    final db = await database;
    await db.delete(
      _recentFilesTable,
      where: 'id NOT IN (SELECT id FROM $_recentFilesTable ORDER BY lastAccessed DESC LIMIT 50)',
    );
  }
  
  // ===================== BÚSQUEDA AVANZADA =====================
  
  Future<List<RecentFileEntity>> searchRecentFiles(String query) async {
    final db = await database;
    final maps = await db.query(
      _recentFilesTable,
      where: 'fileName LIKE ? OR filePath LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'lastAccessed DESC',
      limit: 20,
    );
    
    return List.generate(maps.length, (i) {
      return RecentFileEntity.fromMap(maps[i]);
    });
  }
  
  Future<List<FavoriteEntity>> searchFavorites(String query) async {
    final db = await database;
    final maps = await db.query(
      _favoritesTable,
      where: 'fileName LIKE ? OR filePath LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'dateAdded DESC',
    );
    
    return List.generate(maps.length, (i) {
      return FavoriteEntity.fromMap(maps[i]);
    });
  }
  
  // ===================== ESTADÍSTICAS =====================
  
  Future<Map<String, int>> getStatistics() async {
    final db = await database;
    
    final favoritesCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_favoritesTable')
    ) ?? 0;
    
    final recentCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_recentFilesTable')
    ) ?? 0;
    
    return {
      'favorites': favoritesCount,
      'recent': recentCount,
    };
  }
}