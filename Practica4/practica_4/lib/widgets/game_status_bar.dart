import 'package:flutter/material.dart';
import '../models/game_session.dart';

class GameStatusBar extends StatelessWidget {
  final GameSession gameSession;
  final bool isPlayerTurn;

  const GameStatusBar({
    super.key,
    required this.gameSession,
    required this.isPlayerTurn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Turn indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPlayerTurn ? Icons.person : Icons.smart_toy,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  _getTurnText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Game mode, difficulty and score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Game mode and difficulty
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        gameSession.mode == GameMode.singlePlayer
                            ? 'Un Jugador'
                            : 'Dos Jugadores',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        gameSession.difficultyDisplayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                // Score
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${gameSession.player1Score} - ${gameSession.player2Score}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Character selection status
            if (gameSession.state == GameState.characterSelection)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Selecciona tu personaje secreto',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),

            // Playing status
            if (gameSession.state == GameState.playing)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _getGameStatusText(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // Remaining characters indicator
            if (gameSession.state == GameState.playing)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _buildRemainingCharactersIndicator(context),
              ),
          ],
        ),
      ),
    );
  }

  String _getTurnText() {
    if (gameSession.state == GameState.characterSelection) {
      if (gameSession.mode == GameMode.singlePlayer) {
        return 'Tu Turno';
      } else {
        return gameSession.currentTurn == PlayerTurn.player1
            ? 'Turno del Jugador 1'
            : 'Turno del Jugador 2';
      }
    }

    if (gameSession.mode == GameMode.singlePlayer) {
      return isPlayerTurn ? 'Tu Turno' : 'Turno de la IA';
    } else {
      return gameSession.currentTurn == PlayerTurn.player1
          ? 'Turno del Jugador 1'
          : 'Turno del Jugador 2';
    }
  }

  String _getGameStatusText() {
    if (isPlayerTurn) {
      return 'Haz una pregunta o adivina el personaje';
    } else {
      if (gameSession.mode == GameMode.singlePlayer) {
        return 'La IA está pensando...';
      } else {
        return 'Esperando al otro jugador...';
      }
    }
  }

  Widget _buildRemainingCharactersIndicator(BuildContext context) {
    final remaining = gameSession.gameBoard
        .where((character) => !character.isEliminated)
        .length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.people_outline,
          color: Colors.white70,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          '$remaining personajes restantes',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}