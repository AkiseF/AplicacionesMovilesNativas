import 'package:flutter/material.dart';

class InteractiveCircleWidget extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color circleColor;
  final Color borderColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;
  final double borderWidth;

  const InteractiveCircleWidget({
    super.key,
    required this.left,
    required this.top,
    required this.onTap,
    this.size = 80,
    this.circleColor = const Color.fromRGBO(255, 255, 255, 0.8),
    this.borderColor = Colors.white,
    this.iconColor = Colors.green,
    this.icon = Icons.zoom_in,
    this.borderWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: size * 0.5, // Icono será 50% del tamaño del círculo
          ),
        ),
      ),
    );
  }
}