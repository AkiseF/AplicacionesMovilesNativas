import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/utils/thumbnail_cache.dart';
import '../../domain/entities/file_entity.dart';
import '../../core/constants/app_constants.dart';

/// Widget que muestra thumbnail con caché para imágenes
class ThumbnailWidget extends StatefulWidget {
  final FileEntity file;
  final double size;
  final Widget? fallbackWidget;

  const ThumbnailWidget({
    super.key,
    required this.file,
    this.size = 40,
    this.fallbackWidget,
  });

  @override
  State<ThumbnailWidget> createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {
  Uint8List? _thumbnail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    if (!widget.file.isImage) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final thumbnail = await ThumbnailCache.instance.getThumbnail(widget.file.path);
      if (mounted) {
        setState(() {
          _thumbnail = thumbnail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_thumbnail != null) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: MemoryImage(_thumbnail!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // Fallback para cuando no hay thumbnail
    return widget.fallbackWidget ?? _buildDefaultIcon();
  }

  Widget _buildDefaultIcon() {
    IconData iconData;
    Color? color;

    if (widget.file.isDirectory) {
      iconData = Icons.folder;
      color = Colors.blue[700];
    } else {
      switch (widget.file.type) {
        case FileType.image:
          iconData = Icons.image;
          color = Colors.green[700];
          break;
        case FileType.text:
          iconData = Icons.description;
          color = Colors.orange[700];
          break;
        case FileType.video:
          iconData = Icons.video_file;
          color = Colors.purple[700];
          break;
        case FileType.audio:
          iconData = Icons.audio_file;
          color = Colors.red[700];
          break;
        case FileType.document:
          iconData = Icons.description;
          color = Colors.blue[700];
          break;
        default:
          iconData = Icons.insert_drive_file;
          color = Colors.grey[700];
      }
    }

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: color?.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        size: widget.size * 0.6,
        color: color,
      ),
    );
  }
}