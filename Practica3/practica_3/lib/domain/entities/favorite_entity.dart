/// Entidad para archivos favoritos
class FavoriteEntity {
  final int? id;
  final String filePath;
  final String fileName;
  final DateTime dateAdded;
  final bool isDirectory;

  const FavoriteEntity({
    this.id,
    required this.filePath,
    required this.fileName,
    required this.dateAdded,
    required this.isDirectory,
  });

  /// Convertir a mapa para base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'fileName': fileName,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
      'isDirectory': isDirectory ? 1 : 0,
    };
  }

  /// Crear desde mapa de base de datos
  factory FavoriteEntity.fromMap(Map<String, dynamic> map) {
    return FavoriteEntity(
      id: map['id'],
      filePath: map['filePath'],
      fileName: map['fileName'],
      dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded']),
      isDirectory: map['isDirectory'] == 1,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteEntity && other.filePath == filePath;
  }

  @override
  int get hashCode => filePath.hashCode;

  FavoriteEntity copyWith({
    int? id,
    String? filePath,
    String? fileName,
    DateTime? dateAdded,
    bool? isDirectory,
  }) {
    return FavoriteEntity(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      dateAdded: dateAdded ?? this.dateAdded,
      isDirectory: isDirectory ?? this.isDirectory,
    );
  }
}