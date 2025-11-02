class Character {
  final int id;
  final String name;
  final int age;
  final String status;
  final String height;
  final String weight;
  final String hairColor;
  final String eyeColor;
  final String birthplace;
  final List<String> skills;
  final String? titanForm;
  final List<String> notableBattles;
  final String? loveInterests;
  final String fears;
  final String hobbies;
  final String dislikes;
  final String education;
  final List<String> notableQuotes;
  final String appearance;
  final List<String> allies;
  final List<String> enemies;
  final String characterArc;
  final int titanKillCount;
  final int humanKillCount;
  final List<String> affiliations;
  final List<String> trivia;
  final List<String> injuriesAndScars;
  final Map<String, String> voiceActors;

  // Game-specific properties
  bool isEliminated;
  bool isSelected;
  String? imageUrl;

  Character({
    required this.id,
    required this.name,
    required this.age,
    required this.status,
    required this.height,
    required this.weight,
    required this.hairColor,
    required this.eyeColor,
    required this.birthplace,
    required this.skills,
    this.titanForm,
    required this.notableBattles,
    this.loveInterests,
    required this.fears,
    required this.hobbies,
    required this.dislikes,
    required this.education,
    required this.notableQuotes,
    required this.appearance,
    required this.allies,
    required this.enemies,
    required this.characterArc,
    required this.titanKillCount,
    required this.humanKillCount,
    required this.affiliations,
    required this.trivia,
    required this.injuriesAndScars,
    required this.voiceActors,
    this.isEliminated = false,
    this.isSelected = false,
    this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    try {
      return Character(
        id: json['id'] as int,
        name: json['name'] as String,
        age: json['age'] as int? ?? 0,
        status: json['status'] as String? ?? 'Unknown',
        height: json['height'] as String? ?? 'Unknown',
        weight: json['weight'] as String? ?? 'Unknown',
        hairColor: json['hairColor'] as String? ?? 'Unknown',
        eyeColor: json['eyeColor'] as String? ?? 'Unknown',
        birthplace: json['birthplace'] as String? ?? 'Unknown',
        skills: _parseList(json['skills']),
        titanForm: _parseStringOrNull(json['titanForm']),
        notableBattles: _parseList(json['notableBattles']),
        loveInterests: _parseStringOrNull(json['loveInterests']),
        fears: json['fears'] as String? ?? 'Unknown',
        hobbies: json['hobbies'] as String? ?? 'Unknown',
        dislikes: json['dislikes'] as String? ?? 'Unknown',
        education: json['education'] as String? ?? 'Unknown',
        notableQuotes: _parseList(json['notableQuotes']),
        appearance: json['appearance'] as String? ?? 'Unknown',
        allies: _parseList(json['allies']),
        enemies: _parseList(json['enemies']),
        characterArc: json['characterArc'] as String? ?? 'Unknown',
        titanKillCount: json['titanKillCount'] as int? ?? 0,
        humanKillCount: json['humanKillCount'] as int? ?? 0,
        affiliations: _parseList(json['affiliations']),
        trivia: _parseList(json['trivia']),
        injuriesAndScars: _parseList(json['injuriesAndScars']),
        voiceActors: _parseMap(json['voiceActors']),
        imageUrl: generateImageUrl(json['name'] as String),
      );
    } catch (e, stackTrace) {
      print('❌ Error parseando personaje: $e');
      print('📋 Nombre: ${json['name'] ?? 'Unknown'}');
      print('🔍 Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Método helper para parsear String o null (maneja String, List, o null)
  static String? _parseStringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is List && value.isNotEmpty) {
      return value.join(', ');
    }
    return null;
  }

  // Método helper para parsear listas de forma segura
  static List<String> _parseList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }
    if (value is String && value.isNotEmpty) return [value];
    return [];
  }

  // Método helper para parsear maps de forma segura
  static Map<String, String> _parseMap(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      return value.map((key, val) => 
        MapEntry(key?.toString() ?? '', val?.toString() ?? '')
      );
    }
    return {};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'status': status,
      'height': height,
      'weight': weight,
      'hairColor': hairColor,
      'eyeColor': eyeColor,
      'birthplace': birthplace,
      'skills': skills,
      'titanForm': titanForm,
      'notableBattles': notableBattles,
      'loveInterests': loveInterests,
      'fears': fears,
      'hobbies': hobbies,
      'dislikes': dislikes,
      'education': education,
      'notableQuotes': notableQuotes,
      'appearance': appearance,
      'allies': allies,
      'enemies': enemies,
      'characterArc': characterArc,
      'titanKillCount': titanKillCount,
      'humanKillCount': humanKillCount,
      'affiliations': affiliations,
      'trivia': trivia,
      'injuriesAndScars': injuriesAndScars,
      'voiceActors': voiceActors,
      'isEliminated': isEliminated,
      'isSelected': isSelected,
      'imageUrl': imageUrl,
    };
  }

  Character copyWith({
    bool? isEliminated,
    bool? isSelected,
    String? imageUrl,
  }) {
    return Character(
      id: id,
      name: name,
      age: age,
      status: status,
      height: height,
      weight: weight,
      hairColor: hairColor,
      eyeColor: eyeColor,
      birthplace: birthplace,
      skills: skills,
      titanForm: titanForm,
      notableBattles: notableBattles,
      loveInterests: loveInterests,
      fears: fears,
      hobbies: hobbies,
      dislikes: dislikes,
      education: education,
      notableQuotes: notableQuotes,
      appearance: appearance,
      allies: allies,
      enemies: enemies,
      characterArc: characterArc,
      titanKillCount: titanKillCount,
      humanKillCount: humanKillCount,
      affiliations: affiliations,
      trivia: trivia,
      injuriesAndScars: injuriesAndScars,
      voiceActors: voiceActors,
      isEliminated: isEliminated ?? this.isEliminated,
      isSelected: isSelected ?? this.isSelected,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Generate local image URL based on character name
  static String generateImageUrl(String characterName) {
    // Remove accents and special characters, replace spaces
    final formattedName = characterName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '')
        .replaceAll(' ', '');
    
    return 'assets/data/images/${formattedName}4k.jpg';
  }

  @override
  String toString() => 'Character(id: $id, name: $name)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Character && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}