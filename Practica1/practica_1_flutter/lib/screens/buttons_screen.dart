import 'package:flutter/material.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  int _clickCount = 0;

  void _incrementCounter(String buttonType) {
    setState(() {
      _clickCount++;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Clic en $buttonType'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Botones'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Botones (Buttons)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Los botones permiten al usuario realizar acciones y hacer selecciones con un simple toque.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: () => _incrementCounter('botón normal'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Botón Normal'),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: () => _incrementCounter('botón de color'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Botón de Color'),
            ),
            const SizedBox(height: 16),
            
            Container(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () => _incrementCounter('botón de imagen'),
                icon: const Icon(Icons.star),
                iconSize: 48,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            Text(
              'Has hecho clic $_clickCount veces',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter('botón flotante'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}