# Práctica 1 - Android Nativo (Kotlin)

## Descripción de la aplicación
Esta aplicación es la versión nativa de Android desarrollada en Kotlin que implementa la misma funcionalidad que la versión Flutter. Demuestra conceptos fundamentales de desarrollo de aplicaciones Android nativas usando elementos de interfaz de usuario modernos.

## Funcionalidades
- Contador interactivo con botón de incremento
- Interfaz de usuario siguiendo Material Design Guidelines
- Preservación del estado durante rotaciones de pantalla
- Textos localizados en español
- ActionBar con título personalizado

## Estructura del proyecto
```
practica_1_android/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/example/practica1/
│   │       │   └── MainActivity.kt          # Actividad principal
│   │       ├── res/
│   │       │   ├── layout/
│   │       │   │   └── activity_main.xml    # Layout principal
│   │       │   ├── values/
│   │       │   │   ├── strings.xml          # Textos de la aplicación
│   │       │   │   ├── colors.xml           # Colores del tema
│   │       │   │   └── themes.xml           # Temas de Material Design
│   │       │   └── xml/                     # Archivos de configuración
│   │       └── AndroidManifest.xml          # Manifiesto de la aplicación
│   ├── build.gradle                         # Configuración de Gradle del módulo
│   └── proguard-rules.pro                   # Reglas de ProGuard
├── build.gradle                             # Configuración de Gradle del proyecto
├── settings.gradle                          # Configuración de módulos
└── gradle.properties                        # Propiedades de Gradle
```

## Tecnologías utilizadas
- **Kotlin**: Lenguaje de programación principal
- **Android SDK**: Framework de desarrollo de Android
- **Material Design Components**: Componentes de UI modernos
- **ConstraintLayout**: Sistema de layout flexible
- **AndroidX**: Librerías de soporte modernas

## Características implementadas

### MainActivity.kt
- **Gestión del estado**: Implementa `onSaveInstanceState` y `onRestoreInstanceState` para preservar el contador durante cambios de configuración
- **Binding de vistas**: Uso de `findViewById` para obtener referencias a los elementos de UI
- **Event Listeners**: Configuración de `OnClickListener` para el FloatingActionButton
- **Actualización de UI**: Método dedicado para actualizar la visualización del contador

### Layout (activity_main.xml)
- **ConstraintLayout**: Layout moderno y eficiente para posicionamiento
- **Material Design**: Uso de `FloatingActionButton` con el estilo de Material Design
- **Responsive Design**: Layout que se adapta a diferentes tamaños de pantalla
- **Accesibilidad**: Inclusion de `contentDescription` para mejores prácticas de accesibilidad

### Recursos
- **Strings.xml**: Externalización de textos para facilitar localización
- **Colors.xml**: Definición de paleta de colores consistente
- **Themes.xml**: Implementación de Material Design 3 con colores personalizados

## Instrucciones de compilación
1. Abrir el proyecto en Android Studio
2. Sincronizar el proyecto con los archivos Gradle
3. Ejecutar la aplicación en un dispositivo o emulador Android

## Comparación con Flutter
Esta implementación nativa en Android ofrece:
- Mayor control sobre el comportamiento específico de Android
- Mejor integración con APIs nativas de Android
- Rendimiento optimizado para la plataforma Android
- Acceso completo a todas las características del sistema Android

La funcionalidad es idéntica a la versión Flutter:
- Mismo título de aplicación
- Mismo texto descriptivo en español
- Misma funcionalidad de contador
- Mismo diseño visual con Material Design