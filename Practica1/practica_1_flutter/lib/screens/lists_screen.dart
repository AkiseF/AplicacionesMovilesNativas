import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> {
  final List<ListItem> _items = [
    ListItem(id: 1, title: 'Elemento 1', description: 'Descripción del elemento 1'),
    ListItem(id: 2, title: 'Elemento 2', description: 'Descripción del elemento 2'),
    ListItem(id: 3, title: 'Elemento 3', description: 'Descripción del elemento 3'),
    ListItem(id: 4, title: 'Elemento 4', description: 'Descripción del elemento 4'),
    ListItem(id: 5, title: 'Elemento 5', description: 'Descripción del elemento 5'),
    ListItem(id: 6, title: 'Elemento 6', description: 'Descripción del elemento 6'),
    ListItem(id: 7, title: 'Elemento 7', description: 'Descripción del elemento 7'),
    ListItem(id: 8, title: 'Elemento 8', description: 'Descripción del elemento 8'),
    ListItem(id: 9, title: 'Elemento 9', description: 'Descripción del elemento 9'),
    ListItem(id: 10, title: 'Elemento 10', description: 'Descripción del elemento 10'),
  ];

  void _onItemTap(ListItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Seleccionaste: ${item.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: CustomListView(
        items: _items,
        title: 'Listas (ListView)',
        description: 'Las listas permiten mostrar una colección de elementos de forma organizada y desplazable.',
        onItemTap: _onItemTap,
      ),
    );
  }
}