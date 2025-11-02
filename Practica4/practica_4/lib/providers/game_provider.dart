import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/character.dart';
import '../models/question.dart';
import '../models/game_session.dart';
import '../models/game_statistics.dart';
import '../services/character_service.dart';
import '../services/ai_service.dart';
import '../services/bluethooth_service.dart';
import '../services/database_service.dart';
import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier {
  GameSession? _currentGame;
  bool _isLoading = false;
  String? _error;
  DateTime? _gameStartTime;
  int _questionsAskedThisGame = 0;
  int _charactersEliminatedThisGame = 0;

  // Para manejar preguntas del oponente en multiplayer
  Question? _pendingOpponentQuestion;
  bool _showOpponentQuestionDialog = false;

  final BluetoothService _bluetoothService = BluetoothService.instance;
  final DatabaseService _databaseService = DatabaseService.instance;

  // Getters
  GameSession? get currentGame => _currentGame;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasGame => _currentGame != null;
  Question? get pendingOpponentQuestion => _pendingOpponentQuestion;
  bool get showOpponentQuestionDialog => _showOpponentQuestionDialog;

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

  List<Character> get currentPlayerBoard {
    if (_currentGame == null) return [];
    
    return _currentGame!.gameBoard
        .where((character) => !character.isEliminated)
        .toList();
  }

  bool get canMakeGuess => currentPlayerBoard.length > 1;

  GameProvider() {
    _setupBluetoothListeners();
  }

  void _setupBluetoothListeners() {
    _bluetoothService.messageStream.listen((message) {
      _handleBluetoothMessage(message);
    });
  }

  void _handleBluetoothMessage(BluetoothGameMessage message) {
    switch (message.type) {
      case BluetoothGameMessageType.characterSelection:
        _handleOpponentCharacterSelection(message);
        break;
      case BluetoothGameMessageType.question:
        _handleOpponentQuestion(message);
        break;
      case BluetoothGameMessageType.answer:
        _handleOpponentAnswer(message);
        break;
      case BluetoothGameMessageType.elimination:
        _handleOpponentElimination(message);
        break;
      case BluetoothGameMessageType.guess:
        _handleOpponentGuess(message);
        break;
      case BluetoothGameMessageType.gameStart:
        _handleGameStartFromHost(message);
        break;
      case BluetoothGameMessageType.turnChange:
        _handleTurnChange(message);
        break;
      default:
        break;
    }
  }

  void _handleOpponentCharacterSelection(BluetoothGameMessage message) {
    if (_currentGame == null) return;
    
    final characterId = message.data['characterId'] as int;
    final character = getCharacterById(characterId);
    
    if (character != null) {
      _currentGame!.selectCharacter(character, PlayerTurn.player2);
      
      if (_currentGame!.player1Character != null && _currentGame!.player2Character != null) {
        _currentGame!.state = GameState.playing;
      }
      
      notifyListeners();
    }
  }

  void _handleOpponentQuestion(BluetoothGameMessage message) {
    // El oponente nos está haciendo una pregunta
    final questionId = message.data['questionId'] as int;
    final questionText = message.data['questionText'] as String;
    final category = QuestionCategory.values.firstWhere(
      (e) => e.name == message.data['category'],
    );
    
    print('❓ Oponente preguntó: $questionText');
    
    // Crear una pregunta temporal para mostrar al jugador
    final temporaryQuestion = Question(
      id: questionId,
      text: questionText,
      category: category,
      checkAnswer: (character) {
        // Esta función no se usará realmente, ya que el oponente ya tiene la lógica
        // Solo necesitamos el texto para mostrar al usuario
        return false;
      },
    );
    
    // Guardar la pregunta pendiente y mostrar el diálogo
    _pendingOpponentQuestion = temporaryQuestion;
    _showOpponentQuestionDialog = true;
    notifyListeners();
  }

  void _handleOpponentAnswer(BluetoothGameMessage message) {
    final answer = message.data['answer'] as bool;
    print('✅ Oponente respondió: $answer');
    
    // Usar la respuesta para eliminar personajes en nuestro tablero
    if (_currentGame != null && _currentGame!.state == GameState.playing) {
      // Buscar la última pregunta que hicimos
      final lastQuestionAction = _currentGame!.gameHistory.reversed
          .firstWhere((action) => action.type == 'question' && action.player == PlayerTurn.player1);
      
      if (lastQuestionAction != null) {
        final questionId = lastQuestionAction.data['questionId'];
        final question = _currentGame!.availableQuestions
            .firstWhere((q) => q.id == questionId, orElse: () => _currentGame!.availableQuestions.first);
        
        // Eliminar personajes basado en la respuesta
        eliminateCharactersBasedOnAnswer(question, answer);
      }
    }
  }

  void _handleOpponentElimination(BluetoothGameMessage message) {
    // Opponent eliminated a character on their board
    // We don't need to do anything with our board
    final characterId = message.data['characterId'] as int;
    print('🗑️ Oponente eliminó personaje ID: $characterId');
  }

  void _handleOpponentGuess(BluetoothGameMessage message) {
    if (_currentGame == null) return;
    
    final characterId = message.data['characterId'] as int;
    final character = getCharacterById(characterId);
    
    if (character != null) {
      final playerCharacter = _currentGame!.player1Character!;
      final correct = playerCharacter.id == character.id;
      
      print('🎯 Oponente adivinó: ${character.name} - ${correct ? 'CORRECTO' : 'INCORRECTO'}');
      
      if (correct) {
        // Opponent wins
        _currentGame!.addScore(PlayerTurn.player2);
        _currentGame!.state = GameState.gameOver;
        _saveGameStatistics(playerWon: false);
      } else {
        // Opponent guessed wrong, we win
        _currentGame!.addScore(PlayerTurn.player1);
        _currentGame!.state = GameState.gameOver;
        _saveGameStatistics(playerWon: true);
      }
      
      notifyListeners();
    }
  }

  void _handleGameStartFromHost(BluetoothGameMessage message) async {
    final difficulty = DifficultyLevel.values.firstWhere(
      (e) => e.name == message.data['difficulty'],
    );
    final characterIds = List<int>.from(message.data['characterIds']);
    
    await startNewGame(GameMode.twoPlayer, difficulty: difficulty);
  }

  void _handleTurnChange(BluetoothGameMessage message) {
    if (_currentGame != null) {
      _currentGame!.switchTurn();
      notifyListeners();
    }
  }

  // Método para responder a la pregunta del oponente
  void answerOpponentQuestion(bool answer) {
    if (_pendingOpponentQuestion == null) return;
    
    // Enviar respuesta al oponente
    _bluetoothService.sendAnswer(answer);
    
    // Cerrar el diálogo
    _showOpponentQuestionDialog = false;
    _pendingOpponentQuestion = null;
    
    // Cambiar turno
    if (_currentGame != null) {
      _currentGame!.switchTurn();
    }
    
    notifyListeners();
  }

  // Método para cerrar el diálogo de pregunta (por si acaso)
  void closeOpponentQuestionDialog() {
    _showOpponentQuestionDialog = false;
    _pendingOpponentQuestion = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> startNewGame(GameMode mode, {DifficultyLevel difficulty = DifficultyLevel.hard, bool keepScore = false}) async {
    _setLoading(true);
    _setError(null);

    final previousPlayer1Score = keepScore ? (_currentGame?.player1Score ?? 0) : 0;
    final previousPlayer2Score = keepScore ? (_currentGame?.player2Score ?? 0) : 0;

    try {
      print('🎮 Iniciando nuevo juego - Modo: $mode, Dificultad: $difficulty');
      
      final characters = await CharacterService.instance.getGameBoardForDifficulty(difficulty);
      
      print('✅ Personajes cargados: ${characters.length}');
      
      if (characters.isEmpty) {
        throw Exception('No se cargaron personajes');
      }
      
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

      _gameStartTime = DateTime.now();
      _questionsAskedThisGame = 0;
      _charactersEliminatedThisGame = 0;

      // Resetear estado de preguntas del oponente
      _pendingOpponentQuestion = null;
      _showOpponentQuestionDialog = false;

      // If host in multiplayer mode, send game start to opponent
      if (mode == GameMode.twoPlayer && _bluetoothService.isHost) {
        await _bluetoothService.sendGameStart(_currentGame!);
      }

      print('✅ Juego creado exitosamente');
      
    } catch (e) {
      print('❌ Error al crear juego: $e');
      _setError('Failed to start game: $e');
      _currentGame = null;
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void switchGrid() {
    if (_currentGame?.hasMultipleGrids == true) {
      _currentGame!.switchGrid();
      notifyListeners();
    }
  }

  void selectCharacter(Character character) {
    if (_currentGame == null) return;

    final currentPlayer = _currentGame!.currentTurn;
    _currentGame!.selectCharacter(character, currentPlayer);

    // Send character selection via Bluetooth if in multiplayer
    if (_currentGame!.mode == GameMode.twoPlayer) {
      _bluetoothService.sendCharacterSelection(character);
    }

    // If single player mode, AI selects its character
    if (_currentGame!.mode == GameMode.singlePlayer && 
        _currentGame!.player1Character != null && 
        _currentGame!.player2Character == null) {
      
      final availableForAI = _currentGame!.gameBoard
          .where((c) => c.id != character.id)
          .toList();
      
      final aiCharacter = AIService.instance.selectCharacter(availableForAI);
      _currentGame!.selectCharacter(aiCharacter, PlayerTurn.player2);
    }

    if (_currentGame!.player1Character != null && _currentGame!.player2Character != null) {
      _currentGame!.state = GameState.playing;
    }

    notifyListeners();
  }

  Future<void> askQuestion(Question question) async {
    if (_currentGame == null || _currentGame!.state != GameState.playing) return;

    final currentPlayer = _currentGame!.currentTurn;
    _questionsAskedThisGame++;
    
    if (_currentGame!.mode == GameMode.singlePlayer && currentPlayer == PlayerTurn.player1) {
      final aiCharacter = _currentGame!.player2Character!;
      final answer = AIService.instance.answerQuestion(question, aiCharacter);
      
      final action = GameAction.question(
        player: currentPlayer,
        question: question,
        answer: answer,
      );
      _currentGame!.addGameAction(action);

      // Eliminar personajes basado en la respuesta de la IA
      eliminateCharactersBasedOnAnswer(question, answer);
      
    } else if (_currentGame!.mode == GameMode.twoPlayer) {
      // Send question via Bluetooth
      await _bluetoothService.sendQuestion(question);
      
      final action = GameAction.question(
        player: currentPlayer,
        question: question,
        answer: false, // La respuesta vendrá después
      );
      _currentGame!.addGameAction(action);
      
      // En multiplayer, no eliminamos personajes inmediatamente
      // Esperamos la respuesta del oponente
    }
    
    notifyListeners();
  }

  void answerQuestion(Question question, bool answer) {
    if (_currentGame == null) return;

    final action = GameAction.question(
      player: _currentGame!.currentTurn,
      question: question,
      answer: answer,
    );
    _currentGame!.addGameAction(action);

    if (_currentGame!.mode == GameMode.twoPlayer) {
      _bluetoothService.sendAnswer(answer);
    }

    notifyListeners();
  }

  void eliminateCharacter(Character character) {
    if (_currentGame == null) return;

    _currentGame!.eliminateCharacter(character);
    _charactersEliminatedThisGame++;

    final action = GameAction.elimination(
      player: _currentGame!.currentTurn,
      character: character,
    );
    _currentGame!.addGameAction(action);

    if (_currentGame!.mode == GameMode.twoPlayer) {
      _bluetoothService.sendElimination(character);
    }

    _currentGame!.switchTurn();

    if (_currentGame!.mode == GameMode.singlePlayer && 
        _currentGame!.currentTurn == PlayerTurn.player2) {
      _handleAITurn();
    }

    notifyListeners();
  }

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

    if (_currentGame!.mode == GameMode.twoPlayer) {
      _bluetoothService.sendGuess(character);
    }

    if (correct) {
      _currentGame!.addScore(currentPlayer);
      _currentGame!.state = GameState.gameOver;
      _saveGameStatistics(playerWon: currentPlayer == PlayerTurn.player1);
    } else {
      final opponent = currentPlayer == PlayerTurn.player1 ? PlayerTurn.player2 : PlayerTurn.player1;
      _currentGame!.addScore(opponent);
      _currentGame!.state = GameState.gameOver;
      _saveGameStatistics(playerWon: currentPlayer != PlayerTurn.player1);
    }

    notifyListeners();
  }

  void eliminateCharactersBasedOnAnswer(Question question, bool answer) {
    if (_currentGame == null) return;

    bool anyElimination = false;
    
    for (int i = 0; i < _currentGame!.gameBoard.length; i++) {
      final character = _currentGame!.gameBoard[i];
      if (character.isEliminated) continue;
      
      final questionResult = question.checkAnswer(character);
      
      if (questionResult != answer) {
        _currentGame!.gameBoard[i] = character.copyWith(isEliminated: true);
        _charactersEliminatedThisGame++;
        anyElimination = true;
        
        final action = GameAction.elimination(
          player: _currentGame!.currentTurn,
          character: character,
        );
        _currentGame!.addGameAction(action);
      }
    }

    if (anyElimination) {
      final remainingCharacters = currentPlayerBoard;
      if (remainingCharacters.length == 1) {
        makeGuess(remainingCharacters.first);
      } else {
        _currentGame!.switchTurn();
        
        if (_currentGame!.mode == GameMode.singlePlayer && 
            _currentGame!.currentTurn == PlayerTurn.player2) {
          _handleAITurn();
        } else if (_currentGame!.mode == GameMode.twoPlayer) {
          // Enviar cambio de turno al oponente
          _bluetoothService.sendTurnChange();
        }
      }
    }

    notifyListeners();
  }

  Future<void> _handleAITurn() async {
    if (_currentGame == null || _currentGame!.mode != GameMode.singlePlayer) return;

    await AIService.instance.simulateThinking();

    final aiAction = AIService.instance.decideAction(_currentGame!);

    if (aiAction.type == AIActionType.askQuestion && aiAction.question != null) {
      final playerCharacter = _currentGame!.player1Character!;
      final answer = aiAction.question!.checkAnswer(playerCharacter);

      final action = GameAction.question(
        player: PlayerTurn.player2,
        question: aiAction.question!,
        answer: answer,
      );
      _currentGame!.addGameAction(action);

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
        final remainingCharacters = _currentGame!.gameBoard
            .where((c) => !c.isEliminated)
            .toList();
            
        if (remainingCharacters.length == 1) {
          _currentGame!.addScore(PlayerTurn.player2);
          _currentGame!.state = GameState.gameOver;
          _saveGameStatistics(playerWon: false);
        } else {
          _currentGame!.switchTurn();
        }
      } else {
        _currentGame!.switchTurn();
      }
      
    } else if (aiAction.type == AIActionType.makeGuess && aiAction.character != null) {
      final playerCharacter = _currentGame!.player1Character!;
      final correct = playerCharacter.id == aiAction.character!.id;

      final action = GameAction.guess(
        player: PlayerTurn.player2,
        character: aiAction.character!,
        correct: correct,
      );
      _currentGame!.addGameAction(action);

      if (correct) {
        _currentGame!.addScore(PlayerTurn.player2);
        _currentGame!.state = GameState.gameOver;
        _saveGameStatistics(playerWon: false);
      } else {
        _currentGame!.switchTurn();
      }
    }

    notifyListeners();
  }

  Future<void> _saveGameStatistics({required bool playerWon}) async {
    if (_currentGame == null || _gameStartTime == null) return;

    try {
      final gameDuration = DateTime.now().difference(_gameStartTime!);
      
      final stats = GameStatistics(
        id: 0, // Will be auto-generated by database
        date: DateTime.now(),
        mode: _currentGame!.mode,
        difficulty: _currentGame!.difficulty,
        playerWon: playerWon,
        playerScore: _currentGame!.player1Score,
        opponentScore: _currentGame!.player2Score,
        questionsAsked: _questionsAskedThisGame,
        charactersEliminated: _charactersEliminatedThisGame,
        gameDuration: gameDuration,
        opponentName: _currentGame!.mode == GameMode.twoPlayer 
            ? _bluetoothService.connectedDevice?.name 
            : 'IA',
      );

      await _databaseService.saveGameStatistics(stats);
      print('✅ Estadísticas guardadas');
    } catch (e) {
      print('❌ Error al guardar estadísticas: $e');
    }
  }

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

  void resetGame() {
    _currentGame = null;
    _error = null;
    _gameStartTime = null;
    _questionsAskedThisGame = 0;
    _charactersEliminatedThisGame = 0;
    _pendingOpponentQuestion = null;
    _showOpponentQuestionDialog = false;
    notifyListeners();
  }

  void endGame() {
    if (_currentGame != null) {
      _currentGame!.state = GameState.gameOver;
      notifyListeners();
    }
  }

  Character? getCharacterById(int id) {
    if (_currentGame == null) return null;
    
    try {
      return _currentGame!.gameBoard.firstWhere((character) => character.id == id);
    } catch (e) {
      return null;
    }
  }
}