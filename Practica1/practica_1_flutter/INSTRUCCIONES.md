# Práctica 1 - Flutter

Este es un proyecto Flutter básico que muestra los elementos fundamentales de la UI.

## Cómo ejecutar el proyecto

### Método 1: Usar el script de batch (Recomendado para Windows)
1. Navega al directorio `practica_1_flutter`
2. Ejecuta el archivo `run_flutter.bat`

### Método 2: Usar PowerShell
1. Navega al directorio `practica_1_flutter`
2. Ejecuta: `.\run_flutter.ps1`

### Método 3: Comando directo de Flutter
1. Asegúrate de estar en el directorio `practica_1_flutter` (donde está el archivo `pubspec.yaml`)
2. Ejecuta: `flutter run`

### Método 4: Desde VS Code
1. Abre el directorio `practica_1_flutter` en VS Code
2. Presiona `F5` o usa el botón "Run and Debug"
3. O usa `Ctrl+Shift+P` y busca "Flutter: Launch Emulator"

## Estructura del proyecto

```
practica_1_flutter/
├── lib/
│   └── main.dart          # Archivo principal de la aplicación
├── pubspec.yaml           # Dependencias y configuración del proyecto
├── run_flutter.bat        # Script para ejecutar en Windows
├── run_flutter.ps1        # Script de PowerShell
└── .vscode/               # Configuración de VS Code
    ├── settings.json
    ├── launch.json
    └── tasks.json
```

## Funcionalidad

La aplicación muestra:
- Un contador que se incrementa al presionar el botón flotante
- Interfaz de usuario básica con Material Design
- Texto en español

## Dispositivos soportados

- Windows Desktop
- Web (Edge/Chrome)
- Android (si está configurado)
- iOS (si está configurado)