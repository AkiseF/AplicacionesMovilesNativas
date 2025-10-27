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
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      age: json['age'] as int,
      status: json['status'] as String,
      height: json['height'] as String,
      weight: json['weight'] as String,
      hairColor: json['hairColor'] as String,
      eyeColor: json['eyeColor'] as String,
      birthplace: json['birthplace'] as String,
      skills: List<String>.from(json['skills'] as List),
      titanForm: json['titanForm'] as String?,
      notableBattles: List<String>.from(json['notableBattles'] as List),
      loveInterests: json['loveInterests'] as String?,
      fears: json['fears'] as String,
      hobbies: json['hobbies'] as String,
      dislikes: json['dislikes'] as String,
      education: json['education'] as String,
      notableQuotes: List<String>.from(json['notableQuotes'] as List),
      appearance: json['appearance'] as String,
      allies: List<String>.from(json['allies'] as List),
      enemies: List<String>.from(json['enemies'] as List),
      characterArc: json['characterArc'] as String,
      titanKillCount: json['titanKillCount'] as int,
      humanKillCount: json['humanKillCount'] as int,
      affiliations: List<String>.from(json['affiliations'] as List),
      trivia: List<String>.from(json['trivia'] as List),
      injuriesAndScars: List<String>.from(json['injuriesAndScars'] as List),
      voiceActors: Map<String, String>.from(json['voiceActors'] as Map),
      imageUrl: generateImageUrl(json['name'] as String),
    );
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

  // Generate a placeholder image URL based on character name
  static String generateImageUrl(String characterName) {
    // Using a placeholder service with the character name
    final encodedName = Uri.encodeComponent(characterName);
    return 'https://via.placeholder.com/200x250/333333/FFFFFF?text=$encodedName';
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