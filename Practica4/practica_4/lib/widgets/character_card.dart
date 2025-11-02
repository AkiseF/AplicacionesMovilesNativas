import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback? onTap;
  final bool isSelectionMode;

  const CharacterCard({
    super.key,
    required this.character,
    this.onTap,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: character.isEliminated ? 1 : 4,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Character image - usando Image.asset para imágenes locales
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      color: Colors.grey[300],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: character.imageUrl != null
                          ? Image.asset(
                              character.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback si la imagen no se carga
                                return _buildImageFallback(character);
                              },
                            )
                          : _buildImageFallback(character),
                    ),
                  ),
                ),

                // Character name
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelectionMode 
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : Colors.black.withOpacity(0.6), // Fondo oscuro
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        character.name,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: character.isEliminated 
                              ? Colors.grey 
                              : Colors.white, // Blanco
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 3,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Elimination overlay
            if (character.isEliminated)
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.close,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),

            // Selection mode border
            if (isSelectionMode)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

            // Selected indicator
            if (character.isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),

            // Tap indicator for selection mode
            if (isSelectionMode)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.touch_app,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget de fallback para cuando no hay imagen
  Widget _buildImageFallback(Character character) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 32,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 4),
          Text(
            character.name.split(' ').first,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}