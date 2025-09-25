import 'package:flutter/material.dart';
import 'text_fields_screen.dart';
import 'buttons_screen.dart';
import 'selection_elements_screen.dart';
import 'lists_screen.dart';
import 'information_elements_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Elementos de UI',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              'Elementos de Interfaz de Usuario',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Card para Campos de Texto
            _buildNavigationCard(
              context: context,
              title: 'Campos de Texto (EditText)',
              subtitle: 'Explorar diferentes tipos de campos de texto',
              icon: Icons.edit,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TextFieldsScreen()),
              ),
            ),
            
            // Card para Botones
            _buildNavigationCard(
              context: context,
              title: 'Botones (Button, ImageButton)',
              subtitle: 'Descubre cómo funcionan los diferentes botones',
              icon: Icons.send,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ButtonsScreen()),
              ),
            ),
            
            // Card para Elementos de Selección
            _buildNavigationCard(
              context: context,
              title: 'Elementos de Selección',
              subtitle: 'CheckBox, RadioButton, Switch y más',
              icon: Icons.check_box,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectionElementsScreen()),
              ),
            ),
            
            // Card para Listas
            _buildNavigationCard(
              context: context,
              title: 'Listas (RecyclerView)',
              subtitle: 'Aprende a mostrar colecciones de datos',
              icon: Icons.list,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListsScreen()),
              ),
            ),
            
            // Card para Elementos de Información
            _buildNavigationCard(
              context: context,
              title: 'Elementos de Información',
              subtitle: 'TextView, ImageView, ProgressBar y más',
              icon: Icons.info,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InformationElementsScreen()),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: Theme.of(context).primaryColor,
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
                      const SizedBox(height: 4),
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
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}