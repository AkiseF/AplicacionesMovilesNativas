import 'character.dart';

class Question {
  final int id;
  final String text;
  final QuestionCategory category;
  final bool Function(Character character) checkAnswer;

  Question({
    required this.id,
    required this.text,
    required this.category,
    required this.checkAnswer,
  });
}

enum QuestionCategory {
  physical,
  status,
  abilities,
  relationships,
}

class QuestionSet {
  static List<Question> getDefaultQuestions() {
    return [
      Question(
        id: 1,
        text: "¿Tiene el cabello rubio?",
        category: QuestionCategory.physical,
        checkAnswer: (character) => character.hairColor.toLowerCase().contains('blond'),
      ),
      Question(
        id: 2,
        text: "¿Está vivo/a?",
        category: QuestionCategory.status,
        checkAnswer: (character) => character.status.toLowerCase() == 'alive',
      ),
      Question(
        id: 3,
        text: "¿Puede transformarse en titán?",
        category: QuestionCategory.abilities,
        checkAnswer: (character) => character.titanForm != null,
      ),
      Question(
        id: 4,
        text: "¿Tiene más de 20 años?",
        category: QuestionCategory.physical,
        checkAnswer: (character) => character.age > 20,
      ),
      Question(
        id: 5,
        text: "¿Pertenece al Cuerpo de Exploración?",
        category: QuestionCategory.relationships,
        checkAnswer: (character) => character.affiliations.any(
          (affiliation) => affiliation.toLowerCase().contains('survey corps'),
        ),
      ),
      Question(
        id: 6,
        text: "¿Tiene ojos azules?",
        category: QuestionCategory.physical,
        checkAnswer: (character) => character.eyeColor.toLowerCase().contains('blue'),
      ),
      Question(
        id: 7,
        text: "¿Es de Marley?",
        category: QuestionCategory.relationships,
        checkAnswer: (character) => character.birthplace.toLowerCase().contains('marley'),
      ),
      Question(
        id: 8,
        text: "¿Mide menos de 170 cm?",
        category: QuestionCategory.physical,
        checkAnswer: (character) {
          final heightStr = character.height.replaceAll(RegExp(r'[^0-9.]'), '');
          final height = double.tryParse(heightStr);
          return height != null && height < 170;
        },
      ),
    ];
  }
}