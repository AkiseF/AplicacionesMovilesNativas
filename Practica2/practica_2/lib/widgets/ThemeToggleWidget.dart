import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wb_sunny,
                color: themeService.isDarkMode ? Colors.grey : Colors.yellow,
                size: 20,
              ),
              const SizedBox(width: 8),
              Switch(
                value: themeService.isDarkMode,
                onChanged: (value) async {
                  await themeService.toggleTheme();
                },
                activeColor: const Color(0xFFBB86FC),
                inactiveThumbColor: const Color(0xFF4CAF50),
                inactiveTrackColor: Colors.grey.withOpacity(0.3),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.dark_mode,
                color: themeService.isDarkMode ? const Color(0xFFBB86FC) : Colors.grey,
                size: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}