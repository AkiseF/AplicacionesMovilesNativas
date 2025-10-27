/*
EJEMPLOS DE USO DEL SISTEMA DE TEMAS
====================================

1. Para cambiar el modo claro/oscuro programáticamente:
   Provider.of<ThemeProvider>(context, listen: false).toggleDarkMode();

2. Para cambiar a un tema específico:
   Provider.of<ThemeProvider>(context, listen: false).setTheme(AppTheme.blue);

3. Para usar ThemedCard en nuevos widgets:
   ThemedCard(
     onTap: () => print('Card tocada'),
     padding: const EdgeInsets.all(16),
     showThemeAccent: true, // Muestra bordes y gradientes del tema
     child: Text('Contenido de la card'),
   )

4. Para usar ThemedGameModeCard (prediseñada):
   ThemedGameModeCard(
     title: 'Mi Modo',
     subtitle: 'Descripción del modo',
     icon: Icons.gamepad,
     onTap: () => navigateToGame(),
   )

5. Para obtener colores del tema actual:
   final themeProvider = Provider.of<ThemeProvider>(context);
   final primaryColor = Theme.of(context).primaryColor;
   final isDark = themeProvider.isDarkMode;

6. Estructura básica para nuevas pantallas con tema:
   Consumer<ThemeProvider>(
     builder: (context, themeProvider, child) {
       return Scaffold(
         body: Container(
           decoration: BoxDecoration(
             gradient: LinearGradient(
               begin: Alignment.topCenter,
               end: Alignment.bottomCenter,
               colors: themeProvider.getGradientColors(),
             ),
           ),
           child: YourContent(),
         ),
       );
     },
   )

CONFIGURACIÓN DE TEMAS DISPONIBLES:

1. AppTheme.red (Stationary Guard)
   - Color: #AA281A (Rojo carmesí)
   - Icono: shield (escudo)
   
2. AppTheme.blue (Scouting Legion)  
   - Color: #10357B (Azul naval)
   - Icono: explore (explorar)
   
3. AppTheme.green (Military Police)
   - Color: #1D4F34 (Verde militar)
   - Icono: security (seguridad)

MODOS DE FONDO:
- Claro: Fondo beige (#F5F5DC)
- Oscuro: Fondo gris (#121212)
*/