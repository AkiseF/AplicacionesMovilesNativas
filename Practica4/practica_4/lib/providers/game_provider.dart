import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../models/question.dart';
import '../models/game_session.dart';
import '../services/character_service.dart';
import '../services/ai_service.dart';
import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier {
  GameSession? _currentGame;
  bool _isLoading = false;
  String? _error;

  // Getters
  GameSession? get currentGame => _currentGame;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasGame => _currentGame != null;

  // Game state getters
  GameState? get gameState => _currentGame?.state;
  PlayerTurn? get currentTurn => _currentGame?.currentTurn;
  List<Character> get gameBoard => _currentGame?.gameBoard ?? [];
  List<Character> get currentVisibleCharacters => _currentGame?.currentVisibleCharacters ?? [];
  DifficultyLevel? get difficulty => _currentGame?.difficulty;
  bool get hasMultipleGrids => _currentGame?.hasMultipleGrids ?? false;
  int get currentGridIndex => _currentGame?.currentGridIndex ?? 0;
  GridDimensions? get gridDimensions => _currentGame?.gridDimensions;
  Character? get player1Character => _currentGame?.player1Character;
  Character? get player2Character => _currentGame?.player2Character;
  int get player1Score => _currentGame?.player1Score ?? 0;
  int get player2Score => _currentGame?.player2Score ?? 0;
  List<Question> get availableQuestions => _currentGame?.availableQuestions ?? [];

  // Nuevos getters para la lógica del juego
  List<Character> get currentPlayerBoard {
    if (_currentGame == null) return [];
    
    return _currentGame!.gameBoard
        .where((character) => !character.isEliminated)
        .toList();
  }

  bool get canMakeGuess => currentPlayerBoard.length > 1;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Start a new game
  Future<void> startNewGame(GameMode mode, {DifficultyLevel difficulty = DifficultyLevel.hard, bool keepScore = false}) async {
    _setLoading(true);
    _setError(null);

    // Save current scores if we're keeping them
    final previousPlayer1Score = keepScore ? (_currentGame?.player1Score ?? 0) : 0;
    final previousPlayer2Score = keepScore ? (_currentGame?.player2Score ?? 0) : 0;

    try {
      print('🎮 Iniciando nuevo juego - Modo: $mode, Dificultad: $difficulty');
      
      // Load game board based on difficulty
      final characters = await CharacterService.instance.getGameBoardForDifficulty(difficulty);
      
      print('✅ Personajes cargados: ${characters.length}');
      
      if (characters.isEmpty) {
        throw Exception('No se cargaron personajes');
      }
      
      // Create new game session
      _currentGame = GameSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        mode: mode,
        difficulty: difficulty,
        state: GameState.characterSelection,
        gameBoard: characters,
        questions: QuestionSet.getDefaultQuestions(),
        player1Score: previousPlayer1Score,
        player2Score: previousPlayer2Score,
      );

      print('✅ Juego creado exitosamente');
      print('   - hasGame: $hasGame');
      print('   - Estado: ${_currentGame?.state}');
      print('   - Characters: ${_currentGame?.gameBoard.length}');
      print('   - Scores: $previousPlayer1Score - $previousPlayer2Score');
      
    } catch (e) {
      print('❌ Error al crear juego: $e');
      _setError('Failed to start game: $e');
      _currentGame = null;
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Switch between grids in expert mode
  void switchGrid() {
    if (_currentGame?.hasMultipleGrids == true) {
      _currentGame!.switchGrid();
      notifyListeners();
    }
  }

  // Select character for current player
  void selectCharacter(Character character) {
    if (_currentGame == null) return;

    final currentPlayer = _currentGame!.currentTurn;
    _currentGame!.selectCharacter(character, currentPlayer);

    // If single player mode, AI selects its character
    if (_currentGame!.mode == GameMode.singlePlayer && 
        _currentGame!.player1Character != null && 
        _currentGame!.player2Character == null) {
      
      // AI selects from remaining characters
      final availableForAI = _currentGame!.gameBoard
          .where((c) => c.id != character.id)
          .toList();
      
      final aiCharacter = AIService.instance.selectCharacter(availableForAI);
      _currentGame!.selectCharacter(aiCharacter, PlayerTurn.player2);
    }

    // Check if both players have selected characters
    if (_currentGame!.player1Character != null && _currentGame!.player2Character != null) {
      _currentGame!.state = GameState.playing;
    }

    notifyListeners();
  }

  // Ask a question
  Future<void> askQuestion(Question question) async {
    if (_currentGame == null || _currentGame!.state != GameState.playing) return;

    final currentPlayer = _currentGame!.currentTurn;
    
    if (_currentGame!.mode == GameMode.singlePlayer && currentPlayer == PlayerTurn.player1) {
      // Player asks AI
      final aiCharacter = _currentGame!.player2Character!;
      final answer = AIService.instance.answerQuestion(question, aiCharacter);
      
      // Record the action
      final action = GameAction.question(
        player: currentPlayer,
        question: question,
        answer: answer,
      );
      _currentGame!.addGameAction(action);

      // Show answer to player (they need to eliminate characters based on this)
      // The elimination will be handled by the UI
      
      notifyListeners();
    } else if (_currentGame!.mode == GameMode.twoPlayer) {
      // TODO: Send question via Bluetooth when implemented
      // For now, just add to game history
      final action = GameAction.question(
        player: currentPlayer,
        question: question,
        answer: false, // Placeholder
      );
      _currentGame!.addGameAction(action);
    }
  }

  // Answer a question (for receiving player)
  void answerQuestion(Question question, bool answer) {
    if (_currentGame == null) return;

    final action = GameAction.question(
      player: _currentGame!.currentTurn,
      question: question,
      answer: answer,
    );
    _currentGame!.addGameAction(action);

    if (_currentGame!.mode == GameMode.twoPlayer) {
      // TODO: Send answer via Bluetooth when implemented
    }

    notifyListeners();
  }

  // Eliminate character
  void eliminateCharacter(Character character) {
    if (_currentGame == null) return;

    _currentGame!.eliminateCharacter(character);

    final action = GameAction.elimination(
      player: _currentGame!.currentTurn,
      character: character,
    );
    _currentGame!.addGameAction(action);

    // Switch turns after elimination
    _currentGame!.switchTurn();

    // In single player mode, trigger AI turn
    if (_currentGame!.mode == GameMode.singlePlayer && 
        _currentGame!.currentTurn == PlayerTurn.player2) {
      _handleAITurn();
    }

    notifyListeners();
  }

  // Make a guess about opponent's character
  void makeGuess(Character character) {
    if (_currentGame == null || _currentGame!.state != GameState.playing) return;

    final currentPlayer = _currentGame!.currentTurn;
    final opponentCharacter = _currentGame!.opposingPlayerCharacter;
    
    if (opponentCharacter == null) {
      _setError('No se pudo determinar el personaje del oponente');
      return;
    }
    
    final correct = opponentCharacter.id == character.id;

    final action = GameAction.guess(
      player: currentPlayer,
      character: character,
      correct: correct,
    );
    _currentGame!.addGameAction(action);

    if (correct) {
      // Current player wins
      _currentGame!.addScore(currentPlayer);
      _currentGame!.state = GameState.gameOver;
    } else {
      // Wrong guess - current player loses
      final opponent = currentPlayer == PlayerTurn.player1 ? PlayerTurn.player2 : PlayerTurn.player1;
      _currentGame!.addScore(opponent);
      _currentGame!.state = GameState.gameOver;
    }

    notifyListeners();
  }

  // Eliminate characters based on question answer
  void eliminateCharactersBasedOnAnswer(Question question, bool answer) {
    if (_currentGame == null) return;

    bool anyElimination = false;
    
    for (int i = 0; i < _currentGame!.gameBoard.length; i++) {
      final character = _currentGame!.gameBoard[i];
      if (character.isEliminated) continue;
      
      final questionResult = question.checkAnswer(character);
      
      // If the answer doesn't match the question result, eliminate the character
      if (questionResult != answer) {
        _currentGame!.gameBoard[i] = character.copyWith(isEliminated: true);
        anyElimination = true;
        
        // Record elimination action
        final action = GameAction.elimination(
          player: _currentGame!.currentTurn,
          character: character,
        );
        _currentGame!.addGameAction(action);
      }
    }

    if (anyElimination) {
      // Check if only one character remains (auto-win condition)
      final remainingCharacters = currentPlayerBoard;
      if (remainingCharacters.length == 1) {
        // Auto-guess the remaining character
        makeGuess(remainingCharacters.first);
      } else {
        // Switch turns
        _currentGame!.switchTurn();
        
        // If it's AI's turn, handle it
        if (_currentGame!.mode == GameMode.singlePlayer && 
            _currentGame!.currentTurn == PlayerTurn.player2) {
          _handleAITurn();
        }
      }
    }

    notifyListeners();
  }

  // Handle AI turn in single player mode
  Future<void> _handleAITurn() async {
    if (_currentGame == null || _currentGame!.mode != GameMode.singlePlayer) return;

    await AIService.instance.simulateThinking();

    final aiAction = AIService.instance.decideAction(_currentGame!);

    if (aiAction.type == AIActionType.askQuestion && aiAction.question != null) {
      // AI asks a question
      final playerCharacter = _currentGame!.player1Character!;
      final answer = aiAction.question!.checkAnswer(playerCharacter);

      final action = GameAction.question(
        player: PlayerTurn.player2,
        question: aiAction.question!,
        answer: answer,
      );
      _currentGame!.addGameAction(action);

      // AI eliminates characters based on the answer
      bool anyElimination = false;
      for (int i = 0; i < _currentGame!.gameBoard.length; i++) {
        final character = _currentGame!.gameBoard[i];
        if (character.isEliminated) continue;
        
        final questionResult = aiAction.question!.checkAnswer(character);
        
        if (questionResult != answer) {
          _currentGame!.gameBoard[i] = character.copyWith(isEliminated: true);
          anyElimination = true;
          
          final eliminationAction = GameAction.elimination(
            player: PlayerTurn.player2,
            character: character,
          );
          _currentGame!.addGameAction(eliminationAction);
        }
      }

      if (anyElimination) {
        // Check win condition for AI
        final remainingCharacters = _currentGame!.gameBoard
            .where((c) => !c.isEliminated)
            .toList();
            
        if (remainingCharacters.length == 1) {
          // AI wins by elimination
          _currentGame!.addScore(PlayerTurn.player2);
          _currentGame!.state = GameState.gameOver;
        } else {
          _currentGame!.switchTurn(); // Back to player
        }
      } else {
        _currentGame!.switchTurn(); // Back to player even if no elimination
      }
      
    } else if (aiAction.type == AIActionType.makeGuess && aiAction.character != null) {
      // AI makes a guess
      final playerCharacter = _currentGame!.player1Character!;
      final correct = playerCharacter.id == aiAction.character!.id;

      final action = GameAction.guess(
        player: PlayerTurn.player2,
        character: aiAction.character!,
        correct: correct,
      );
      _currentGame!.addGameAction(action);

      if (correct) {
        // AI wins
        _currentGame!.addScore(PlayerTurn.player2);
        _currentGame!.state = GameState.gameOver;
      } else {
        // Wrong guess, back to player
        _currentGame!.switchTurn();
      }
    }

    notifyListeners();
  }

  // Show game result (para usar desde la UI)
  void showGameResult(BuildContext context, bool won) {
    final character = _currentGame!.opposingPlayerCharacter;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(won ? '¡Ganaste!' : 'Perdiste'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(won 
              ? '¡Correcto! El personaje era ${character?.name}'
              : 'Incorrecto. El personaje era ${character?.name}'
            ),
            const SizedBox(height: 16),
            Text(
              'Puntuación: ${_currentGame!.player1Score} - ${_currentGame!.player2Score}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  // Reset current game
  void resetGame() {
    _currentGame = null;
    _error = null;
    notifyListeners();
  }

  // End current game
  void endGame() {
    if (_currentGame != null) {
      _currentGame!.state = GameState.gameOver;
      notifyListeners();
    }
  }

  // Get character by ID
  Character? getCharacterById(int id) {
    if (_currentGame == null) return null;
    
    try {
      return _currentGame!.gameBoard.firstWhere((character) => character.id == id);
    } catch (e) {
      return null;
    }
  }
}