import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _guessWhoPosition;
  late Animation<double> _attackOnTitanPosition;
  late Animation<double> _guessWhoScale;
  late Animation<double> _attackOnTitanScale;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3500), // Duración total más larga
      vsync: this,
    );

    // Animaciones de posición - ahora cubren todo el rango
    _guessWhoPosition = Tween<double>(
      begin: -400.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut), // Más temprano
      ),
    );

    _attackOnTitanPosition = Tween<double>(
      begin: 400.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.elasticOut), // Más temprano
      ),
    );

    // Animaciones de escala
    _guessWhoScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut), // Más temprano
      ),
    );

    _attackOnTitanScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut), // Más temprano
      ),
    );

    // Animación de desvanecimiento - ahora más tarde
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn), // Comienza más tarde
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // Solo UNA llamada a forward() - la animación completa en una pasada
    await _controller.forward();

    // Navegar al home inmediatamente después de completar la animación
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Guess Who Logo con posición y escala
                  Transform.translate(
                    offset: Offset(0, _guessWhoPosition.value),
                    child: Transform.scale(
                      scale: _guessWhoScale.value,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 200,
                        child: Image.asset(
                          'assets/images/guess-who-logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Attack on Titan Logo con posición y escala
                  Transform.translate(
                    offset: Offset(0, _attackOnTitanPosition.value),
                    child: Transform.scale(
                      scale: _attackOnTitanScale.value,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: 80,
                        child: Image.asset(
                          'assets/images/Attack-on-Titan-Logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}