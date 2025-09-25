import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elementos de UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Clase MainScreen comentada - usando HomeScreen como pantalla principal
// Si necesitas navegación por tabs, descomenta esta clase y úsala en lugar de HomeScreen

/*
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const TextFieldsScreen(),
    const ButtonsScreen(),
    const SelectionElementsScreen(),
    const ListsScreen(),
    const InformationElementsScreen(),
  ];
  
  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.edit),
      label: 'Campos de texto',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.send),
      label: 'Botones',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.check_box),
      label: 'Selección',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Listas',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.info),
      label: 'Información',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _bottomNavItems,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
*/
