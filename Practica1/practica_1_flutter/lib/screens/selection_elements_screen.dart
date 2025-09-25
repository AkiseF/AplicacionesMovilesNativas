import 'package:flutter/material.dart';

class SelectionElementsScreen extends StatefulWidget {
  const SelectionElementsScreen({super.key});

  @override
  State<SelectionElementsScreen> createState() => _SelectionElementsScreenState();
}

class _SelectionElementsScreenState extends State<SelectionElementsScreen> {
  bool _wifiEnabled = false;
  bool _bluetoothEnabled = false;
  bool _dataEnabled = false;
  
  String _selectedTheme = 'light';
  
  bool _notificationsEnabled = true;
  bool _locationEnabled = false;
  
  String get _resultText {
    String result = 'Configuración seleccionada:\n\n';
    
    result += 'Conectividad:\n';
    result += '- WiFi: ${_wifiEnabled ? "Activado" : "Desactivado"}\n';
    result += '- Bluetooth: ${_bluetoothEnabled ? "Activado" : "Desactivado"}\n';
    result += '- Datos móviles: ${_dataEnabled ? "Activado" : "Desactivado"}\n';
    
    result += '\nTema de la aplicación: ';
    switch (_selectedTheme) {
      case 'light':
        result += 'Claro';
        break;
      case 'dark':
        result += 'Oscuro';
        break;
      case 'auto':
        result += 'Automático';
        break;
    }
    
    result += '\n\nOtras configuraciones:\n';
    result += '- Notificaciones: ${_notificationsEnabled ? "Activadas" : "Desactivadas"}\n';
    result += '- Ubicación: ${_locationEnabled ? "Activada" : "Desactivada"}\n';
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elementos de Selección'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elementos de Selección',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Los elementos de selección permiten al usuario elegir opciones de configuración.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Conectividad:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            CheckboxListTile(
              title: const Text('WiFi'),
              value: _wifiEnabled,
              onChanged: (value) {
                setState(() {
                  _wifiEnabled = value ?? false;
                });
              },
            ),
            
            CheckboxListTile(
              title: const Text('Bluetooth'),
              value: _bluetoothEnabled,
              onChanged: (value) {
                setState(() {
                  _bluetoothEnabled = value ?? false;
                });
              },
            ),
            
            CheckboxListTile(
              title: const Text('Datos móviles'),
              value: _dataEnabled,
              onChanged: (value) {
                setState(() {
                  _dataEnabled = value ?? false;
                });
              },
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Tema de la aplicación:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Claro'),
                  value: 'light',
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value!;
                    });
                  },
                ),
                
                RadioListTile<String>(
                  title: const Text('Oscuro'),
                  value: 'dark',
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value!;
                    });
                  },
                ),
                
                RadioListTile<String>(
                  title: const Text('Automático'),
                  value: 'auto',
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() {
                      _selectedTheme = value!;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Text(
              'Otras configuraciones:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            SwitchListTile(
              title: const Text('Notificaciones'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            
            SwitchListTile(
              title: const Text('Ubicación'),
              value: _locationEnabled,
              onChanged: (value) {
                setState(() {
                  _locationEnabled = value;
                });
              },
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
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}