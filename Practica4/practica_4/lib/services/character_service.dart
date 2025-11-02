import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../models/character.dart';
import '../models/game_session.dart';

class CharacterService {
  static CharacterService? _instance;
  static CharacterService get instance => _instance ??= CharacterService._();
  CharacterService._();

  List<Character>? _allCharacters;

  Future<List<Character>> loadCharacters() async {
    if (_allCharacters != null) {
      return _allCharacters!;
    }

    try {
      final String jsonString = await rootBundle.loadString('assets/data/attackontitan.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> charactersJson = data['body'] as List<dynamic>;

      _allCharacters = charactersJson
          .map((json) => Character.fromJson(json as Map<String, dynamic>))
          .toList();

      return _allCharacters!;
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }

  /// Get a random selection of characters for the game board based on count
  Future<List<Character>> getRandomGameBoard({int count = 16}) async {
    final allCharacters = await loadCharacters();
    
    if (allCharacters.length < count) {
      throw Exception('Not enough characters available for game board. Need $count, have ${allCharacters.length}');
    }

    // Create a copy of the list and shuffle it
    final shuffled = List<Character>.from(allCharacters);
    shuffled.shuffle(Random());

    // Take the requested number of characters
    return shuffled.take(count).toList();
  }

  /// Get characters for a specific difficulty level
  Future<List<Character>> getGameBoardForDifficulty(DifficultyLevel difficulty) async {
    int count;
    switch (difficulty) {
      case DifficultyLevel.easy:
        count = 4;
        break;
      case DifficultyLevel.medium:
        count = 9;
        break;
      case DifficultyLevel.hard:
        count = 16;
        break;
      case DifficultyLevel.expert:
        count = 32;
        break;
    }
    
    return getRandomGameBoard(count: count);
  }

  /// Get character by ID
  Future<Character?> getCharacterById(int id) async {
    final allCharacters = await loadCharacters();
    try {
      return allCharacters.firstWhere((character) => character.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get characters matching certain criteria
  Future<List<Character>> getCharactersWhere(bool Function(Character) test) async {
    final allCharacters = await loadCharacters();
    return allCharacters.where(test).toList();
  }

  /// Get random character from a list
  Character getRandomCharacter(List<Character> characters) {
    if (characters.isEmpty) {
      throw Exception('No characters available');
    }
    final random = Random();
    return characters[random.nextInt(characters.length)];
  }

  /// Reset all characters to their default state (not eliminated, not selected)
  List<Character> resetCharacters(List<Character> characters) {
    return characters
        .map((character) => character.copyWith(
              isEliminated: false,
              isSelected: false,
            ))
        .toList();
  }

  /// Get character statistics for AI decision making
  Map<String, dynamic> getCharacterStats(List<Character> characters) {
    final stats = <String, dynamic>{};
    
    // Hair color distribution
    final hairColors = <String, int>{};
    for (final character in characters) {
      final color = character.hairColor.toLowerCase();
      hairColors[color] = (hairColors[color] ?? 0) + 1;
    }
    stats['hairColors'] = hairColors;

    // Age distribution
    final ageRanges = <String, int>{
      'young': 0, // < 20
      'adult': 0, // 20-30
      'mature': 0, // > 30
    };
    for (final character in characters) {
      if (character.age < 20) {
        ageRanges['young'] = ageRanges['young']! + 1;
      } else if (character.age <= 30) {
        ageRanges['adult'] = ageRanges['adult']! + 1;
      } else {
        ageRanges['mature'] = ageRanges['mature']! + 1;
      }
    }
    stats['ageRanges'] = ageRanges;

    // Status distribution
    final statusCount = <String, int>{};
    for (final character in characters) {
      final status = character.status.toLowerCase();
      statusCount[status] = (statusCount[status] ?? 0) + 1;
    }
    stats['status'] = statusCount;

    // Titan form distribution
    final titanFormCount = characters.where((c) => c.titanForm != null).length;
    stats['hasTitanForm'] = titanFormCount;
    stats['noTitanForm'] = characters.length - titanFormCount;

    return stats;
  }

  
}