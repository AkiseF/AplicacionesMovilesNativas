import 'package:flutter/material.dart';
import 'dart:async';

class ProgressIndicatorWidget extends StatefulWidget {
  final VoidCallback? onStart;
  final String? completedText;
  final String? loadingText;
  final String? initialText;

  const ProgressIndicatorWidget({
    super.key,
    this.onStart,
    this.completedText,
    this.loadingText,
    this.initialText,
  });

  @override
  State<ProgressIndicatorWidget> createState() => _ProgressIndicatorWidgetState();
}

class _ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget> {
  double _progressValue = 0.0;
  bool _isLoading = false;
  late String _statusText;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _statusText = widget.initialText ?? 'Presiona el botón para iniciar';
  }

  void _startProgress() {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _progressValue = 0.0;
      _statusText = widget.loadingText ?? 'Cargando...';
    });
    
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progressValue += 0.01;
        if (_progressValue >= 1.0) {
          _progressValue = 1.0;
          _isLoading = false;
          _statusText = widget.completedText ?? '¡Carga completada!';
          timer.cancel();
        }
      });
    });

    // Llamar callback si existe
    widget.onStart?.call();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
              _statusText,
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
    );
  }
}