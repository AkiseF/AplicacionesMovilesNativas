import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart'; 

void main() {
  runApp(const GuessWhoApp());
}

class GuessWhoApp extends StatelessWidget {
  const GuessWhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Guess Who - Attack on Titan',
            theme: themeProvider.getThemeData(),
            darkTheme: themeProvider.getThemeData(),
            themeMode: ThemeMode.light,
            home: const SplashScreen(), 
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}