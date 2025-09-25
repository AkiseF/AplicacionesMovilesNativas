import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

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
            
            CustomButton(
              text: 'Botón Normal',
              onPressed: () => _incrementCounter('botón normal'),
            ),
            const SizedBox(height: 16),
            
            CustomButton(
              text: 'Botón de Color',
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              onPressed: () => _incrementCounter('botón de color'),
            ),
            const SizedBox(height: 16),
            
            CustomButton(
              type: ButtonType.icon,
              icon: Icons.star,
              onPressed: () => _incrementCounter('botón de imagen'),
            ),
            const SizedBox(height: 32),
            
            CounterDisplay(
              label: 'Has hecho clic',
              count: _clickCount,
            ),
            
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: CustomButton(
        type: ButtonType.floating,
        icon: Icons.add,
        onPressed: () => _incrementCounter('botón flotante'),
      ),
    );
  }
}