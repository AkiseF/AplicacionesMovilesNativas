import 'package:flutter/material.dart';
import '../models/game_session.dart';

class DifficultySelector extends StatelessWidget {
  final DifficultyLevel selectedDifficulty;
  final Function(DifficultyLevel) onDifficultyChanged;
  final bool isCompact;

  const DifficultySelector({
    super.key,
    required this.selectedDifficulty,
    required this.onDifficultyChanged,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactSelector(context);
    } else {
      return _buildFullSelector(context);
    }
  }

  Widget _buildCompactSelector(BuildContext context) {
    return DropdownButton<DifficultyLevel>(
      value: selectedDifficulty,
      onChanged: (DifficultyLevel? newValue) {
        if (newValue != null) {
          onDifficultyChanged(newValue);
        }
      },
      items: DifficultyLevel.values.map<DropdownMenuItem<DifficultyLevel>>((DifficultyLevel difficulty) {
        return DropdownMenuItem<DifficultyLevel>(
          value: difficulty,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getDifficultyIcon(difficulty),
                size: 16,
                color: _getDifficultyColor(difficulty),
              ),
              const SizedBox(width: 8),
              Text(_getDifficultyDisplayName(difficulty)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFullSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dificultad',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DifficultyLevel.values.map((difficulty) {
            final isSelected = selectedDifficulty == difficulty;
            return GestureDetector(
              onTap: () => onDifficultyChanged(difficulty),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? _getDifficultyColor(difficulty)
                    : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getDifficultyColor(difficulty),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getDifficultyIcon(difficulty),
                      size: 16,
                      color: isSelected ? Colors.white : _getDifficultyColor(difficulty),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getDifficultyDisplayName(difficulty),
                      style: TextStyle(
                        color: isSelected ? Colors.white : _getDifficultyColor(difficulty),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          _getDifficultyDescription(selectedDifficulty),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getDifficultyDisplayName(DifficultyLevel difficulty) {
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

  String _getDifficultyDescription(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Perfecto para principiantes';
      case DifficultyLevel.medium:
        return 'Un poco más de desafío';
      case DifficultyLevel.hard:
        return 'Para jugadores experimentados';
      case DifficultyLevel.expert:
        return '¡El máximo desafío!';
    }
  }

  IconData _getDifficultyIcon(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return Icons.sentiment_very_satisfied;
      case DifficultyLevel.medium:
        return Icons.sentiment_satisfied;
      case DifficultyLevel.hard:
        return Icons.sentiment_neutral;
      case DifficultyLevel.expert:
        return Icons.sentiment_very_dissatisfied;
    }
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return Colors.green;
      case DifficultyLevel.medium:
        return Colors.orange;
      case DifficultyLevel.hard:
        return Colors.red;
      case DifficultyLevel.expert:
        return Colors.purple;
    }
  }
}