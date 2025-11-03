import 'character.dart';
import 'question.dart';

enum GameMode {
  singlePlayer,
  twoPlayer,
}

enum DifficultyLevel {
  easy,    // 2x2 grid (4 characters)
  medium,  // 3x3 grid (9 characters)
  hard,    // 4x4 grid (16 characters)
  expert,  // 2x 4x4 grids (32 characters)
}

enum GameState {
  setup,
  difficultySelection,
  characterSelection,
  playing,
  gameOver,
}

enum PlayerTurn {
  player1,
  player2,
}

class GridDimensions {
  final int rows;
  final int columns;
  
  const GridDimensions(this.rows, this.columns);
  
  int get totalCells => rows * columns;
}

class GameSession {
  final String id;
  final GameMode mode;
  final DifficultyLevel difficulty;
  GameState state;
  PlayerTurn currentTurn;
  
  // Game board - can be 4, 9, 16, or 32 characters depending on difficulty
  List<Character> gameBoard;
  
  // For expert mode - we'll split the board into two grids
  List<Character> get firstGrid => difficulty == DifficultyLevel.expert 
    ? gameBoard.take(16).toList() 
    : gameBoard;
  
  List<Character> get secondGrid => difficulty == DifficultyLevel.expert 
    ? gameBoard.skip(16).toList() 
    : [];
  
  // Current grid being displayed (for expert mode navigation)
  int currentGridIndex;
  
  // Selected characters for each player
  Character? player1Character;
  Character? player2Character;
  
  // Player scores
  int player1Score;
  int player2Score;
  
  // Available questions
  List<Question> availableQuestions;
  
  // Game history
  List<GameAction> gameHistory;
  
  // For multiplayer
  String? bluetoothConnectionId;
  bool isHost;
  
  GameSession({
    required this.id,
    required this.mode,
    this.difficulty = DifficultyLevel.hard,
    this.state = GameState.setup,
    this.currentTurn = PlayerTurn.player1,
    this.gameBoard = const [],
    this.currentGridIndex = 0,
    this.player1Character,
    this.player2Character,
    this.player1Score = 0,
    this.player2Score = 0,
    List<Question>? questions,
    this.gameHistory = const [],
    this.bluetoothConnectionId,
    this.isHost = false,
  }) : availableQuestions = questions ?? QuestionSet.getDefaultQuestions();

  bool get isCurrentPlayerTurn => currentTurn == PlayerTurn.player1;
  
  Character? get currentPlayerCharacter => 
    currentTurn == PlayerTurn.player1 ? player1Character : player2Character;
  
  Character? get opposingPlayerCharacter => 
    currentTurn == PlayerTurn.player1 ? player2Character : player1Character;

  // Get grid dimensions based on difficulty
  GridDimensions get gridDimensions {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return const GridDimensions(2, 2);
      case DifficultyLevel.medium:
        return const GridDimensions(3, 3);
      case DifficultyLevel.hard:
        return const GridDimensions(4, 4);
      case DifficultyLevel.expert:
        return const GridDimensions(4, 4); // Each grid is 4x4
    }
  }

  // Get number of characters needed for the difficulty
  int get requiredCharacterCount {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 4;
      case DifficultyLevel.medium:
        return 9;
      case DifficultyLevel.hard:
        return 16;
      case DifficultyLevel.expert:
        return 32;
    }
  }

  // Check if difficulty uses multiple grids
  bool get hasMultipleGrids => difficulty == DifficultyLevel.expert;

  // Get current visible characters based on grid index
  List<Character> get currentVisibleCharacters {
    if (!hasMultipleGrids) return gameBoard;
    
    if (currentGridIndex == 0) {
      return firstGrid;
    } else {
      return secondGrid;
    }
  }

  void switchGrid() {
    if (hasMultipleGrids) {
      currentGridIndex = currentGridIndex == 0 ? 1 : 0;
    }
  }

  void switchTurn() {
    currentTurn = currentTurn == PlayerTurn.player1 
        ? PlayerTurn.player2 
        : PlayerTurn.player1;
  }

  void selectCharacter(Character character, PlayerTurn player) {
    if (player == PlayerTurn.player1) {
      player1Character = character;
    } else {
      player2Character = character;
    }
  }

  void eliminateCharacter(Character character) {
    final index = gameBoard.indexWhere((c) => c.id == character.id);
    if (index != -1) {
      gameBoard[index] = gameBoard[index].copyWith(isEliminated: true);
    }
  }

  bool checkWinCondition() {
    final currentPlayer = currentTurn;
    final guessedCharacter = currentPlayer == PlayerTurn.player1 
        ? player2Character 
        : player1Character;
    
    if (guessedCharacter == null) return false;
    
    // Check if the current player has correctly identified the opponent's character
    final nonEliminatedCharacters = gameBoard
        .where((character) => !character.isEliminated)
        .toList();
    
    // If only one character remains and it matches the opponent's character
    return nonEliminatedCharacters.length == 1 && 
           nonEliminatedCharacters.first.id == guessedCharacter.id;
  }

  void addScore(PlayerTurn player) {
    if (player == PlayerTurn.player1) {
      player1Score++;
    } else {
      player2Score++;
    }
  }

  void addGameAction(GameAction action) {
    gameHistory = [...gameHistory, action];
  }

  String get difficultyDisplayName {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Fácil';
      case DifficultyLevel.medium:
        return 'Medio';
      case DifficultyLevel.hard:
        return 'Difícil';
      case DifficultyLevel.expert:
        return 'Experto';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode': mode.toString(),
      'difficulty': difficulty.toString(),
      'state': state.toString(),
      'currentTurn': currentTurn.toString(),
      'currentGridIndex': currentGridIndex,
      'gameBoard': gameBoard.map((c) => c.toJson()).toList(),
      'player1Character': player1Character?.toJson(),
      'player2Character': player2Character?.toJson(),
      'player1Score': player1Score,
      'player2Score': player2Score,
      'gameHistory': gameHistory.map((a) => a.toJson()).toList(),
      'bluetoothConnectionId': bluetoothConnectionId,
      'isHost': isHost,
    };
  }
}

class GameAction {
  final String type;
  final PlayerTurn player;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  GameAction({
    required this.type,
    required this.player,
    required this.timestamp,
    required this.data,
  });

  factory GameAction.question({
    required PlayerTurn player,
    required Question question,
    required bool answer,
  }) {
    return GameAction(
      type: 'question',
      player: player,
      timestamp: DateTime.now(),
      data: {
        'questionId': question.id,
        'questionText': question.text,
        'answer': answer,
      },
    );
  }

  factory GameAction.elimination({
    required PlayerTurn player,
    required Character character,
  }) {
    return GameAction(
      type: 'elimination',
      player: player,
      timestamp: DateTime.now(),
      data: {
        'characterId': character.id,
        'characterName': character.name,
      },
    );
  }

  factory GameAction.guess({
    required PlayerTurn player,
    required Character character,
    required bool correct,
  }) {
    return GameAction(
      type: 'guess',
      player: player,
      timestamp: DateTime.now(),
      data: {
        'characterId': character.id,
        'characterName': character.name,
        'correct': correct,
      },
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'player': player.toString(),
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }

  factory GameAction.fromJson(Map<String, dynamic> json) {
    return GameAction(
      type: json['type'] as String,
      player: PlayerTurn.values.firstWhere(
        (p) => p.toString() == json['player'],
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: Map<String, dynamic>.from(json['data'] as Map),
    );
  }
}