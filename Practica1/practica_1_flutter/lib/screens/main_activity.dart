import 'package:flutter/material.dart';
import 'text_fields_screen.dart';
import 'buttons_screen.dart';
import 'selection_elements_screen.dart';
import 'lists_screen.dart';
import 'information_elements_screen.dart';

/// Esta clase es el equivalente directo a un Activity de Android
/// Representa una pantalla completa con su propio estado y ciclo de vida
class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  // Variables de estado - equivalente a variables de instancia en Activity
  String _selectedSection = '';
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Equivalente a onCreate() en Android Activity
    _initializeActivity();
  }
  
  @override
  void dispose() {
    // Equivalente a onDestroy() en Android Activity
    super.dispose();
  }
  
  void _initializeActivity() {
    // Método de inicialización personalizado
    setState(() {
      _selectedSection = 'Bienvenido a la aplicación';
    });
  }
  
  // Método equivalente a startActivity() en Android
  void _navigateToScreen(BuildContext context, Widget screen, String title) {
    setState(() {
      _isLoading = true;
    });
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => screen,
        settings: RouteSettings(name: title),
      ),
    ).then((_) {
      // Equivalente a onActivityResult() en Android
      setState(() {
        _isLoading = false;
        _selectedSection = 'Regresaste de: $title';
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Este método es equivalente a setContentView() en Android Activity
    return Scaffold(
      appBar: AppBar(
        title: const Text('MainActivity - Flutter'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _buildMainContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedSection = 'FAB presionado - ${DateTime.now()}';
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
  
  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sección de estado - muestra información dinámica
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.info, size: 48, color: Colors.blue),
                  const SizedBox(height: 8),
                  const Text(
                    'Estado de la Actividad',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedSection,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (_isLoading) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Elementos de Interfaz de Usuario',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Cards de navegación - equivalentes a botones que inician Activities
          _buildActivityButton(
            title: 'Campos de Texto',
            subtitle: 'EditText equivalents',
            icon: Icons.edit,
            onPressed: () => _navigateToTextFields(context),
          ),
          
          _buildActivityButton(
            title: 'Botones',
            subtitle: 'Button y ImageButton equivalents', 
            icon: Icons.smart_button,
            onPressed: () => _navigateToButtons(context),
          ),
          
          _buildActivityButton(
            title: 'Elementos de Selección',
            subtitle: 'CheckBox, RadioButton, Switch',
            icon: Icons.check_circle,
            onPressed: () => _navigateToSelection(context),
          ),
          
          _buildActivityButton(
            title: 'Listas',
            subtitle: 'RecyclerView equivalent',
            icon: Icons.list_alt,
            onPressed: () => _navigateToLists(context),
          ),
          
          _buildActivityButton(
            title: 'Información',
            subtitle: 'TextView, ImageView, ProgressBar',
            icon: Icons.info_outline,
            onPressed: () => _navigateToInformation(context),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  radius: 24,
                  child: Icon(
                    icon,
                    color: Colors.blue[800],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Métodos de navegación - equivalentes a startActivity() en Android
  void _navigateToTextFields(BuildContext context) {
    _navigateToScreen(context, const TextFieldsScreen(), 'Campos de Texto');
  }
  
  void _navigateToButtons(BuildContext context) {
    _navigateToScreen(context, const ButtonsScreen(), 'Botones');
  }
  
  void _navigateToSelection(BuildContext context) {
    _navigateToScreen(context, const SelectionElementsScreen(), 'Selección');
  }
  
  void _navigateToLists(BuildContext context) {
    _navigateToScreen(context, const ListsScreen(), 'Listas');
  }
  
  void _navigateToInformation(BuildContext context) {
    _navigateToScreen(context, const InformationElementsScreen(), 'Información');
  }
}