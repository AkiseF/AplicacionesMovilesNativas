import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return IconButton(
          onPressed: () => _showThemeDialog(context, themeProvider),
          icon: Icon(
            Icons.palette_outlined,
            color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
            size: 20,
          ),
          tooltip: 'Cambiar tema de color',
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.palette),
            SizedBox(width: 8),
            Text('Personalización'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dark mode toggle section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(
                      themeProvider.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Modo ${themeProvider.isDarkMode ? 'Oscuro' : 'Claro'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Cambia el fondo de la aplicación',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) => themeProvider.toggleDarkMode(),
                      activeThumbColor: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Theme color section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Color del Tema',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...AppTheme.values.map((theme) {
              return _buildThemeOption(
                context,
                theme,
                themeProvider.currentTheme == theme,
                () => themeProvider.setTheme(theme),
                themeProvider,
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    AppTheme theme,
    bool isSelected,
    VoidCallback onTap,
    ThemeProvider themeProvider,
  ) {
    Color themeColor;
    IconData themeIcon;
    
    switch (theme) {
      case AppTheme.red:
        themeColor = const Color(0xFFAA281A);
        themeIcon = Icons.shield;
        break;
      case AppTheme.blue:
        themeColor = const Color(0xFF10357B);
        themeIcon = Icons.explore;
        break;
      case AppTheme.green:
        themeColor = const Color(0xFF1D4F34);
        themeIcon = Icons.security;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: themeColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            themeIcon,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          themeProvider.getThemeName(theme),
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected 
            ? Icon(
                Icons.check_circle,
                color: themeColor,
              )
            : null,
        onTap: () {
          onTap();
          // No cerrar automáticamente - el usuario debe presionar "Cerrar"
        },
      ),
    );
  }
}