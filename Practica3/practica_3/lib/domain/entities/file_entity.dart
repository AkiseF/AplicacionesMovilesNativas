import 'dart:io';
import 'package:path/path.dart' as path_utils;
import '../../core/constants/app_constants.dart';
import '../../core/utils/file_utils.dart';

/// Entidad que representa un archivo o directorio
class FileEntity {
  final String name;
  final String path;
  final bool isDirectory;
  final int size;
  final DateTime lastModified;
  final FileType type;
  final String? parentPath;
  final bool isHidden;
  final bool isSymbolicLink;
  final String? extension;

  const FileEntity({
    required this.name,
    required this.path,
    required this.isDirectory,
    required this.size,
    required this.lastModified,
    required this.type,
    this.parentPath,
    required this.isHidden,
    required this.isSymbolicLink,
    this.extension,
  });

  /// Crear FileEntity desde un File/Directory del sistema
  factory FileEntity.fromFileSystemEntity(FileSystemEntity entity) {
    final stat = entity.statSync();
    final isDir = entity is Directory;
    final name = entity.path.split(Platform.pathSeparator).last;
    final isHidden = name.startsWith('.');
    
    return FileEntity(
      name: name,
      path: entity.path,
      isDirectory: isDir,
      size: isDir ? 0 : stat.size,
      lastModified: stat.modified,
      type: isDir ? FileType.folder : FileUtils.getFileType(entity.path),
      parentPath: entity.parent.path,
      isHidden: isHidden,
      isSymbolicLink: stat.type == FileSystemEntityType.link,
      extension: isDir ? null : path_utils.extension(entity.path),
    );
  }

  /// Obtener tamaño formateado
  String get formattedSize => FileUtils.formatFileSize(size);

  /// Obtener fecha formateada
  String get formattedDate => FileUtils.formatDate(lastModified);

  /// Obtener icono del archivo
  String get icon => FileUtils.getFileIcon(path, isDirectory: isDirectory);

  /// Verificar si se puede previsualizar
  bool get canPreview => !isDirectory && FileUtils.canPreview(path);

  /// Verificar si es una imagen
  bool get isImage => !isDirectory && type == FileType.image;

  /// Verificar si es un archivo de texto
  bool get isText => !isDirectory && type == FileType.text;

  /// Obtener nombre sin extensión
  String get nameWithoutExtension {
    return isDirectory ? name : FileUtils.getFileNameWithoutExtension(path);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileEntity && other.path == path;
  }

  @override
  int get hashCode => path.hashCode;

  @override
  String toString() {
    return 'FileEntity(name: $name, path: $path, isDirectory: $isDirectory, size: $size)';
  }

  /// Copiar con nuevos valores
  FileEntity copyWith({
    String? name,
    String? path,
    bool? isDirectory,
    int? size,
    DateTime? lastModified,
    FileType? type,
    String? parentPath,
    bool? isHidden,
    bool? isSymbolicLink,
    String? extension,
  }) {
    return FileEntity(
      name: name ?? this.name,
      path: path ?? this.path,
      isDirectory: isDirectory ?? this.isDirectory,
      size: size ?? this.size,
      lastModified: lastModified ?? this.lastModified,
      type: type ?? this.type,
      parentPath: parentPath ?? this.parentPath,
      isHidden: isHidden ?? this.isHidden,
      isSymbolicLink: isSymbolicLink ?? this.isSymbolicLink,
      extension: extension ?? this.extension,
    );
  }
}