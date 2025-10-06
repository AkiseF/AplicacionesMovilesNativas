# Práctica 2 - Aplicación Móvil Básica

## Objetivo
Implementar la persistencia de datos a través de SharedPreferences para guardar las preferencias del usuario. Donde se añadirá una funcionalidad que permita al usuario seleccionar y aplicar un tema visual (claro u oscuro) a la aplicación, asegurando que esta elección se mantenga entre diferentes sesiones de uso.

## Descripción del Proyecto
**"Aventura Interactiva del garambullo"** es una aplicación Flutter que presenta una experiencia educativa sobre el garambullo (cactácea nativa mexicana) a través de múltiples pantallas navegables con elementos interactivos y transiciones suaves.

### Características Principales
- 🌱 **Pantalla principal**: Bienvenida con imagen personalizada
- 🔄 **Navegación por gestos**: Deslizamiento horizontal entre pantallas
- 🎯 **Elementos interactivos**: Círculos táctiles para navegación avanzada
- 📱 **Indicadores de página**: Animación SlideEffect para mejor UX
- 🖼️ **Diseño inmersivo**: Imágenes de fondo con overlays graduales
- 🏗️ **Arquitectura modular**: Widgets separados y reutilizables

## Decisiones de Diseño y Mecanismos de Transición

### 🎨 Decisiones de Diseño

#### **1. Arquitectura Modular**
- **Separación de responsabilidades**: Cada pantalla es un widget independiente
- **Widgets reutilizables**: `PageIndicatorWidget` e `InteractiveCircleWidget`
- **Mantenibilidad**: Código organizado en carpetas `screens/` y `widgets/`

#### **2. Diseño Visual Inmersivo**
- **Imágenes de fondo completo**: `BoxFit.cover` para pantalla completa
- **Overlays graduales**: `LinearGradient` para mejor legibilidad del texto
- **Tipografía contrastante**: Texto blanco con sombras negras
- **SafeArea**: Respeta las áreas seguras del dispositivo

#### **3. Experiencia de Usuario (UX)**
- **Navegación intuitiva**: Gestos de deslizamiento horizontal
- **Feedback visual**: Indicadores de página con animación
- **Elementos interactivos claros**: Círculos con iconos y sombras
- **Instrucciones contextuales**: Mensajes que guían al usuario

### 🔄 Mecanismos de Transición

#### **1. PageView para Navegación Principal**
```dart
PageView(
  controller: _pageController,
  children: _screens,
)
```
- **Transición**: Deslizamiento suave entre pantallas principales
- **Control**: `PageController` para gestión programática
- **Responsivo**: Adaptable a diferentes tamaños de pantalla

#### **2. SlideEffect en Indicadores**
```dart
SlideEffect(
  dotHeight: 12,
  dotWidth: 12,
  type: SlideType.normal,
)
```
- **Animación**: Indicador deslizante entre puntos de página
- **Librería**: `smooth_page_indicator` para animaciones profesionales
- **Personalización**: Colores y tamaños configurables

#### **3. Navigator.push para Navegación Avanzada**
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SubAlterScreen()),
)
```
- **Transición**: Animación estándar de material design
- **Stack**: Mantiene historial de navegación
- **Retorno**: Botón back automático en nueva pantalla

## Implementación de Temas con SharedPreferences

### 1. Servicio de Temas (`lib/services/theme_service.dart`)

**Características principales:**
- **Persistencia**: Utiliza SharedPreferences para guardar la preferencia del usuario
- **Notificación de cambios**: Extiende ChangeNotifier para actualizar la UI automáticamente
- **Colores específicos**: Define esquemas de colores para cada componente de la aplicación

**Colores definidos:**
- **Círculos interactivos**: Color de fondo, borde e icono
- **PageIndicator**: Color de puntos activos e inactivos
- **Pantallas Base2**: Colores verde para tema claro, verde oscuro para tema oscuro
- **Pantallas Base3**: Colores naranja para tema claro, naranja oscuro para tema oscuro
- **SubAlterScreen**: Colores marrón para tema claro, marrón oscuro para tema oscuro

### 2. Widget de Control de Tema (`lib/widgets/ThemeToggleWidget.dart`)

**Características:**
- **Switch interactivo**: Permite cambiar entre temas claro y oscuro
- **Iconos representativos**: Sol para tema claro, luna para tema oscuro
- **Estilo consistente**: Diseño que se adapta al tema actual
- **Posicionamiento**: Ubicado en la esquina superior derecha de MainScreen

## Esquemas de Colores

### Tema Claro
```dart
// Círculos interactivos
circleColor: Color.fromRGBO(255, 255, 255, 0.8)
circleBorderColor: Colors.white
circleIconColor: Color.fromARGB(255, 19, 168, 14)

// PageIndicator
pageIndicatorDotColor: Color.fromARGB(255, 200, 200, 200)
pageIndicatorActiveDotColor: Color.fromARGB(255, 76, 175, 80)

// Base2, Base3, SubAlter y todas las pantallas (Verde unificado)
base2BackgroundColor: Color(0xFF4CAF50)
base2BorderColor: Color(0xFF2E7D32)
base3BackgroundColor: Color(0xFF4CAF50)
base3BorderColor: Color(0xFF2E7D32)
subAlterBackgroundColor: Color(0xFF4CAF50)
subAlterBorderColor: Color(0xFF2E7D32)
```

### Tema Oscuro
```dart
// Círculos interactivos
circleColor: Color.fromRGBO(80, 80, 80, 0.9)
circleBorderColor: Color(0xFFBB86FC)
circleIconColor: Color(0xFF03DAC6)

// PageIndicator
pageIndicatorDotColor: Color.fromARGB(255, 100, 100, 100)
pageIndicatorActiveDotColor: Color(0xFFBB86FC)

