import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionCarousel extends StatefulWidget {
  final List<Question> questions;
  final Function(Question) onQuestionAsked;

  const QuestionCarousel({
    super.key,
    required this.questions,
    required this.onQuestionAsked,
  });

  @override
  State<QuestionCarousel> createState() => _QuestionCarouselState();
}

class _QuestionCarouselState extends State<QuestionCarousel> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      debugPrint('📝 QuestionCarousel inicializado con ${widget.questions.length} preguntas');
    }
  }

  @override
  void didUpdateWidget(QuestionCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset index if questions list changed
    if (oldWidget.questions != widget.questions) {
      if (_currentIndex >= widget.questions.length) {
        setState(() {
          _currentIndex = widget.questions.isNotEmpty ? widget.questions.length - 1 : 0;
        });
      }
    }
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
      if (kDebugMode) {
        debugPrint('➡️ Siguiente pregunta: $_currentIndex');
      }
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      if (kDebugMode) {
        debugPrint('⬅️ Pregunta anterior: $_currentIndex');
      }
    }
  }

  bool get _canGoNext => _currentIndex < widget.questions.length - 1;
  bool get _canGoPrevious => _currentIndex > 0;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      debugPrint('🎨 Construyendo QuestionCarousel...');
    }
    
    if (widget.questions.isEmpty) {
      return Container(
        color: Colors.red,
        child: const Center(
          child: Text(
            'NO HAY PREGUNTAS',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      );
    }

    final currentQuestion = widget.questions[_currentIndex];
    if (kDebugMode) {
      debugPrint('📄 Pregunta actual: ${currentQuestion.text}');
    }

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min, // IMPORTANTE: usa el mínimo espacio necesario
        children: [
          // Header compacto
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Preguntas Disponibles',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_currentIndex + 1} de ${widget.questions.length}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Pregunta - Compacta
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Categoría
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(currentQuestion.category),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getCategoryName(currentQuestion.category),
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // PREGUNTA
                Text(
                  currentQuestion.text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // BOTÓN
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        debugPrint('🔘 BOTÓN PRESIONADO: ${currentQuestion.text}');
                      }
                      widget.onQuestionAsked(currentQuestion);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getCategoryColor(currentQuestion.category),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.help_outline, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'HACER PREGUNTA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Navegación compacta
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón anterior
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _canGoPrevious ? Colors.red : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  onPressed: _canGoPrevious ? _previousQuestion : null,
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),

              // Indicadores (limitados para evitar overflow)
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      widget.questions.length,
                      (index) => Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentIndex ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Botón siguiente
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _canGoNext ? Colors.red : Colors.grey,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  onPressed: _canGoNext ? _nextQuestion : null,
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(QuestionCategory category) {
    switch (category) {
      case QuestionCategory.physical:
        return Colors.blue;
      case QuestionCategory.status:
        return Colors.green;
      case QuestionCategory.abilities:
        return Colors.purple;
      case QuestionCategory.relationships:
        return Colors.orange;
    }
  }

  String _getCategoryName(QuestionCategory category) {
    switch (category) {
      case QuestionCategory.physical:
        return 'FÍSICO';
      case QuestionCategory.status:
        return 'ESTADO';
      case QuestionCategory.abilities:
        return 'HABILIDADES';
      case QuestionCategory.relationships:
        return 'RELACIONES';
    }
  }
}