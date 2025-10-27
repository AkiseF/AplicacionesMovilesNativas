import 'package:flutter/material.dart';
import '../../widgets/InteractiveCircleWidget.dart';
import 'SubAlterScreen_visitante.dart';

class SubAlterScreen extends StatelessWidget {
  const SubAlterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/base_2_zoom.jpg'),
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
                    // Botón de regreso en la parte superior
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Título en la parte inferior
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '🔍 Vista detallada del garambullo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
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
          
          // Círculo interactivo en el centro para mostrar información del visitante
          InteractiveCircleWidget(
            left: MediaQuery.of(context).size.width / 2 - 40, // Centrado horizontalmente
            top: MediaQuery.of(context).size.height / 2 - 40, // Centrado verticalmente
            size: 80,
            icon: Icons.visibility, // Icono de ojo para "ver visitante"
            onTap: () {
              // Mostrar la pantalla flotante del visitante
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.3), // Fondo semi-transparente
                builder: (BuildContext context) {
                  return const SubAlterScreenVisitante();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}