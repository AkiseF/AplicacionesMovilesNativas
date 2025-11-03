import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/game_statistics.dart';
import '../models/game_session.dart'; // ✅ AGREGADO: Import para GameMode y DifficultyLevel

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();
  DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'guess_who_game.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create player_profile table
    await db.execute('''
      CREATE TABLE player_profile(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playerName TEXT NOT NULL,
        totalGamesPlayed INTEGER NOT NULL DEFAULT 0,
        totalWins INTEGER NOT NULL DEFAULT 0,
        totalLosses INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        lastPlayedAt TEXT NOT NULL
      )
    ''');

    // Create game_statistics table
    await db.execute('''
      CREATE TABLE game_statistics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        mode TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        playerWon INTEGER NOT NULL,
        playerScore INTEGER NOT NULL,
        opponentScore INTEGER NOT NULL,
        questionsAsked INTEGER NOT NULL,
        charactersEliminated INTEGER NOT NULL,
        gameDurationSeconds INTEGER NOT NULL,
        opponentName TEXT
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_game_date ON game_statistics(date)');
    await db.execute('CREATE INDEX idx_game_mode ON game_statistics(mode)');
    await db.execute('CREATE INDEX idx_game_difficulty ON game_statistics(difficulty)');
    await db.execute('CREATE INDEX idx_player_won ON game_statistics(playerWon)');

    if (kDebugMode) {
      debugPrint('✅ Base de datos creada exitosamente');
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here if needed in future versions
  }

  // ==================== PLAYER PROFILE OPERATIONS ====================

  /// Get or create player profile
  Future<PlayerProfile> getOrCreatePlayerProfile() async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'player_profile',
      limit: 1,
    );

    if (maps.isEmpty) {
      // Create default profile
      final now = DateTime.now();
      final profile = PlayerProfile(
        id: 1,
        playerName: 'Jugador',
        totalGamesPlayed: 0,
        totalWins: 0,
        totalLosses: 0,
        createdAt: now,
        lastPlayedAt: now,
      );

      await db.insert('player_profile', profile.toMap());
      return profile;
    }

    return PlayerProfile.fromMap(maps.first);
  }

  /// Update player profile
  Future<void> updatePlayerProfile(PlayerProfile profile) async {
    final db = await database;
    
    await db.update(
      'player_profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  /// Update player name
  Future<void> updatePlayerName(String newName) async {
    final profile = await getOrCreatePlayerProfile();
    final updatedProfile = profile.copyWith(playerName: newName);
    await updatePlayerProfile(updatedProfile);
  }

  // ==================== GAME STATISTICS OPERATIONS ====================

  /// Save a game result
  Future<int> saveGameStatistics(GameStatistics stats) async {
    final db = await database;
    
    // Insert game statistics
    final id = await db.insert('game_statistics', stats.toMap());

    // Update player profile
    final profile = await getOrCreatePlayerProfile();
    final updatedProfile = profile.copyWith(
      totalGamesPlayed: profile.totalGamesPlayed + 1,
      totalWins: stats.playerWon ? profile.totalWins + 1 : profile.totalWins,
      totalLosses: !stats.playerWon ? profile.totalLosses + 1 : profile.totalLosses,
      lastPlayedAt: DateTime.now(),
    );
    await updatePlayerProfile(updatedProfile);

    if (kDebugMode) {
      debugPrint('✅ Estadísticas guardadas (ID: $id)');
    }
    return id;
  }

  /// Get all game statistics
  Future<List<GameStatistics>> getAllGameStatistics() async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'game_statistics',
      orderBy: 'date DESC',
    );

    return maps.map((map) => GameStatistics.fromMap(map)).toList();
  }

  /// Get game statistics with filters
  Future<List<GameStatistics>> getGameStatistics({
    GameMode? mode,
    DifficultyLevel? difficulty,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    final db = await database;
    
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (mode != null) {
      whereClause += 'mode = ?';
      whereArgs.add(mode.name);
    }

    if (difficulty != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'difficulty = ?';
      whereArgs.add(difficulty.name);
    }

    if (startDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'date >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'date <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'game_statistics',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'date DESC',
      limit: limit,
    );

    return maps.map((map) => GameStatistics.fromMap(map)).toList();
  }

  /// Get recent games
  Future<List<GameStatistics>> getRecentGames({int limit = 10}) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      'game_statistics',
      orderBy: 'date DESC',
      limit: limit,
    );

    return maps.map((map) => GameStatistics.fromMap(map)).toList();
  }

  /// Get aggregated statistics
  Future<AggregatedStatistics> getAggregatedStatistics() async {
    final allGames = await getAllGameStatistics();
    return AggregatedStatistics.fromGamesList(allGames);
  }

  /// Get statistics for a specific difficulty
  Future<AggregatedStatistics> getStatisticsByDifficulty(DifficultyLevel difficulty) async {
    final games = await getGameStatistics(difficulty: difficulty);
    return AggregatedStatistics.fromGamesList(games);
  }

  /// Get statistics for a specific mode
  Future<AggregatedStatistics> getStatisticsByMode(GameMode mode) async {
    final games = await getGameStatistics(mode: mode);
    return AggregatedStatistics.fromGamesList(games);
  }

  /// Get win/loss record
  Future<Map<String, int>> getWinLossRecord() async {
    final db = await database;
    
    final wins = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM game_statistics WHERE playerWon = 1'
    )) ?? 0;
    
    final losses = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM game_statistics WHERE playerWon = 0'
    )) ?? 0;

    return {
      'wins': wins,
      'losses': losses,
      'total': wins + losses,
    };
  }

  /// Get total play time
  Future<Duration> getTotalPlayTime() async {
    final db = await database;
    
    final result = await db.rawQuery(
      'SELECT SUM(gameDurationSeconds) as total FROM game_statistics'
    );

    final totalSeconds = result.first['total'] as int? ?? 0;
    return Duration(seconds: totalSeconds);
  }

  /// Delete a game statistic
  Future<void> deleteGameStatistic(int id) async {
    final db = await database;
    await db.delete(
      'game_statistics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Clear all statistics
  Future<void> clearAllStatistics() async {
    final db = await database;
    await db.delete('game_statistics');
    
    // Reset player profile counts
    final profile = await getOrCreatePlayerProfile();
    final resetProfile = profile.copyWith(
      totalGamesPlayed: 0,
      totalWins: 0,
      totalLosses: 0,
    );
    await updatePlayerProfile(resetProfile);
    
    if (kDebugMode) {
      debugPrint('✅ Todas las estadísticas han sido eliminadas');
    }
  }

  /// Export statistics to JSON
  Future<Map<String, dynamic>> exportStatistics() async {
    final profile = await getOrCreatePlayerProfile();
    final allGames = await getAllGameStatistics();
    final aggregated = await getAggregatedStatistics();

    return {
      'exportDate': DateTime.now().toIso8601String(),
      'playerProfile': profile.toMap(),
      'totalGames': allGames.length,
      'aggregatedStats': {
        'totalWins': aggregated.totalWins,
        'totalLosses': aggregated.totalLosses,
        'winRate': aggregated.winRate,
        'totalPlayTime': aggregated.totalPlayTime.inSeconds,
        'avgGameDuration': aggregated.avgGameDuration.inSeconds,
      },
      'gameHistory': allGames.map((g) => g.toJson()).toList(),
    };
  }

  /// Get statistics for the last N days
  Future<List<GameStatistics>> getStatisticsForLastDays(int days) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    return getGameStatistics(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Get best performance by difficulty
  Future<Map<DifficultyLevel, double>> getBestWinRateByDifficulty() async {
    final result = <DifficultyLevel, double>{};
    
    for (final difficulty in DifficultyLevel.values) {
      final stats = await getStatisticsByDifficulty(difficulty);
      result[difficulty] = stats.winRate;
    }
    
    return result;
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}