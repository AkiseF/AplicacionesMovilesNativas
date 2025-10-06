import '../entities/file_entity.dart';
import '../repositories/file_repository.dart';

/// Caso de uso para buscar archivos
class SearchFilesUseCase {
  final FileRepository _fileRepository;

  SearchFilesUseCase(this._fileRepository);

  Future<List<FileEntity>> call(String query, {String? directory}) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }
      
      return await _fileRepository.searchFiles(query, directory: directory);
    } catch (e) {
      throw Exception('Error al buscar archivos: $e');
    }
  }
}