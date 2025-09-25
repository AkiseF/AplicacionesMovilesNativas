import 'package:flutter/material.dart';
import 'text_fields_screen.dart';
import 'buttons_screen.dart';
import 'selection_elements_screen.dart';
import 'lists_screen.dart';
import 'information_elements_screen.dart';
import '../widgets/widgets.dart';

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
          StatusDisplay(
            status: _selectedSection,
            isLoading: _isLoading,
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
          NavigationCard(
            title: 'Campos de Texto',
            subtitle: 'EditText equivalents',
            icon: Icons.edit,
            onTap: () => _navigateToTextFields(context),
          ),
          
          NavigationCard(
            title: 'Botones',
            subtitle: 'Button y ImageButton equivalents',
            icon: Icons.smart_button,
            onTap: () => _navigateToButtons(context),
          ),
          
          NavigationCard(
            title: 'Elementos de Selección',
            subtitle: 'CheckBox, RadioButton, Switch',
            icon: Icons.check_circle,
            onTap: () => _navigateToSelection(context),
          ),
          
          NavigationCard(
            title: 'Listas',
            subtitle: 'RecyclerView equivalent',
            icon: Icons.list_alt,
            onTap: () => _navigateToLists(context),
          ),
          
          NavigationCard(
            title: 'Información',
            subtitle: 'TextView, ImageView, ProgressBar',
            icon: Icons.info_outline,
            onTap: () => _navigateToInformation(context),
          ),
        ],
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