// Base2, Base3, SubAlter y todas las pantallas (Esquema oscuro unificado)
base2BackgroundColor: Color.fromARGB(255, 72, 77, 73)
base2BorderColor: Color.fromARGB(255, 140, 89, 203)
base3BackgroundColor: Color.fromARGB(255, 72, 77, 73)
base3BorderColor: Color.fromARGB(255, 140, 89, 203)
subAlterBackgroundColor: Color.fromARGB(255, 72, 77, 73)
subAlterBorderColor: Color.fromARGB(255, 140, 89, 203)
```

## 🎨 Capturas de Pantalla

<div align="center">

### Modo claro
  | | | | |
  |:---:|:---:|:---:|:---:|
  | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0019.jpg" alt="Captura 1" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0020.jpg" alt="Captura 2" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0023.jpg" alt="Captura 3" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0024.jpg" alt="Captura 4" width="200"> |
  | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0025.jpg" alt="Captura 5" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0026.jpg" alt="Captura 6" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0027.jpg" alt="Captura 7" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0028.jpg" alt="Captura 8" width="200"> |
  | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0029.jpg" alt="Captura 9" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0030.jpg" alt="Captura 10" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0031.jpg" alt="Captura 11" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0032.jpg" alt="Captura 12" width="200"> |
  | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0033.jpg" alt="Captura 13" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0034.jpg" alt="Captura 14" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0035.jpg" alt="Captura 15" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_claro/IMG-20251006-WA0036.jpg" alt="Captura 16" width="200"> |

---

### Modo oscuro
  | | | | |
  |:---:|:---:|:---:|:---:|
  | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0008.jpg" alt="Captura 1" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0011.jpg" alt="Captura 2" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0012.jpg" alt="Captura 3" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0013.jpg" alt="Captura 4" width="200"> |
  | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0014.jpg" alt="Captura 5" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0015.jpg" alt="Captura 6" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0016.jpg" alt="Captura 7" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0017.jpg" alt="Captura 8" width="200"> |
  | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0018.jpg" alt="Captura 9" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0021.jpg" alt="Captura 10" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0022.jpg" alt="Captura 11" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0037.jpg" alt="Captura 12" width="200"> |
  | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0038.jpg" alt="Captura 13" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0039.jpg" alt="Captura 14" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0040.jpg" alt="Captura 15" width="200"> | <img src="practica_2/assets/images/capturas_ejecucion/modo_oscuro/IMG-20251006-WA0041.jpg" alt="Captura 16" width="200"> |

--- 
</div>

## 🎬 Demostración en Video

<div align="center">
    <img src="practica_2/assets/images/capturas_ejecucion/video_demostracion.gif" alt="Video Demostración" width="300">
    <br>
    <em>Flujo completo de la aplicación mostrando su comportamiento</em>
</div>

## Retos y Soluciones

### 🚧 Reto 1: Gestión de Assets e Imágenes
**Problema**: Las imágenes inicialmente estaban en una carpeta externa al proyecto Flutter.
**Solución**: 
- Creamos la estructura `assets/images/` dentro del proyecto
- Copiamos todas las imágenes al directorio correcto
- Configuramos `pubspec.yaml` para incluir los assets
- Utilizamos rutas relativas en `AssetImage()`

### 🚧 Reto 2: Fondo Transparente en Indicadores
**Problema**: El contenedor de los indicadores de página mostraba fondo blanco por defecto.
**Solución**:
- Aplicamos `color: Colors.transparent` explícitamente
- Creamos widget separado para mejor control del styling
- Implementamos `smooth_page_indicator` para efectos profesionales

### 🚧 Reto 3: Posicionamiento Preciso de Elementos Interactivos
**Problema**: Necesitábamos posicionar círculos interactivos en coordenadas específicas.
**Solución**:
- Implementamos `Positioned` widget con coordenadas exactas
- Creamos `InteractiveCircleWidget` con parámetros de posición
- Utilizamos `MediaQuery` para cálculos responsive
- Añadimos `Stack` layout para superposición de elementos

### 🚧 Reto 4: Navegación Híbrida (Gestos + Toque)
**Problema**: Combinar navegación por deslizamiento con navegación por toque.
**Solución**:
- `PageView` para navegación principal horizontal
- `Navigator.push` para navegación vertical/profunda
- Mantenimiento de contexto y estado entre pantallas
- Botones de retorno consistentes

### 🚧 Reto 5: Arquitectura Modular y Mantenible
**Problema**: Código inicialmente centralizado en `main.dart` dificultaba el mantenimiento.
**Solución**:
- Refactorización a arquitectura por capas (`screens/`, `widgets/`)
- Separación de responsabilidades por funcionalidad
- Widgets reutilizables y configurables
- Imports organizados y documentación clara

## Estructura del Proyecto

```
lib/
├── main.dart                     # Aplicación principal y navegación PageView
├── screens/
│   ├── MainScreen.dart          # Pantalla inicial con imagen de bienvenida
│   ├── AlterScreen.dart         # Segunda pantalla con círculo interactivo
│   └── SubAlterScreen.dart      # Pantalla de detalle con zoom
└── widgets/
    ├── PageIndicatorWidget.dart      # Indicador de páginas con SlideEffect
    └── InteractiveCircleWidget.dart  # Círculo interactivo posicionable

assets/images/
├── bienvenida.png               # Imagen de título principal
├── planta_base_1.jpg           # Fondo de pantalla principal
├── planta_base_2.jpg           # Fondo de segunda pantalla
└── base_2_zoom.jpg             # Imagen de detalle con zoom
```

## Instrucciones de Instalación y Ejecución

### Prerrequisitos
- Flutter SDK (versión 3.9.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Emulador Android o dispositivo físico
- Git