import 'package:flutter/material.dart';

class ListItem {
  final int id;
  final String title;
  final String description;

  ListItem({required this.id, required this.title, required this.description});
}

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
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Column(
              children: [
                Text(
                  'Listas (ListView)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Las listas permiten mostrar una colección de elementos de forma organizada y desplazable.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${item.id}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.description),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _onItemTap(item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}