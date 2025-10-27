import 'dart:math';
import '../models/character.dart';
import '../models/question.dart';
import '../models/game_session.dart';
import 'character_service.dart';

class AIService {
  static AIService? _instance;
  static AIService get instance => _instance ??= AIService._();
  AIService._();

  final Random _random = Random();

  /// AI selects a character at the start of the game
  Character selectCharacter(List<Character> availableCharacters) {
    return CharacterService.instance.getRandomCharacter(availableCharacters);
  }

  /// AI asks a question based on game state
  Question selectQuestion(GameSession gameSession) {
    final availableQuestions = gameSession.availableQuestions;
    final nonEliminatedCharacters = gameSession.gameBoard
        .where((character) => !character.isEliminated)
        .toList();

    if (nonEliminatedCharacters.length <= 2) {
      // If only 1-2 characters left, make a guess instead of asking questions
      // This will be handled in the game logic
      return availableQuestions.first; // Fallback
    }

    // Find the question that would eliminate roughly half of the remaining characters
    Question? bestQuestion;
    double bestRatio = double.infinity;

    for (final question in availableQuestions) {
      int matchCount = 0;
      for (final character in nonEliminatedCharacters) {
        if (question.checkAnswer(character)) {
          matchCount++;
        }
      }

      final ratio = (matchCount / nonEliminatedCharacters.length - 0.5).abs();
      if (ratio < bestRatio) {
        bestRatio = ratio;
        bestQuestion = question;
      }
    }

    return bestQuestion ?? availableQuestions[_random.nextInt(availableQuestions.length)];
  }

  /// AI responds to a player's question
  bool answerQuestion(Question question, Character aiCharacter) {
    return question.checkAnswer(aiCharacter);
  }

  /// AI eliminates characters based on the answer to a question
  List<Character> eliminateCharacters(
    List<Character> characters,
    Question question,
    bool answer,
  ) {
    return characters.map((character) {
      final questionResult = question.checkAnswer(character);
      
      // If the answer doesn't match the question result, eliminate the character
      if (questionResult != answer) {
        return character.copyWith(isEliminated: true);
      }
      
      return character;
    }).toList();
  }

  /// AI makes a final guess about the player's character
  Character? makeGuess(List<Character> remainingCharacters) {
    final nonEliminated = remainingCharacters
        .where((character) => !character.isEliminated)
        .toList();

    if (nonEliminated.isEmpty) return null;
    
    // If only one character left, guess it
    if (nonEliminated.length == 1) {
      return nonEliminated.first;
    }

    // If multiple characters left, pick randomly (could be improved with more strategy)
    return nonEliminated[_random.nextInt(nonEliminated.length)];
  }

  /// AI decides whether to ask a question or make a guess
  AIAction decideAction(GameSession gameSession) {
    final nonEliminatedCharacters = gameSession.gameBoard
        .where((character) => !character.isEliminated)
        .toList();

    // If 3 or fewer characters remain, consider making a guess
    if (nonEliminatedCharacters.length <= 3) {
      // 70% chance to make a guess if 2 or fewer characters remain
      if (nonEliminatedCharacters.length <= 2 && _random.nextDouble() < 0.7) {
        final guess = makeGuess(gameSession.gameBoard);
        if (guess != null) {
          return AIAction.guess(guess);
        }
      }
    }

    // Otherwise, ask a question
    final question = selectQuestion(gameSession);
    return AIAction.question(question);
  }

  /// Simulate AI thinking delay for better UX
  Future<void> simulateThinking() async {
    final thinkingTime = 1000 + _random.nextInt(2000); // 1-3 seconds
    await Future.delayed(Duration(milliseconds: thinkingTime));
  }
}

class AIAction {
  final AIActionType type;
  final Question? question;
  final Character? character;

  AIAction._({
    required this.type,
    this.question,
    this.character,
  });

  factory AIAction.question(Question question) {
    return AIAction._(
      type: AIActionType.askQuestion,
      question: question,
    );
  }

  factory AIAction.guess(Character character) {
    return AIAction._(
      type: AIActionType.makeGuess,
      character: character,
    );
  }
}

enum AIActionType {
  askQuestion,
  makeGuess,
}