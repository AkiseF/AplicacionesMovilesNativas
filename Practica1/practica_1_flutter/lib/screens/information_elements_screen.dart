import 'package:flutter/material.dart';
import 'dart:async';

class InformationElementsScreen extends StatefulWidget {
  const InformationElementsScreen({super.key});

  @override
  State<InformationElementsScreen> createState() => _InformationElementsScreenState();
}

class _InformationElementsScreenState extends State<InformationElementsScreen> {
  double _progressValue = 0.0;
  bool _isLoading = false;
  String _loadingText = 'Presiona el botón para iniciar';
  int _currentImageIndex = 0;
  Timer? _progressTimer;
  
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

  void _startProgress() {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _progressValue = 0.0;
      _loadingText = 'Cargando...';
    });
    
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progressValue += 0.01;
        if (_progressValue >= 1.0) {
          _progressValue = 1.0;
          _isLoading = false;
          _loadingText = '¡Carga completada!';
          timer.cancel();
        }
      });
    });
  }
  
  void _nextImage() {
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % _images.length;
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Indicador de Progreso',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    if (_isLoading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                    ],
                    
                    Text(
                      _loadingText,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    
                    Text('${(_progressValue * 100).toInt()}%'),
                    const SizedBox(height: 16),
                    
                    ElevatedButton(
                      onPressed: _isLoading ? null : _startProgress,
                      child: Text(_isLoading ? 'Cargando...' : 'Iniciar progreso'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Image Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Imagen/Icono',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Icon(
                        _images[_currentImageIndex],
                        size: 60,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      _imageNames[_currentImageIndex],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    ElevatedButton(
                      onPressed: _nextImage,
                      child: const Text('Siguiente Imagen'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Information Text Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información Adicional',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Los elementos informativos ayudan a comunicar el estado de la aplicación.',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Flutter proporciona widgets ricos para mostrar información.',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Icon(Icons.star_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Estos elementos mejoran la experiencia del usuario.',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}