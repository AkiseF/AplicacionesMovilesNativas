import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/file_manager_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/file_list_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/breadcrumb_widget.dart';
import '../../core/constants/app_constants.dart';

/// Página principal del gestor de archivos
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FileManagerProvider, ThemeProvider>(
      builder: (context, fileProvider, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.appName),
            actions: [
              // Cambiar vista
              IconButton(
                icon: Icon(
                  fileProvider.viewMode == ViewMode.list 
                    ? Icons.grid_view 
                    : Icons.list
                ),
                onPressed: () {
                  final newMode = fileProvider.viewMode == ViewMode.list 
                    ? ViewMode.grid 
                    : ViewMode.list;
                  fileProvider.setViewMode(newMode);
                },
                tooltip: 'Cambiar vista',
              ),
              // Ordenamiento
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort),
                tooltip: 'Ordenar',
                onSelected: (value) {
                  switch (value) {
                    case 'name':
                      fileProvider.setSorting(SortBy.name, fileProvider.sortOrder);
                      break;
                    case 'size':
                      fileProvider.setSorting(SortBy.size, fileProvider.sortOrder);
                      break;
                    case 'date':
                      fileProvider.setSorting(SortBy.date, fileProvider.sortOrder);
                      break;
                    case 'type':
                      fileProvider.setSorting(SortBy.type, fileProvider.sortOrder);
                      break;
                    case 'order':
                      final newOrder = fileProvider.sortOrder == SortOrder.ascending 
                        ? SortOrder.descending 
                        : SortOrder.ascending;
                      fileProvider.setSorting(fileProvider.sortBy, newOrder);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'name',
                    child: Row(
                      children: [
                        const Icon(Icons.sort_by_alpha),
                        const SizedBox(width: 8),
                        const Text('Nombre'),
                        if (fileProvider.sortBy == SortBy.name)
                          const Icon(Icons.check, size: 16),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'size',
                    child: Row(
                      children: [
                        const Icon(Icons.data_usage),
                        const SizedBox(width: 8),
                        const Text('Tamaño'),
                        if (fileProvider.sortBy == SortBy.size)
                          const Icon(Icons.check, size: 16),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'date',
                    child: Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 8),
                        const Text('Fecha'),
                        if (fileProvider.sortBy == SortBy.date)
                          const Icon(Icons.check, size: 16),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'type',
                    child: Row(
                      children: [
                        const Icon(Icons.category),
                        const SizedBox(width: 8),
                        const Text('Tipo'),
                        if (fileProvider.sortBy == SortBy.type)
                          const Icon(Icons.check, size: 16),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'order',
                    child: Row(
                      children: [
                        Icon(fileProvider.sortOrder == SortOrder.ascending 
                          ? Icons.arrow_upward 
                          : Icons.arrow_downward),
                        const SizedBox(width: 8),
                        Text(fileProvider.sortOrder == SortOrder.ascending 
                          ? 'Ascendente' 
                          : 'Descendente'),
                      ],
                    ),
                  ),
                ],
              ),
              // Menú opciones
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'hidden':
                      fileProvider.toggleHiddenFiles();
                      break;
                    case 'refresh':
                      fileProvider.refresh();
                      break;
                    case 'theme_guinda':
                      themeProvider.setAppTheme(AppTheme.guinda);
                      break;
                    case 'theme_azul':
                      themeProvider.setAppTheme(AppTheme.azul);
                      break;
                    case 'theme_mode':
                      themeProvider.toggleThemeMode();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'hidden',
                    child: Row(
                      children: [
                        Icon(fileProvider.showHiddenFiles 
                          ? Icons.visibility_off 
                          : Icons.visibility),
                        const SizedBox(width: 8),
                        Text(fileProvider.showHiddenFiles 
                          ? 'Ocultar archivos ocultos' 
                          : 'Mostrar archivos ocultos'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'refresh',
                    child: Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 8),
                        Text('Actualizar'),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'theme_guinda',
                    child: Row(
                      children: [
                        Icon(Icons.palette, color: Color(AppConstants.ipnGuindaColor)),
                        SizedBox(width: 8),
                        Text('Tema Guinda (IPN)'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'theme_azul',
                    child: Row(
                      children: [
                        Icon(Icons.palette, color: Color(AppConstants.escomAzulColor)),
                        SizedBox(width: 8),
                        Text('Tema Azul (ESCOM)'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'theme_mode',
                    child: Row(
                      children: [
                        Icon(themeProvider.isDarkMode(context) 
                          ? Icons.light_mode 
                          : Icons.dark_mode),
                        const SizedBox(width: 8),
                        Text(themeProvider.isDarkMode(context) 
                          ? 'Modo claro' 
                          : 'Modo oscuro'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Barra de búsqueda
              SearchBarWidget(
                controller: _searchController,
                onSearch: (query) => fileProvider.searchFiles(query),
                onClear: () => fileProvider.clearSearch(),
              ),
              
              // Breadcrumbs
              if (!fileProvider.isSearching)
                BreadcrumbWidget(
                  breadcrumbs: fileProvider.breadcrumbs,
                  onNavigate: (path) => fileProvider.navigateToPath(path),
                ),
              
              // Lista/Grid de archivos
              Expanded(
                child: fileProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : fileProvider.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              fileProvider.error!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => fileProvider.clearError(),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                    : FileListWidget(
                        files: fileProvider.getFilteredFiles(),
                        viewMode: fileProvider.viewMode,
                        onFilePressed: (file) => _handleFilePress(context, file, fileProvider),
                        onFileLongPress: (file) => _showFileOptions(context, file, fileProvider),
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateDirectoryDialog(context, fileProvider),
            tooltip: 'Nueva carpeta',
            child: const Icon(Icons.create_new_folder),
          ),
        );
      },
    );
  }

  /// Manejar presión de archivo
  void _handleFilePress(BuildContext context, file, FileManagerProvider provider) {
    if (file.isDirectory) {
      provider.navigateToPath(file.path);
    } else {
      // TODO: Implementar apertura de archivo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Abrir archivo: ${file.name}')),
      );
    }
  }

  /// Mostrar opciones de archivo
  void _showFileOptions(BuildContext context, file, FileManagerProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Renombrar'),
            onTap: () {
              Navigator.pop(context);
              _showRenameDialog(context, file, provider);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Eliminar'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteDialog(context, file, provider);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Cancelar'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Mostrar diálogo para crear directorio
  void _showCreateDirectoryDialog(BuildContext context, FileManagerProvider provider) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva carpeta'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nombre de la carpeta',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.createDirectory(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  /// Mostrar diálogo para renombrar
  void _showRenameDialog(BuildContext context, file, FileManagerProvider provider) {
    final controller = TextEditingController(text: file.name);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renombrar'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nuevo nombre',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.renameFile(file.path, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Renombrar'),
          ),
        ],
      ),
    );
  }

  /// Mostrar diálogo para eliminar
  void _showDeleteDialog(BuildContext context, file, FileManagerProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar "${file.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteFile(file.path);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}