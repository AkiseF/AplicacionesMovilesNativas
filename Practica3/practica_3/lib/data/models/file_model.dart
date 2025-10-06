import '../../domain/entities/file_entity.dart';
import '../../core/constants/app_constants.dart';

/// Modelo de datos para FileEntity
class FileModel extends FileEntity {
  const FileModel({
    required super.name,
    required super.path,
    required super.isDirectory,
    required super.size,
    required super.lastModified,
    required super.type,
    super.parentPath,
    required super.isHidden,
    required super.isSymbolicLink,
    super.extension,
  });

  /// Crear desde mapa JSON
  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      name: json['name'],
      path: json['path'],
      isDirectory: json['isDirectory'],
      size: json['size'],
      lastModified: DateTime.fromMillisecondsSinceEpoch(json['lastModified']),
      type: FileType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => FileType.other,
      ),
      parentPath: json['parentPath'],
      isHidden: json['isHidden'],
      isSymbolicLink: json['isSymbolicLink'],
      extension: json['extension'],
    );
  }

  /// Convertir a mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'isDirectory': isDirectory,
      'size': size,
      'lastModified': lastModified.millisecondsSinceEpoch,
      'type': type.toString(),
      'parentPath': parentPath,
      'isHidden': isHidden,
      'isSymbolicLink': isSymbolicLink,
      'extension': extension,
    };
  }

  /// Crear desde entidad del dominio
  factory FileModel.fromEntity(FileEntity entity) {
    return FileModel(
      name: entity.name,
      path: entity.path,
      isDirectory: entity.isDirectory,
      size: entity.size,
      lastModified: entity.lastModified,
      type: entity.type,
      parentPath: entity.parentPath,
      isHidden: entity.isHidden,
      isSymbolicLink: entity.isSymbolicLink,
      extension: entity.extension,
    );
  }

  /// Convertir a entidad del dominio
  FileEntity toEntity() {
    return FileEntity(
      name: name,
      path: path,
      isDirectory: isDirectory,
      size: size,
      lastModified: lastModified,
      type: type,
      parentPath: parentPath,
      isHidden: isHidden,
      isSymbolicLink: isSymbolicLink,
      extension: extension,
    );
  }
}