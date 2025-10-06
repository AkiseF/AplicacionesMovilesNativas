import 'package:flutter/material.dart';
import '../../widgets/InteractiveCircleWidget.dart';
import 'Base3Screen_visitante.dart';
import 'SubBase3Screen.dart';
import 'SubBase3Screen_Visitante1.dart';
import 'SubBase3Screen_Visitante2.dart';
import 'SubBase3Screen_Visitante5.dart';

class Base3Screen extends StatelessWidget {
  const Base3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo que ocupa toda la pantalla
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/planta_base_3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Overlay semi-transparente
          Container(
            width: double.infinity,
            height: double.infinity,
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
          ),
          
          // Contenido con SafeArea
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Título centrado en la parte inferior
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '🌿 Ecosistema del Garambullo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Círculo interactivo con lupa - Navegar a SubBase3Screen
          InteractiveCircleWidget(
            left: MediaQuery.of(context).size.width * 0.20 - 40, // 20% del ancho
            top: MediaQuery.of(context).size.height * 0.6 - 40, // 60% del alto
            size: 80,
            icon: Icons.zoom_in, // Icono de lupa
            onTap: () {
              // Navegar a SubBase3Screen (pantalla de visitantes del ecosistema)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubBase3Screen()),
              );
            },
          ),
          
          // Círculo interactivo con ojo - Mostrar información del visitante principal
          InteractiveCircleWidget(
            left: MediaQuery.of(context).size.width * 0.85 - 40, // 85% del ancho
            top: MediaQuery.of(context).size.height * 0.7 - 40, // 70% del alto
            size: 80,
            icon: Icons.visibility, // Icono de ojo
            onTap: () {
              // Mostrar la pantalla flotante del visitante principal
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.3),
                builder: (BuildContext context) {
                  return const Base3ScreenVisitante();
                },
              );
            },
          ),

          // Primer círculo interactivo - Visitante 1 (izquierda)
          InteractiveCircleWidget(
            left: MediaQuery.of(context).size.width * 0.2 - 40, // 20% del ancho
            top: MediaQuery.of(context).size.height * 0.35 - 40, // 35% del alto
            size: 80,
            icon: Icons.visibility,
            onTap: () {
              // Mostrar la pantalla flotante del visitante 1
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.3),
                builder: (BuildContext context) {
                  return const SubBase3ScreenVisitante1();
                },
              );
            },
          ),
          
          // Segundo círculo interactivo - Visitante 2 (derecha)
          InteractiveCircleWidget(
            left: MediaQuery.of(context).size.width * 0.8 - 40, // 80% del ancho
            top: MediaQuery.of(context).size.height * 0.55 - 40, // 55% del alto
            size: 80,
            icon: Icons.visibility,
            onTap: () {
              // Mostrar la pantalla flotante del visitante 2
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.3),
                builder: (BuildContext context) {
                  return const SubBase3ScreenVisitante2();
                },
              );
            },
          ),

          // Tercer círculo interactivo - Visitante 5 (centro-abajo)
          InteractiveCircleWidget(
            left: MediaQuery.of(context).size.width * 0.5 - 40, // 50% del ancho (centro)
            top: MediaQuery.of(context).size.height * 0.75 - 40, // 75% del alto
            size: 80,
            icon: Icons.visibility, // Icono de visibilidad 
            onTap: () {
              // Mostrar la pantalla flotante del visitante 5
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.3),
                builder: (BuildContext context) {
                  return const SubBase3ScreenVisitante5();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}