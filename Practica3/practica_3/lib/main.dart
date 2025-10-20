import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/thumbnail_cache.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/file_manager_provider.dart';
import 'presentation/pages/home_page.dart';
import 'data/datasources/local_file_datasource.dart';
import 'data/datasources/database_helper.dart';
import 'data/repositories/file_repository_impl.dart';
import 'data/repositories/favorite_repository_impl.dart';
import 'data/repositories/recent_file_repository_impl.dart';
import 'domain/usecases/list_directory_use_case.dart';
import 'domain/usecases/create_directory_use_case.dart';
import 'domain/usecases/search_files_use_case.dart';
import 'domain/usecases/manage_favorites_use_case.dart';
import 'domain/usecases/manage_recent_files_use_case.dart';
import 'domain/usecases/file_operations_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar caché de thumbnails
  await ThumbnailCache.instance.initialize();
  
  runApp(const FileManagerApp());
}

class FileManagerApp extends StatelessWidget {
  const FileManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configurar dependencias
    final localDataSource = LocalFileDataSource();
    final databaseHelper = DatabaseHelper();
    final fileRepository = FileRepositoryImpl(localDataSource);
    final favoriteRepository = FavoriteRepositoryImpl(databaseHelper);
    final recentFileRepository = RecentFileRepositoryImpl(databaseHelper);
    
    // Casos de uso
    final listDirectoryUseCase = ListDirectoryUseCase(fileRepository);
    final createDirectoryUseCase = CreateDirectoryUseCase(fileRepository);
    final searchFilesUseCase = SearchFilesUseCase(fileRepository);
    final manageFavoritesUseCase = ManageFavoritesUseCase(favoriteRepository);
    final manageRecentFilesUseCase = ManageRecentFilesUseCase(recentFileRepository);
    final fileOperationsUseCase = FileOperationsUseCase(fileRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => FileManagerProvider(
            listDirectoryUseCase,
            createDirectoryUseCase,
            searchFilesUseCase,
            fileRepository,
            manageFavoritesUseCase,
            manageRecentFilesUseCase,
            fileOperationsUseCase,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: AppConstants.appName,
            theme: AppThemes.getTheme(themeProvider.appTheme, false),
            darkTheme: AppThemes.getTheme(themeProvider.appTheme, true),
            themeMode: themeProvider.themeMode,
            home: const HomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
