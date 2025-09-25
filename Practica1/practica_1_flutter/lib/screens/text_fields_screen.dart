import 'package:flutter/material.dart';

class TextFieldsScreen extends StatefulWidget {
  const TextFieldsScreen({super.key});

  @override
  State<TextFieldsScreen> createState() => _TextFieldsScreenState();
}

class _TextFieldsScreenState extends State<TextFieldsScreen> {
  final TextEditingController _normalController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _multilineController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  
  String _resultText = 'Completa los campos para ver el resultado aquí';

  @override
  void initState() {
    super.initState();
    _normalController.addListener(_updateResult);
    _passwordController.addListener(_updateResult);
    _multilineController.addListener(_updateResult);
    _numberController.addListener(_updateResult);
  }

  void _updateResult() {
    String result = 'Campos completados:\n';
    
    if (_normalController.text.isNotEmpty) {
      result += '- Texto normal: ${_normalController.text}\n';
    }
    if (_passwordController.text.isNotEmpty) {
      result += '- Contraseña: ${_passwordController.text}\n';
    }
    if (_multilineController.text.isNotEmpty) {
      result += '- Texto multilínea: ${_multilineController.text}\n';
    }
    if (_numberController.text.isNotEmpty) {
      result += '- Número: ${_numberController.text}\n';
    }
    
    setState(() {
      _resultText = result;
    });
  }

  @override
  void dispose() {
    _normalController.dispose();
    _passwordController.dispose();
    _multilineController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campos de Texto'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Campos de Texto (TextField)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Los campos de texto permiten al usuario ingresar y editar texto. Son esenciales para formularios y cualquier interacción que requiera entrada de datos.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            TextField(
              controller: _normalController,
              decoration: const InputDecoration(
                labelText: 'Campo de texto normal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Campo de contraseña',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _multilineController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Campo multilínea',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Campo numérico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Resultado:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _resultText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}