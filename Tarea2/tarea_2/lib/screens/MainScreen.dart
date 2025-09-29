import 'package:flutter/material.dart';
import '../widgets/InteractiveCircleWidget.dart';
import 'MainScreen_visitante.dart';
import 'SubMainScreen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo y contenido principal
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/planta_base_1.jpg'),
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
                child: Column(
                  children: [
                    // Título (imagen) en la parte superior
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Image.asset(
                          'assets/images/bienvenida.png',
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Instrucción en la parte inferior
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '👉 Desliza a la derecha para continuar...',
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
              ),
            ),
          ),
          
          // Círculo interactivo con lupa - Navegar a SubMainScreen
          InteractiveCircleWidget(
            left: MediaQuery.of(context).size.width * 0.8 - 40, // 80% del ancho
            top: MediaQuery.of(context).size.height * 0.35 - 40, // 35% del alto
            size: 80,
            onTap: () {
              // Navegar a SubMainScreen (pantalla de frutos)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubMainScreen()),
              );
            },
          ),
          
          // Círculo interactivo con ojo - Mostrar información del visitante
          InteractiveCircleWidget(
            left: MediaQuery.of(context).size.width * 0.2 - 40, // 20% del ancho
            top: MediaQuery.of(context).size.height * 0.75 - 40, // 75% del alto
            size: 80,
            icon: Icons.visibility, // Icono de ojo
            onTap: () {
              // Mostrar la pantalla flotante del visitante
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.3),
                builder: (BuildContext context) {
                  return const MainScreenVisitante();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}