import 'package:flutter/material.dart';
import '../../widgets/InteractiveCircleWidget.dart';
import 'SubBase3Screen_PVB3Detalle.dart';

class SubBase3Screen extends StatelessWidget {
  const SubBase3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/planta_visitante_b3_2.jpg'),
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
                        '🔍 Detalle del Ecosistema',
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

          // Círculo interactivo
          InteractiveCircleWidget(
            left: MediaQuery.of(context).size.width * 0.7 - 40, // 70% del ancho
            top: MediaQuery.of(context).size.height * 0.65 - 40, // 65% del alto
            size: 80,
            icon: Icons.visibility, // Icono de visibilidad para detalle
            onTap: () {
              // Mostrar la pantalla flotante del detalle PVB3
              showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.3),
                builder: (BuildContext context) {
                  return const SubBase3ScreenPVB3Detalle();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}