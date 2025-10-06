import 'package:flutter/material.dart';
import '../../domain/entities/file_entity.dart';
import '../../core/constants/app_constants.dart';

/// Widget para mostrar la lista de archivos
class FileListWidget extends StatelessWidget {
  final List<FileEntity> files;
  final ViewMode viewMode;
  final Function(FileEntity) onFilePressed;
  final Function(FileEntity) onFileLongPress;

  const FileListWidget({
    super.key,
    required this.files,
    required this.viewMode,
    required this.onFilePressed,
    required this.onFileLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay archivos en esta carpeta',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return viewMode == ViewMode.list 
      ? _buildListView(context)
      : _buildGridView(context);
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return _FileListTile(
          file: file,
          onTap: () => onFilePressed(file),
          onLongPress: () => onFileLongPress(file),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return _FileGridTile(
          file: file,
          onTap: () => onFilePressed(file),
          onLongPress: () => onFileLongPress(file),
        );
      },
    );
  }
}

/// Elemento de lista para archivos
class _FileListTile extends StatelessWidget {
  final FileEntity file;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _FileListTile({
    required this.file,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: file.isDirectory 
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.secondaryContainer,
        child: Text(
          file.icon,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(
        file.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: file.isDirectory ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        file.isDirectory 
          ? 'Carpeta • ${file.formattedDate}'
          : '${file.formattedSize} • ${file.formattedDate}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: file.isDirectory 
        ? const Icon(Icons.chevron_right)
        : null,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

/// Elemento de cuadrícula para archivos
class _FileGridTile extends StatelessWidget {
  final FileEntity file;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _FileGridTile({
    required this.file,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono del archivo
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: file.isDirectory 
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  file.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Nombre del archivo
            Text(
              file.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: file.isDirectory ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // Información adicional
            Text(
              file.isDirectory 
                ? 'Carpeta'
                : file.formattedSize,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}