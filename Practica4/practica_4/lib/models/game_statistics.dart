import 'game_session.dart'; // ✅ Importar GameMode y DifficultyLevel desde aquí

class GameStatistics {
  final int id;
  final DateTime date;
  final GameMode mode;
  final DifficultyLevel difficulty;
  final bool playerWon;
  final int playerScore;
  final int opponentScore;
  final int questionsAsked;
  final int charactersEliminated;
  final Duration gameDuration;
  final String? opponentName; // For multiplayer games

  GameStatistics({
    required this.id,
    required this.date,
    required this.mode,
    required this.difficulty,
    required this.playerWon,
    required this.playerScore,
    required this.opponentScore,
    required this.questionsAsked,
    required this.charactersEliminated,
    required this.gameDuration,
    this.opponentName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mode': mode.name,
      'difficulty': difficulty.name,
      'playerWon': playerWon ? 1 : 0,
      'playerScore': playerScore,
      'opponentScore': opponentScore,
      'questionsAsked': questionsAsked,
      'charactersEliminated': charactersEliminated,
      'gameDurationSeconds': gameDuration.inSeconds,
      'opponentName': opponentName,
    };
  }

  factory GameStatistics.fromMap(Map<String, dynamic> map) {
    return GameStatistics(
      id: map['id'] as int,
      date: DateTime.parse(map['date'] as String),
      mode: GameMode.values.firstWhere((e) => e.name == map['mode']),
      difficulty: DifficultyLevel.values.firstWhere((e) => e.name == map['difficulty']),
      playerWon: map['playerWon'] == 1,
      playerScore: map['playerScore'] as int,
      opponentScore: map['opponentScore'] as int,
      questionsAsked: map['questionsAsked'] as int,
      charactersEliminated: map['charactersEliminated'] as int,
      gameDuration: Duration(seconds: map['gameDurationSeconds'] as int),
      opponentName: map['opponentName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mode': mode.name,
      'difficulty': difficulty.name,
      'playerWon': playerWon,
      'playerScore': playerScore,
      'opponentScore': opponentScore,
      'questionsAsked': questionsAsked,
      'charactersEliminated': charactersEliminated,
      'gameDurationSeconds': gameDuration.inSeconds,
      'opponentName': opponentName,
    };
  }

  factory GameStatistics.fromJson(Map<String, dynamic> json) {
    return GameStatistics(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      mode: GameMode.values.firstWhere((e) => e.name == json['mode']),
      difficulty: DifficultyLevel.values.firstWhere((e) => e.name == json['difficulty']),
      playerWon: json['playerWon'] as bool,
      playerScore: json['playerScore'] as int,
      opponentScore: json['opponentScore'] as int,
      questionsAsked: json['questionsAsked'] as int,
      charactersEliminated: json['charactersEliminated'] as int,
      gameDuration: Duration(seconds: json['gameDurationSeconds'] as int),
      opponentName: json['opponentName'] as String?,
    );
  }
}

// ❌ ENUMS ELIMINADOS - Ya están definidos en game_session.dart

class PlayerProfile {
  final int id;
  final String playerName;
  final int totalGamesPlayed;
  final int totalWins;
  final int totalLosses;
  final DateTime createdAt;
  final DateTime lastPlayedAt;

  PlayerProfile({
    required this.id,
    required this.playerName,
    required this.totalGamesPlayed,
    required this.totalWins,
    required this.totalLosses,
    required this.createdAt,
    required this.lastPlayedAt,
  });

  double get winRate {
    if (totalGamesPlayed == 0) return 0.0;
    return (totalWins / totalGamesPlayed) * 100;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerName': playerName,
      'totalGamesPlayed': totalGamesPlayed,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
      'createdAt': createdAt.toIso8601String(),
      'lastPlayedAt': lastPlayedAt.toIso8601String(),
    };
  }

