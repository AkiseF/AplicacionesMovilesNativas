import 'package:flutter/material.dart';
import 'screens/MainScreen.dart';
import 'screens/AlterScreen.dart';
import 'widgets/PageIndicatorWidget.dart';

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
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const MainScreen(),
    const AlterScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _screens,
            ),
          ),
          // Indicador de páginas (puntos)
          PageIndicatorWidget(
            pageController: _pageController,
            totalPages: _screens.length,
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
