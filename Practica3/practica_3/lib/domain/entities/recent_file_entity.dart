/// Entidad para historial de archivos recientes
class RecentFileEntity {
  final int? id;
  final String filePath;
  final String fileName;
  final DateTime lastAccessed;
  final bool isDirectory;
  final String fileType;

  const RecentFileEntity({
    this.id,
    required this.filePath,
    required this.fileName,
    required this.lastAccessed,
    required this.isDirectory,
    required this.fileType,
  });

  /// Convertir a mapa para base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'filePath': filePath,
      'fileName': fileName,
      'lastAccessed': lastAccessed.millisecondsSinceEpoch,
      'isDirectory': isDirectory ? 1 : 0,
      'fileType': fileType,
    };
  }

  /// Crear desde mapa de base de datos
  factory RecentFileEntity.fromMap(Map<String, dynamic> map) {
    return RecentFileEntity(
      id: map['id'],
      filePath: map['filePath'],
      fileName: map['fileName'],
      lastAccessed: DateTime.fromMillisecondsSinceEpoch(map['lastAccessed']),
      isDirectory: map['isDirectory'] == 1,
      fileType: map['fileType'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecentFileEntity && other.filePath == filePath;
  }

  @override
  int get hashCode => filePath.hashCode;

  RecentFileEntity copyWith({
    int? id,
    String? filePath,
    String? fileName,
    DateTime? lastAccessed,
    bool? isDirectory,
    String? fileType,
  }) {
    return RecentFileEntity(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      lastAccessed: lastAccessed ?? this.lastAccessed,
      isDirectory: isDirectory ?? this.isDirectory,
      fileType: fileType ?? this.fileType,
    );
  }
}