# Guess Who - Attack on Titan Edition

Un juego de "Adivina ¿Quién Es?" basado en los personajes de Attack on Titan, desarrollado en Flutter.

### Elaborado por
- Martín Cortés Buendia
- José Ramón Parra Mancilla
- Profesor: Gabriel Hurtado Áviles

## Características

### 🎮 Modos de Juego
- **Un Jugador**: Juega contra una IA inteligente
- **Dos Jugadores**: Conexión por Bluetooth para jugar con amigos

### 🎯 Mecánicas de Juego
- **Tablero 4x4**: 16 personajes seleccionados aleatoriamente
- **Sistema de Turnos**: Indicación visual clara del jugador activo
- **Carrusel de Preguntas**: 8 preguntas estratégicas categorizadas
- **Eliminación Manual**: Control total sobre qué personajes descartar
- **Sistema de Puntuación**: Conteo de victorias para múltiples partidas

### 🔧 Funcionalidades Técnicas
- **Validación de Movimientos**: Verificación de reglas del juego
- **Selección Aleatoria**: Sin repetición de personajes en el tablero
- **Interfaz Intuitiva**: Diseño temático de Attack on Titan
- **Estado Persistente**: Manejo completo del estado del juego

## Cómo Jugar

### 1. Selección de Personaje
- Al inicio de cada partida, selecciona tu personaje secreto tocándolo en el tablero
- Este será el personaje que tu oponente debe adivinar

### 2. Hacer Preguntas
- Usa el carrusel de preguntas en la parte inferior de la pantalla
- Las preguntas están categorizadas: Físico, Estado, Habilidades, Relaciones
- Basándote en la respuesta, elimina manualmente los personajes que no coincidan

### 3. Eliminar Personajes
- Toca cualquier personaje para ver las opciones
- Selecciona "Eliminar Personaje" si estás seguro de que NO es el del oponente
- Los personajes eliminados aparecerán tachados en rojo

### 4. Hacer tu Adivinanza Final
- Cuando estés seguro, toca un personaje y selecciona "¡Este es mi respuesta final!"
- Si aciertas, ganas la ronda
- Si fallas, el turno pasa al oponente

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos
│   ├── character.dart       # Modelo del personaje
│   ├── question.dart        # Modelo de preguntas
│   └── game_session.dart    # Modelo de sesión de juego
├── screens/                 # Pantallas de la aplicación
│   ├── home_screen.dart     # Pantalla principal
│   ├── game_screen.dart     # Pantalla de juego
│   └── bluetooth_setup_screen.dart # Configuración Bluetooth
├── services/                # Servicios de la aplicación
│   ├── character_service.dart    # Servicio de personajes
│   ├── ai_service.dart          # IA para modo un jugador
│   └── bluetooth_service.dart   # Servicio Bluetooth
├── providers/               # Gestión de estado
│   └── game_provider.dart   # Proveedor del estado del juego
└── widgets/                 # Componentes reutilizables
    ├── character_card.dart  # Tarjeta de personaje
    ├── question_carousel.dart # Carrusel de preguntas
    └── game_status_bar.dart # Barra de estado del juego
```

## Instalación y Configuración

### Prerrequisitos
- Flutter SDK (versión 3.9.2 o superior)
- Dart SDK
- Android Studio / VS Code con extensiones de Flutter

### Dependencias Principales
- `flutter_bluetooth_serial`: Para conexión Bluetooth
- `permission_handler`: Para manejo de permisos
- `cached_network_image`: Para carga de imágenes
- `shared_preferences`: Para almacenamiento local
- `provider`: Para gestión de estado

### Pasos de Instalación

1. Clona el repositorio:
   ```bash
   git clone <repository-url>
   cd practica4
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## Datos de Personajes

Los personajes se cargan desde `data/attackontitan.json` que incluye:
- 32 personajes de Attack on Titan
- Información detallada: edad, estado, características físicas
- Afiliaciones, habilidades y relaciones
- Datos para las preguntas del juego

## Características de la IA

La IA incluye estrategias inteligentes:
- Selección de preguntas que dividen el conjunto de personajes por la mitad
- Eliminación automática basada en respuestas lógicas
- Decisiones de adivinanza cuando quedan pocos personajes
- Tiempo de "pensamiento" simulado para mejor UX

## Funcionalidad Bluetooth

- Descubrimiento automático de dispositivos
- Conexión segura entre dispositivos
- Sincronización del estado del juego
- Manejo de desconexiones

## Tema Visual

Diseño inspirado en Attack on Titan:
- Paleta de colores rojo oscuro y beige
- Iconografía temática
- Animaciones suaves
- Interfaz intuitiva y responsive

## Contribución

Este es un proyecto educativo. Las contribuciones son bienvenidas:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto es para fines educativos. Los personajes de Attack on Titan pertenecen a sus respectivos propietarios.

## Autores

- Desarrollado como proyecto educativo de Flutter y Dart
- Basado en el popular juego "Guess Who" con temática de Attack on Titan
