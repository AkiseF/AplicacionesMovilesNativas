import 'package:flutter/material.dart';
import 'screens/Main/MainScreen.dart';
import 'screens/Base2/AlterScreen.dart';
import 'screens/Base3/Base3Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aventura del Garambullo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AventuraInteractiva(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AventuraInteractiva extends StatefulWidget {
  const AventuraInteractiva({super.key});

  @override
  AventuraInteractivaState createState() => AventuraInteractivaState();
}

class AventuraInteractivaState extends State<AventuraInteractiva> {
  final PageController _pageController = PageController(initialPage: 1);
  int _currentPage = 1; // MainScreen está en el índice 1

  // Configuración circular: Main está en el centro
  final List<Widget> _screens = [
    const AlterScreen(),   // Índice 0 (izquierda de Main)
    const MainScreen(),    // Índice 1 (centro)
    const Base3Screen(),   // Índice 2 (derecha de Main)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _screens,
            ),
          ),
          // Indicador de páginas (puntos) - solo muestra las 3 pantallas lógicas
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Indicador para AlterScreen
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: _currentPage == 0 ? Colors.white : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                // Indicador para MainScreen (activo por defecto)
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: _currentPage == 1 ? Colors.white : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                // Indicador para Base3Screen
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: _currentPage == 2 ? Colors.white : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
