import 'package:flutter/material.dart';
import 'SubAlterScreen.dart';
import 'Base2Screen_visitante.dart';
import '../../widgets/InteractiveCircleWidget.dart';

class AlterScreen extends StatelessWidget {
  const AlterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/planta_base_2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Overlay semi-transparente para mejorar la legibilidad del texto
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Contenido principal
                Column(
                  children: [
                    const Spacer(),
                    // Mensaje en la parte inferior
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '🌱 ¡Descubre más secretos del garambullo!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                // Círculo interactivo posicionado por coordenadas
                InteractiveCircleWidget(
                  left: MediaQuery.of(context).size.width * 0.5 - 140, // Centro horizontal (ajustado por el radio)
                  top: MediaQuery.of(context).size.height * 0.5, // 50% desde arriba
                  size: 80,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubAlterScreen(),
                      ),
                    );
                  },
                ),
                // Segundo círculo interactivo para la nueva pantalla visitante
                InteractiveCircleWidget(
                  left: MediaQuery.of(context).size.width * 0.7 - 40, // Posición diferente
                  top: MediaQuery.of(context).size.height * 0.65, // Posición más arriba
                  size: 80,
                  icon: Icons.visibility, // Icono de lupa
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false, // Permite que el fondo sea transparente
                        barrierColor: Colors.black.withOpacity(0.3), // Fondo semi-transparente
                        pageBuilder: (context, animation, secondaryAnimation) => const Base2ScreenVisitante(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}