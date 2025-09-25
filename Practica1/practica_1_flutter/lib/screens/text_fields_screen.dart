import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

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
            FormFieldGroup(
              title: 'Campos de Texto (TextField)',
              description: 'Los campos de texto permiten al usuario ingresar y editar texto. Son esenciales para formularios y cualquier interacción que requiera entrada de datos.',
              fields: [
                CustomFormField(
                  controller: _normalController,
                  label: 'Campo de texto normal',
                  onChanged: (_) => _updateResult(),
                ),
                CustomFormField(
                  controller: _passwordController,
                  label: 'Campo de contraseña',
                  type: FormFieldType.password,
                  onChanged: (_) => _updateResult(),
                ),
                CustomFormField(
                  controller: _multilineController,
                  label: 'Campo multilínea',
                  type: FormFieldType.multiline,
                  onChanged: (_) => _updateResult(),
                ),
                CustomFormField(
                  controller: _numberController,
                  label: 'Campo numérico',
                  type: FormFieldType.number,
                  onChanged: (_) => _updateResult(),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            ResultDisplay(
              title: 'Resultado:',
              content: _resultText,
            ),
          ],
        ),
      ),
    );
  }
}