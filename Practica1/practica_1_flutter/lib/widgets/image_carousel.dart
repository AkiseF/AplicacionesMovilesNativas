import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<IconData> icons;
  final List<String> names;
  final String title;

  const ImageCarousel({
    super.key,
    required this.icons,
    required this.names,
    this.title = 'Imagen/Icono',
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.icons.length;
    });
  }

  void _previousImage() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + widget.icons.length) % widget.icons.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                widget.icons[_currentIndex],
                size: 60,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              widget.names[_currentIndex],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _previousImage,
                  child: const Icon(Icons.arrow_back),
                ),
                ElevatedButton(
                  onPressed: _nextImage,
                  child: const Text('Siguiente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}