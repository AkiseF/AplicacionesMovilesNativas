import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_session.dart';
import '../models/character.dart';
import '../models/question.dart';
import '../widgets/character_card.dart';
import '../widgets/question_carousel.dart';
import '../widgets/game_status_bar.dart';
import '../services/ai_service.dart'; 

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Quién Es?'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showGameMenu(context),
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!gameProvider.hasGame) {
            // Si no hay juego, regresar al menú principal
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No se pudo cargar el juego'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            });
            return const Center(child: CircularProgressIndicator());
          }

          final game = gameProvider.currentGame!;

          // Mostrar pantalla de selección de personajes si está en ese estado
          if (game.state == GameState.characterSelection) {
            return _buildCharacterSelectionScreen(context, game);
          }

          return Column(
            children: [
              // Game status bar
              GameStatusBar(
                gameSession: game,
                isPlayerTurn: game.isCurrentPlayerTurn,
              ),

              // Game board - siempre visible
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildGameBoard(
                    context, 
                    gameProvider.currentVisibleCharacters,
                    canInteract: game.state == GameState.playing && 
                                game.isCurrentPlayerTurn,
                  ),
                ),
              ),

              // Action area - depende del estado del juego
              if (game.state == GameState.playing)
                _buildActionArea(context, gameProvider),

              // Game over overlay
              if (game.state == GameState.gameOver)
                _buildGameOverOverlay(context, game),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionArea(BuildContext context, GameProvider gameProvider) {
    final game = gameProvider.currentGame!;
    
    if (game.isCurrentPlayerTurn) {
      // Player's turn - show question carousel and guess button
      return Expanded(
        flex: 2,
        child: Column(
          children: [
            // Question carousel
            Expanded(
              child: QuestionCarousel(
                questions: game.availableQuestions,
                onQuestionAsked: (question) {
                  _askQuestion(context, question);
                },
              ),
            ),
            
            // Guess button (only if more than 1 character remains)
            if (gameProvider.currentPlayerBoard.length > 1)
              Container(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton.icon(
                  onPressed: () => _showGuessDialog(context),
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('Adivinar Personaje'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      // AI's turn - show thinking indicator
      return Expanded(
        flex: 1,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                game.mode == GameMode.singlePlayer 
                  ? 'La IA está pensando...'
                  : 'Turno del oponente...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }
  }

  // Método para hacer preguntas
  void _askQuestion(BuildContext context, Question question) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final game = gameProvider.currentGame!;
    
    if (game.mode == GameMode.singlePlayer) {
      // Against AI - get answer immediately
      final aiCharacter = game.player2Character!;
      final answer = AIService.instance.answerQuestion(question, aiCharacter);
      
      // Show answer to player
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Respuesta'),
          content: Text('La respuesta es: ${answer ? "SÍ" : "NO"}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Player eliminates characters based on answer
                gameProvider.eliminateCharactersBasedOnAnswer(question, answer);
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      );
    }
  }

  // Método para mostrar diálogo de adivinanza
  void _showGuessDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final remainingCharacters = gameProvider.currentPlayerBoard;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adivinar Personaje'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: remainingCharacters.length,
            itemBuilder: (context, index) {
              final character = remainingCharacters[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: character.imageUrl != null 
                      ? DecorationImage(
                          image: AssetImage(character.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                    color: Colors.grey[300],
                  ),
                  child: character.imageUrl == null
                    ? Icon(Icons.person, color: Colors.grey[600])
                    : null,
                ),
                title: Text(character.name),
                onTap: () {
                  Navigator.of(context).pop();
                  gameProvider.makeGuess(character);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterSelectionScreen(BuildContext context, GameSession game) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Column(
            children: [
              Text(
                game.mode == GameMode.singlePlayer 
                  ? 'Selecciona tu personaje secreto'
                  : 'Jugador ${game.currentTurn == PlayerTurn.player1 ? "1" : "2"}, selecciona tu personaje',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Este será el personaje que tu oponente debe adivinar',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Dificultad: ${game.difficultyDisplayName} (${game.gameBoard.length} personajes)',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildGameBoard(
              context, 
              game.gameBoard,
              isSelectionMode: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameBoard(
    BuildContext context, 
    List<Character> characters, {
    bool isSelectionMode = false, 
    bool canInteract = true,
  }) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final dimensions = gameProvider.gridDimensions;
    final hasMultipleGrids = gameProvider.hasMultipleGrids;
    final currentGridIndex = gameProvider.currentGridIndex;
    
    if (dimensions == null) {
      return const Center(
        child: Text('Error: No se pudieron cargar las dimensiones del grid')
      );
    }

    Widget gridWidget = GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: dimensions.columns,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.8,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return CharacterCard(
          character: character,
          onTap: canInteract ? () {
            if (isSelectionMode) {
              _selectCharacter(context, character);
            } else {
              _handleCharacterTap(context, character);
            }
          } : null,
          isSelectionMode: isSelectionMode,
        );
      },
    );

    // For expert mode, wrap in PageView for carousel navigation
    if (hasMultipleGrids && !isSelectionMode) {
      return Column(
        children: [
          // Grid indicator and navigation
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grid ${currentGridIndex + 1} de 2',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: currentGridIndex > 0 
                        ? () => gameProvider.switchGrid()
                        : null,
                      icon: const Icon(Icons.chevron_left),
                      tooltip: 'Grid anterior',
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < 2; i++)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: i == currentGridIndex 
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: currentGridIndex < 1 
                        ? () => gameProvider.switchGrid()
                        : null,
                      icon: const Icon(Icons.chevron_right),
                      tooltip: 'Grid siguiente',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // The actual grid
          Expanded(child: gridWidget),
        ],
      );
    }

    return gridWidget;
  }

  Widget _buildGameOverOverlay(BuildContext context, GameSession game) {
    // Determine winner
    String winnerText;
    if (game.mode == GameMode.singlePlayer) {
      // Check last action to see who won
      final lastAction = game.gameHistory.isNotEmpty ? game.gameHistory.last : null;
      if (lastAction != null && lastAction.type == 'guess' && lastAction.data['correct'] == true) {
        winnerText = lastAction.player == PlayerTurn.player1 ? '¡Ganaste!' : '¡La IA Ganó!';
      } else {
        winnerText = 'Juego Terminado';
      }
    } else {
      winnerText = 'Jugador ${game.currentTurn == PlayerTurn.player1 ? "1" : "2"} Ganó!';
    }

    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  winnerText,
                  style: Theme.of(context).textTheme.headlineSmall, // Más pequeño
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Puntuación: ${game.player1Score} - ${game.player2Score}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                // Botones en columna
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => _playAgain(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Jugar Otra Vez', style: TextStyle(fontSize: 14)),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Menú Principal', style: TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectCharacter(BuildContext context, Character character) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.selectCharacter(character);

    // Show selection confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Has seleccionado a ${character.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleCharacterTap(BuildContext context, Character character) {
    final game = Provider.of<GameProvider>(context, listen: false).currentGame!;
    
    if (game.state != GameState.playing) return;

    // Show options: eliminate or guess
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              character.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (!character.isEliminated) ...[
              ListTile(
                leading: const Icon(Icons.close, color: Colors.red),
                title: const Text('Eliminar Personaje'),
                subtitle: const Text('Este personaje NO es el del oponente'),
                onTap: () {
                  Navigator.of(context).pop();
                  _eliminateCharacter(context, character);
                },
              ),
              const Divider(),
            ],
            ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.amber),
              title: const Text('¡Este es mi respuesta final!'),
              subtitle: const Text('Adivinar que este ES el personaje del oponente'),
              onTap: () {
                Navigator.of(context).pop();
                _makeGuess(context, character);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _eliminateCharacter(BuildContext context, Character character) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.eliminateCharacter(character);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${character.name} eliminado'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _makeGuess(BuildContext context, Character character) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Estás seguro?'),
        content: Text('¿Crees que ${character.name} es el personaje secreto de tu oponente?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              final gameProvider = Provider.of<GameProvider>(context, listen: false);
              gameProvider.makeGuess(character);
            },
            child: const Text('¡Sí, es mi respuesta final!'),
          ),
        ],
      ),
    );
  }

  void _playAgain(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final currentMode = gameProvider.currentGame?.mode ?? GameMode.singlePlayer;
    final currentDifficulty = gameProvider.currentGame?.difficulty ?? DifficultyLevel.hard;
    
    // Mantener los scores acumulados
    gameProvider.startNewGame(currentMode, difficulty: currentDifficulty, keepScore: true);
  }

  void _showGameMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Nuevo Juego'),
              onTap: () {
                Navigator.of(context).pop();
                _playAgain(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Menú Principal'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Instrucciones'),
              onTap: () {
                Navigator.of(context).pop();
                _showInstructions(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Instrucciones del Juego'),
        content: const SingleChildScrollView(
          child: Text(
            '• Haz preguntas para conocer características del personaje oponente\n\n'
            '• Elimina personajes manualmente basándote en las respuestas\n\n'
            '• Cuando estés seguro, haz tu adivinanza final\n\n'
            '• ¡El primero en adivinar correctamente gana!',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}