  factory PlayerProfile.fromMap(Map<String, dynamic> map) {
    return PlayerProfile(
      id: map['id'] as int,
      playerName: map['playerName'] as String,
      totalGamesPlayed: map['totalGamesPlayed'] as int,
      totalWins: map['totalWins'] as int,
      totalLosses: map['totalLosses'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastPlayedAt: DateTime.parse(map['lastPlayedAt'] as String),
    );
  }

  PlayerProfile copyWith({
    int? id,
    String? playerName,
    int? totalGamesPlayed,
    int? totalWins,
    int? totalLosses,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
  }) {
    return PlayerProfile(
      id: id ?? this.id,
      playerName: playerName ?? this.playerName,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }
}

class AggregatedStatistics {
  final int totalGames;
  final int totalWins;
  final int totalLosses;
  final double winRate;
  final int totalQuestionsAsked;
  final double avgQuestionsPerGame;
  final Duration totalPlayTime;
  final Duration avgGameDuration;
  final Map<DifficultyLevel, int> gamesPerDifficulty;
  final Map<GameMode, int> gamesPerMode;
  final int currentWinStreak;
  final int longestWinStreak;

  AggregatedStatistics({
    required this.totalGames,
    required this.totalWins,
    required this.totalLosses,
    required this.winRate,
    required this.totalQuestionsAsked,
    required this.avgQuestionsPerGame,
    required this.totalPlayTime,
    required this.avgGameDuration,
    required this.gamesPerDifficulty,
    required this.gamesPerMode,
    required this.currentWinStreak,
    required this.longestWinStreak,
  });

  factory AggregatedStatistics.fromGamesList(List<GameStatistics> games) {
    if (games.isEmpty) {
      return AggregatedStatistics(
        totalGames: 0,
        totalWins: 0,
        totalLosses: 0,
        winRate: 0.0,
        totalQuestionsAsked: 0,
        avgQuestionsPerGame: 0.0,
        totalPlayTime: Duration.zero,
        avgGameDuration: Duration.zero,
        gamesPerDifficulty: {},
        gamesPerMode: {},
        currentWinStreak: 0,
        longestWinStreak: 0,
      );
    }

    final totalGames = games.length;
    final totalWins = games.where((g) => g.playerWon).length;
    final totalLosses = totalGames - totalWins;
    final winRate = (totalWins / totalGames) * 100;

    final totalQuestionsAsked = games.fold<int>(0, (sum, g) => sum + g.questionsAsked);
    final avgQuestionsPerGame = totalQuestionsAsked / totalGames;

    final totalPlayTime = games.fold<Duration>(Duration.zero, (sum, g) => sum + g.gameDuration);
    final avgGameDuration = Duration(
      seconds: (totalPlayTime.inSeconds / totalGames).round(),
    );

    // Games per difficulty
    final gamesPerDifficulty = <DifficultyLevel, int>{};
    for (final game in games) {
      gamesPerDifficulty[game.difficulty] = (gamesPerDifficulty[game.difficulty] ?? 0) + 1;
    }

    // Games per mode
    final gamesPerMode = <GameMode, int>{};
    for (final game in games) {
      gamesPerMode[game.mode] = (gamesPerMode[game.mode] ?? 0) + 1;
    }

    // Calculate streaks
    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;

    // Sort by date descending (most recent first)
    final sortedGames = List<GameStatistics>.from(games)
      ..sort((a, b) => b.date.compareTo(a.date));

    for (int i = 0; i < sortedGames.length; i++) {
      if (sortedGames[i].playerWon) {
        tempStreak++;
        if (i == 0) {
          currentStreak = tempStreak;
        }
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
      } else {
        if (i == 0) {
          currentStreak = 0;
        }
        tempStreak = 0;
      }
    }

    return AggregatedStatistics(
      totalGames: totalGames,
      totalWins: totalWins,
      totalLosses: totalLosses,
      winRate: winRate,
      totalQuestionsAsked: totalQuestionsAsked,
      avgQuestionsPerGame: avgQuestionsPerGame,
      totalPlayTime: totalPlayTime,
      avgGameDuration: avgGameDuration,
      gamesPerDifficulty: gamesPerDifficulty,
      gamesPerMode: gamesPerMode,
      currentWinStreak: currentStreak,
      longestWinStreak: longestStreak,
    );
  }
}