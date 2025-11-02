import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/theme_provider.dart';
import '../models/game_session.dart';
import '../widgets/theme_selector.dart';
import '../widgets/custom_logo.dart';
import '../widgets/themed_card.dart';
import 'difficulty_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: themeProvider.getGradientColors(),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Custom logo widget
                    const CustomLogo(),
                    const SizedBox(height: 40), // Reducido de 64

                    // Game mode buttons - Scrollable si es necesario
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ThemedGameModeCard(
                              title: 'Un Jugador',
                              subtitle: 'Juega contra la IA',
                              icon: Icons.person,
                              onTap: () => _startSinglePlayerGame(context),
                            ),
                            const SizedBox(height: 20), // Reducido de 24
                            
                            ThemedGameModeCard(
                              title: 'Dos Jugadores',
                              subtitle: 'Conexión por Bluetooth',
                              icon: Icons.bluetooth,
                              onTap: () => _navigateToBluetoothSetup(context),
                            ),
                            const SizedBox(height: 40), // Reducido de 64

                            // Score display - Solo mostrar si hay juego activo
                            Consumer<GameProvider>(
                              builder: (context, gameProvider, child) {
                                if (gameProvider.hasGame) {
                                  return _buildScoreCard(
                                    gameProvider.player1Score,
                                    gameProvider.player2Score,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom row with instructions and theme selector
                    // Espacio mínimo fijo en la parte inferior
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Instructions button
                          OutlinedButton.icon(
                            onPressed: () => _showInstructions(context),
                            icon: Icon(
                              Icons.help_outline, 
                              color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                            ),
                            label: Text(
                              'Cómo Jugar',
                              style: TextStyle(
                                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20, // Reducido
                                vertical: 10,   // Reducido
                              ),
                            ),
                          ),
                          
                          // Theme selector button
                          const ThemeSelector(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreCard(int player1Score, int player2Score) {
    return ThemedCard(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem('Jugador 1', player1Score),
          const VerticalDivider(),
          _buildScoreItem('Jugador 2', player2Score),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, int score) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _startSinglePlayerGame(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DifficultySelectionScreen(
          gameMode: GameMode.singlePlayer,
        ),
      ),
    );
  }

  void _navigateToBluetoothSetup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DifficultySelectionScreen(
          gameMode: GameMode.twoPlayer,
        ),
      ),
    );
  }

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cómo Jugar'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '1. Selección de Personaje:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Al inicio, selecciona tu personaje secreto tocándolo en el tablero.'),
              SizedBox(height: 12),
              Text(
                '2. Hacer Preguntas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Usa el carrusel de preguntas en la parte inferior.'),
              Text('• Basándote en la respuesta, elimina personajes manualmente.'),
              SizedBox(height: 12),
              Text(
                '3. Eliminar Personajes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Toca un personaje para eliminarlo de tu tablero.'),
              Text('• Solo elimina si estás seguro que NO es el personaje del oponente.'),
              SizedBox(height: 12),
              Text(
                '4. Ganar:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Adivina correctamente el personaje del oponente para ganar.'),
              Text('• El primero en adivinar correctamente gana la ronda.'),
            ],
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