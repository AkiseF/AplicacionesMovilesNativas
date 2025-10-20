import 'package:flutter/material.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/entities/recent_file_entity.dart';

/// Página para mostrar favoritos y archivos recientes
class FavoritesAndRecentPage extends StatefulWidget {
  final List<FavoriteEntity> favorites;
  final List<RecentFileEntity> recentFiles;
  final Function(String) onNavigateToFile;
  final Function(String) onRemoveFavorite;
  final Function(String) onRemoveRecent;

  const FavoritesAndRecentPage({
    super.key,
    required this.favorites,
    required this.recentFiles,
    required this.onNavigateToFile,
    required this.onRemoveFavorite,
    required this.onRemoveRecent,
  });

  @override
  State<FavoritesAndRecentPage> createState() => _FavoritesAndRecentPageState();
}

class _FavoritesAndRecentPageState extends State<FavoritesAndRecentPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos y Recientes'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.favorite),
              text: 'Favoritos (${widget.favorites.length})',
            ),
            Tab(
              icon: const Icon(Icons.history),
              text: 'Recientes (${widget.recentFiles.length})',
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'clear_favorites':
                  _showClearFavoritesDialog();
                  break;
                case 'clear_recent':
                  _showClearRecentDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_favorites',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Limpiar favoritos'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_recent',
                child: Row(
                  children: [
                    Icon(Icons.history_toggle_off),
                    SizedBox(width: 8),
                    Text('Limpiar recientes'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritesTab(),
          _buildRecentTab(),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    if (widget.favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No tienes archivos favoritos',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Mantén presionado un archivo para agregarlo a favoritos',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.favorites.length,
      itemBuilder: (context, index) {
        final favorite = widget.favorites[index];
        return _FavoriteListTile(
          favorite: favorite,
          onTap: () => widget.onNavigateToFile(favorite.filePath),
          onRemove: () => widget.onRemoveFavorite(favorite.filePath),
        );
      },
    );
  }

  Widget _buildRecentTab() {
    if (widget.recentFiles.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay archivos recientes',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Los archivos que abras aparecerán aquí',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.recentFiles.length,
      itemBuilder: (context, index) {
        final recentFile = widget.recentFiles[index];
        return _RecentFileListTile(
          recentFile: recentFile,
          onTap: () => widget.onNavigateToFile(recentFile.filePath),
          onRemove: () => widget.onRemoveRecent(recentFile.filePath),
        );
      },
    );
  }

  void _showClearFavoritesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar favoritos'),
        content: const Text('¿Estás seguro de que deseas eliminar todos los favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar limpiar favoritos
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  void _showClearRecentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar recientes'),
        content: const Text('¿Estás seguro de que deseas eliminar el historial de archivos recientes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implementar limpiar recientes
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }
}

class _FavoriteListTile extends StatelessWidget {
  final FavoriteEntity favorite;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteListTile({
    required this.favorite,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: favorite.isDirectory 
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.secondaryContainer,
        child: Icon(
          favorite.isDirectory ? Icons.folder : Icons.insert_drive_file,
          color: favorite.isDirectory 
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(
        favorite.fileName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: favorite.isDirectory ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            favorite.filePath,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            'Agregado: ${_formatDate(favorite.dateAdded)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.favorite, color: Colors.red),
        onPressed: onRemove,
        tooltip: 'Quitar de favoritos',
      ),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Hoy ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _RecentFileListTile extends StatelessWidget {
  final RecentFileEntity recentFile;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentFileListTile({
    required this.recentFile,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: recentFile.isDirectory 
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.secondaryContainer,
        child: Icon(
          recentFile.isDirectory ? Icons.folder : Icons.insert_drive_file,
          color: recentFile.isDirectory 
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(
        recentFile.fileName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: recentFile.isDirectory ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recentFile.filePath,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            'Accedido: ${_formatDate(recentFile.lastAccessed)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: onRemove,
        tooltip: 'Quitar del historial',
      ),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 1) {
      return 'Ahora mismo';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}