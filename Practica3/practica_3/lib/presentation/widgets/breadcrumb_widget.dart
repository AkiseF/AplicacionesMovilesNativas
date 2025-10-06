import 'package:flutter/material.dart';

/// Widget para mostrar el breadcrumb de navegación
class BreadcrumbWidget extends StatelessWidget {
  final List<String> breadcrumbs;
  final Function(String) onNavigate;

  const BreadcrumbWidget({
    super.key,
    required this.breadcrumbs,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildBreadcrumbItems(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBreadcrumbItems(BuildContext context) {
    final items = <Widget>[];
    
    for (int i = 0; i < breadcrumbs.length; i++) {
      final isLast = i == breadcrumbs.length - 1;
      final path = _buildPathForIndex(i);
      
      items.add(
        InkWell(
          onTap: isLast ? null : () => onNavigate(path),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isLast 
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.transparent,
            ),
            child: Text(
              breadcrumbs[i],
              style: TextStyle(
                color: isLast 
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primary,
                fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
      
      if (!isLast) {
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              Icons.chevron_right,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        );
      }
    }
    
    return items;
  }

  String _buildPathForIndex(int index) {
    if (breadcrumbs.isEmpty || breadcrumbs[0] == 'Inicio') {
      return '/';
    }
    
    return '/${breadcrumbs.take(index + 1).join('/')}';
  }
}