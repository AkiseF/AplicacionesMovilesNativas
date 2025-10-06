import '../entities/file_entity.dart';
import '../repositories/file_repository.dart';

/// Caso de uso para listar archivos de un directorio
class ListDirectoryUseCase {
  final FileRepository _fileRepository;

  ListDirectoryUseCase(this._fileRepository);

  Future<List<FileEntity>> call(String path) async {
    try {
      final files = await _fileRepository.listDirectory(path);
      return files;
    } catch (e) {
      throw Exception('Error al listar directorio: $e');
    }
  }
}