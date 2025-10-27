import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.0),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Guess Who logo (más grande, arriba)
            Positioned(
              top:10,
              left: 0,
              right: 0,
              child: Container(
                height: 270, 
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  'assets/images/guess-who-logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // Attack on Titan logo (más pequeño, centrado debajo)
            Positioned(
              top: 225,
              left: 100,
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Image.asset(
                  'assets/images/Attack-on-Titan-Logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}