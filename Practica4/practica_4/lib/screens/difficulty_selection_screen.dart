import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/theme_provider.dart';
import '../models/game_session.dart';
import '../widgets/themed_card.dart';
import 'game_screen.dart';

class DifficultySelectionScreen extends StatelessWidget {
  final GameMode gameMode;

  const DifficultySelectionScreen({
    super.key,
    required this.gameMode,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(gameMode == GameMode.singlePlayer 
              ? 'Seleccionar Dificultad' 
              : 'Seleccionar Dificultad'),
            centerTitle: true,
          ),
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
                padding: const EdgeInsets.all(20.0), // Reducido de 24.0
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header informativo
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      child: Column(
                        children: [
                          Text(
                            'Elige la Dificultad',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Selecciona el nivel de desafío',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    // Difficulty options con scroll
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            _buildDifficultyCard(
                              context,
                              difficulty: DifficultyLevel.easy,
                              title: 'Fácil',
                              subtitle: 'Perfecto para principiantes',
                              description: 'Con 4 personajes a adivinar',
                              icon: Icons.sentiment_very_satisfied,
                              color: Colors.green,
                            ),
                            
                            const SizedBox(height: 12), // Reducido
                            
                            _buildDifficultyCard(
                              context,
                              difficulty: DifficultyLevel.medium,
                              title: 'Medio',
                              subtitle: 'Un poco más de desafío',
                              description: 'Con 9 personajes a adivinar',
                              icon: Icons.sentiment_satisfied,
                              color: Colors.orange,
                            ),
                            
                            const SizedBox(height: 12), // Reducido
                            
                            _buildDifficultyCard(
                              context,
                              difficulty: DifficultyLevel.hard,
                              title: 'Difícil',
                              subtitle: 'Para jugadores experimentados',
                              description: 'Con 16 personajes a adivinar',
                              icon: Icons.sentiment_neutral,
                              color: Colors.red,
                            ),
                            
                            const SizedBox(height: 12), // Reducido
                            
                            _buildDifficultyCard(
                              context,
                              difficulty: DifficultyLevel.expert,
                              title: 'Experto',
                              subtitle: '¡El máximo desafío!',
                              description: 'Con 32 personajes a adivinar',
                              icon: Icons.sentiment_very_dissatisfied,
                              color: Colors.purple,
                              isExpert: true,
                            ),
                            
                            const SizedBox(height: 16), // Espacio extra al final del scroll
                          ],
                        ),
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

  Widget _buildDifficultyCard(
    BuildContext context, {
    required DifficultyLevel difficulty,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color color,
    bool isExpert = false,
  }) {
    return ThemedCard(
      onTap: () => _startGameWithDifficulty(context, difficulty),
      padding: const EdgeInsets.all(16.0), // Reducido de 20.0
      margin: const EdgeInsets.symmetric(vertical: 4), // Margen más compacto
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10), // Reducido de 12
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 28, // Reducido de 32
                  color: color,
                ),
              ),
              const SizedBox(width: 12), // Reducido de 16
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith( // HeadlineSmall → TitleLarge
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2), // Reducido de 4
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12, // Texto más pequeño
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16, // Reducido
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 8), // Reducido de 12
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10), // Reducido de 12
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  isExpert ? Icons.view_carousel : Icons.grid_view,
                  size: 18, // Reducido de 20
                  color: color,
                ),
                const SizedBox(width: 6), // Reducido de 8
                Expanded(
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12, // Texto más pequeño
                    ),
                  ),
                ),
              ],
            ),
          ),          
        ],
      ),
    );
  }

 void _startGameWithDifficulty(BuildContext context, DifficultyLevel difficulty) async {
  final gameProvider = Provider.of<GameProvider>(context, listen: false);
  
  // Show loading indicator
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(color: Colors.white),
    ),
  );

  try {
    await gameProvider.startNewGame(gameMode, difficulty: difficulty);
    
    // Esperar un frame para asegurar que el estado se actualizó
    await Future.delayed(Duration.zero);
    
    if (context.mounted) {
      Navigator.of(context).pop(); // Remove loading indicator
      
      // Verificar que el juego se creó correctamente antes de navegar
      if (gameProvider.hasGame) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const GameScreen(),
          ),
        );
      } else {
        // Si por alguna razón no se creó el juego, mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se pudo crear el juego'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop(); // Remove loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar el juego: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
}