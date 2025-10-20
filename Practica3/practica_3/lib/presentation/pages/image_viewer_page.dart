import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

/// Página para visualizar imágenes con zoom y navegación
class ImageViewerPage extends StatefulWidget {
  final String imagePath;
  final String fileName;
  final List<String>? imageList;
  final int initialIndex;
  
  const ImageViewerPage({
    super.key,
    required this.imagePath,
    required this.fileName,
    this.imageList,
    this.initialIndex = 0,
  });
  
  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showControls = true;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final imageList = widget.imageList ?? [widget.imagePath];
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _showControls ? AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        foregroundColor: Colors.white,
        title: Text(
          imageList.length > 1 
            ? '${_currentIndex + 1} de ${imageList.length}'
            : widget.fileName,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareImage,
            tooltip: 'Compartir',
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: _showImageInfo,
            tooltip: 'Información',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'wallpaper':
                  _setAsWallpaper();
                  break;
                case 'rotate':
                  _rotateImage();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'wallpaper',
                child: Row(
                  children: [
                    Icon(Icons.wallpaper),
                    SizedBox(width: 8),
                    Text('Establecer como fondo'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'rotate',
                child: Row(
                  children: [
                    Icon(Icons.rotate_right),
                    SizedBox(width: 8),
                    Text('Rotar'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ) : null,
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: imageList.length == 1 
          ? _buildSingleImage(imageList[0])
          : _buildImageGallery(imageList),
      ),
      bottomNavigationBar: _showControls && imageList.length > 1
        ? _buildBottomControls()
        : null,
    );
  }
  
  Widget _buildSingleImage(String imagePath) {
    return PhotoView(
      imageProvider: FileImage(File(imagePath)),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 4.0,
      heroAttributes: PhotoViewHeroAttributes(tag: imagePath),
      backgroundDecoration: const BoxDecoration(
        color: Colors.black,
      ),
      loadingBuilder: (context, event) => const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
      errorBuilder: (context, error, stackTrace) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 64),
            SizedBox(height: 16),
            Text(
              'Error al cargar la imagen',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImageGallery(List<String> imageList) {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: FileImage(File(imageList[index])),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 4.0,
          heroAttributes: PhotoViewHeroAttributes(tag: imageList[index]),
          basePosition: Alignment.center,
        );
      },
      itemCount: imageList.length,
      loadingBuilder: (context, event) => const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
      pageController: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      backgroundDecoration: const BoxDecoration(
        color: Colors.black,
      ),
    );
  }
  
  Widget _buildBottomControls() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: _currentIndex > 0 ? _previousImage : null,
          ),
          Text(
            '${_currentIndex + 1} / ${widget.imageList!.length}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: _currentIndex < widget.imageList!.length - 1 
              ? _nextImage 
              : null,
          ),
        ],
      ),
    );
  }
  
  void _previousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  void _nextImage() {
    if (_currentIndex < widget.imageList!.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  Future<void> _shareImage() async {
    try {
      final currentImagePath = widget.imageList?[_currentIndex] ?? widget.imagePath;
      final xFile = XFile(currentImagePath);
      await Share.shareXFiles([xFile], text: 'Compartir imagen');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al compartir: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  void _showImageInfo() {
    final currentImagePath = widget.imageList?[_currentIndex] ?? widget.imagePath;
    final file = File(currentImagePath);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información de la imagen'),
        content: FutureBuilder<FileStat>(
          future: file.stat(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stat = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${file.path.split('/').last}'),
                  const SizedBox(height: 8),
                  Text('Tamaño: ${_formatBytes(stat.size)}'),
                  const SizedBox(height: 8),
                  Text('Modificado: ${_formatDate(stat.modified)}'),
                  const SizedBox(height: 8),
                  Text('Ruta: ${file.path}'),
                  const SizedBox(height: 8),
                  FutureBuilder<void>(
                    future: _getImageDimensions(file),
                    builder: (context, dimensionSnapshot) {
                      return const Text('Cargando dimensiones...');
                    },
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
  
  void _setAsWallpaper() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función disponible en versiones futuras'),
      ),
    );
  }
  
  void _rotateImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función disponible en versiones futuras'),
      ),
    );
  }
  
  Future<void> _getImageDimensions(File file) async {
    // En una implementación completa, aquí cargarías la imagen y obtendrías sus dimensiones
    await Future.delayed(const Duration(milliseconds: 500));
  }
  
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}