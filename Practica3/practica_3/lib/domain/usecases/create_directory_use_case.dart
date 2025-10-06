import '../repositories/file_repository.dart';

/// Caso de uso para crear un nuevo directorio
class CreateDirectoryUseCase {
  final FileRepository _fileRepository;

  CreateDirectoryUseCase(this._fileRepository);

  Future<bool> call(String parentPath, String directoryName) async {
    try {
      // Validar nombre del directorio
      if (directoryName.trim().isEmpty) {
        throw Exception('El nombre del directorio no puede estar vacío');
      }
      
      // Verificar caracteres válidos
      final invalidChars = RegExp(r'[<>:"/\\|?*]');
      if (invalidChars.hasMatch(directoryName)) {
        throw Exception('El nombre contiene caracteres no válidos');
      }
      
      return await _fileRepository.createDirectory(parentPath, directoryName);
    } catch (e) {
      throw Exception('Error al crear directorio: $e');
    }
  }
}