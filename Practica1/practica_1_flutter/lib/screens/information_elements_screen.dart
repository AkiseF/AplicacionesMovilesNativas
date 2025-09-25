import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class InformationElementsScreen extends StatefulWidget {
  const InformationElementsScreen({super.key});

  @override
  State<InformationElementsScreen> createState() => _InformationElementsScreenState();
}

class _InformationElementsScreenState extends State<InformationElementsScreen> {
  final List<IconData> _images = [
    Icons.camera_alt,
    Icons.photo_library,
    Icons.place,
    Icons.map,
  ];
  
  final List<String> _imageNames = [
    'Cámara',
    'Galería',
    'Ubicación',
    'Mapa',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elementos de Información'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Elementos de Información',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Estos elementos muestran información al usuario de diferentes formas.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Progress Section
            ProgressIndicatorWidget(),
            
            const SizedBox(height: 24),
            
            // Image Section
            ImageCarousel(
              icons: _images,
              names: _imageNames,
            ),
            
            const SizedBox(height: 24),
            
            // Information Text Section
            InfoListWidget(
              title: 'Información Adicional',
              items: [
                InfoListItem(
                  icon: Icons.info_outline,
                  iconColor: Colors.blue,
                  text: 'Los elementos informativos ayudan a comunicar el estado de la aplicación.',
                ),
                InfoListItem(
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  text: 'Flutter proporciona widgets ricos para mostrar información.',
                ),
                InfoListItem(
                  icon: Icons.star_outline,
                  iconColor: Colors.orange,
                  text: 'Estos elementos mejoran la experiencia del usuario.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}