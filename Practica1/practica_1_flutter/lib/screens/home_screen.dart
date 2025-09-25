import 'package:flutter/material.dart';
import 'text_fields_screen.dart';
import 'buttons_screen.dart';
import 'selection_elements_screen.dart';
import 'lists_screen.dart';
import 'information_elements_screen.dart';
import '../widgets/widgets.dart';

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
            NavigationCard(
              title: 'Campos de Texto (EditText)',
              subtitle: 'Explorar diferentes tipos de campos de texto',
              icon: Icons.edit,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TextFieldsScreen()),
              ),
            ),
            
            // Card para Botones
            NavigationCard(
              title: 'Botones (Button, ImageButton)',
              subtitle: 'Descubre cómo funcionan los diferentes botones',
              icon: Icons.send,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ButtonsScreen()),
              ),
            ),
            
            // Card para Elementos de Selección
            NavigationCard(
              title: 'Elementos de Selección',
              subtitle: 'CheckBox, RadioButton, Switch y más',
              icon: Icons.check_box,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelectionElementsScreen()),
              ),
            ),
            
            // Card para Listas
            NavigationCard(
              title: 'Listas (RecyclerView)',
              subtitle: 'Aprende a mostrar colecciones de datos',
              icon: Icons.list,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListsScreen()),
              ),
            ),
            
            // Card para Elementos de Información
            NavigationCard(
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
}