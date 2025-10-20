import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

/// Página para visualizar archivos de texto
class TextViewerPage extends StatefulWidget {
  final String filePath;
  final String fileName;
  
  const TextViewerPage({
    super.key,
    required this.filePath,
    required this.fileName,
  });
  
  @override
  State<TextViewerPage> createState() => _TextViewerPageState();
}

class _TextViewerPageState extends State<TextViewerPage> {
  String? _content;
  bool _isLoading = true;
  String? _error;
  double _fontSize = 14.0;
  bool _wordWrap = true;
  bool _isEditable = false;
  late TextEditingController _textController;
  bool _hasUnsavedChanges = false;
  
  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _loadFileContent();
  }
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  Future<void> _loadFileContent() async {
    try {
      final file = File(widget.filePath);
      final content = await file.readAsString();
      
      setState(() {
        _content = content;
        _textController.text = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al leer el archivo: $e';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _saveFile() async {
    try {
      final file = File(widget.filePath);
      await file.writeAsString(_textController.text);
      
      setState(() {
        _content = _textController.text;
        _hasUnsavedChanges = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Archivo guardado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) {
        if (!didPop && _hasUnsavedChanges) {
          _showUnsavedChangesDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.fileName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            // Control de tamaño de fuente
            IconButton(
              icon: const Icon(Icons.text_decrease),
              onPressed: () {
                setState(() {
                  _fontSize = (_fontSize - 2).clamp(8.0, 32.0);
                });
              },
              tooltip: 'Reducir texto',
            ),
            IconButton(
              icon: const Icon(Icons.text_increase),
              onPressed: () {
                setState(() {
                  _fontSize = (_fontSize + 2).clamp(8.0, 32.0);
                });
              },
              tooltip: 'Aumentar texto',
            ),
            // Toggle word wrap
            IconButton(
              icon: Icon(_wordWrap ? Icons.wrap_text : Icons.notes),
              onPressed: () {
                setState(() {
                  _wordWrap = !_wordWrap;
                });
              },
              tooltip: _wordWrap ? 'Desactivar ajuste' : 'Activar ajuste',
            ),
            // Toggle edición
            if (_content != null)
              IconButton(
                icon: Icon(_isEditable ? Icons.visibility : Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditable = !_isEditable;
                    if (!_isEditable) {
                      _textController.text = _content!;
                      _hasUnsavedChanges = false;
                    }
                  });
                },
                tooltip: _isEditable ? 'Solo lectura' : 'Editar',
              ),
            // Guardar
            if (_isEditable && _hasUnsavedChanges)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _saveFile,
                tooltip: 'Guardar',
              ),
            // Compartir
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareFile,
              tooltip: 'Compartir',
            ),
            // Más opciones
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'copy':
                    _copyToClipboard();
                    break;
                  case 'info':
                    _showFileInfo();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'copy',
                  child: Row(
                    children: [
                      Icon(Icons.copy),
                      SizedBox(width: 8),
                      Text('Copiar todo'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'info',
                  child: Row(
                    children: [
                      Icon(Icons.info),
                      SizedBox(width: 8),
                      Text('Información'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: _buildBody(theme),
      ),
    );
  }
  
  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Volver'),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: _isEditable ? _buildEditor(theme) : _buildViewer(theme),
    );
  }
  
  Widget _buildViewer(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: _wordWrap ? Axis.vertical : Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: _wordWrap ? Axis.horizontal : Axis.vertical,
        child: SelectableText(
          _content!,
          style: TextStyle(
            fontSize: _fontSize,
            fontFamily: 'monospace',
            height: 1.4,
          ),
        ),
      ),
    );
  }
  
  Widget _buildEditor(ThemeData theme) {
    return TextField(
      controller: _textController,
      maxLines: null,
      expands: true,
      style: TextStyle(
        fontSize: _fontSize,
        fontFamily: 'monospace',
        height: 1.4,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Contenido del archivo...',
        contentPadding: EdgeInsets.zero,
      ),
      onChanged: (value) {
        if (!_hasUnsavedChanges) {
          setState(() {
            _hasUnsavedChanges = true;
          });
        }
      },
    );
  }
  
  Future<void> _shareFile() async {
    try {
      final xFile = XFile(widget.filePath);
      await Share.shareXFiles([xFile], text: 'Compartir ${widget.fileName}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al compartir: $e')),
        );
      }
    }
  }
  
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _textController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contenido copiado al portapapeles')),
    );
  }
  
  void _showFileInfo() {
    final file = File(widget.filePath);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información del archivo'),
        content: FutureBuilder<FileStat>(
          future: file.stat(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final stat = snapshot.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${widget.fileName}'),
                  const SizedBox(height: 8),
                  Text('Tamaño: ${_formatBytes(stat.size)}'),
                  const SizedBox(height: 8),
                  Text('Modificado: ${stat.modified}'),
                  const SizedBox(height: 8),
                  Text('Ruta: ${widget.filePath}'),
                  const SizedBox(height: 8),
                  Text('Líneas: ${_textController.text.split('\n').length}'),
                  const SizedBox(height: 8),
                  Text('Caracteres: ${_textController.text.length}'),
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
  
  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambios sin guardar'),
        content: const Text('¿Deseas guardar los cambios antes de salir?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              Navigator.of(context).pop(); // Cerrar página
            },
            child: const Text('Descartar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Cerrar diálogo
              await _saveFile();
              if (mounted) {
                Navigator.of(context).pop(); // Cerrar página
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
  
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}