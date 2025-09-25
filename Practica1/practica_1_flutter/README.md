# Práctica 1 - Flutter

Esta es la versión Flutter de la aplicación Android original que demuestra diferentes elementos de UI.

## Descripción

La aplicación está organizada en 5 pantallas principales, accesibles a través de una barra de navegación inferior:

### 1. Campos de Texto
- **TextField normal**: Campo de texto básico
- **TextField de contraseña**: Campo con texto oculto
- **TextField multilínea**: Campo que permite múltiples líneas
- **TextField numérico**: Campo que solo acepta números
- **Resultado dinámico**: Muestra en tiempo real los valores ingresados

### 2. Botones
- **ElevatedButton normal**: Botón estándar de Material Design
- **ElevatedButton de color**: Botón con color personalizado
- **IconButton**: Botón con icono
- **FloatingActionButton**: Botón flotante
- **Contador de clics**: Lleva la cuenta de todos los clics realizados
- **SnackBar**: Muestra mensajes temporales al hacer clic

### 3. Elementos de Selección
- **CheckboxListTile**: Para configuraciones de conectividad (WiFi, Bluetooth, Datos)
- **RadioListTile**: Para selección de tema (Claro, Oscuro, Automático)
- **SwitchListTile**: Para otras configuraciones (Notificaciones, Ubicación)
- **Resultado en tiempo real**: Muestra la configuración seleccionada

### 4. Listas
- **ListView.builder**: Lista eficiente de elementos
- **Card y ListTile**: Diseño atractivo para cada elemento
- **Interacción**: Al tocar un elemento se muestra un SnackBar
- **Avatares**: Cada elemento tiene un avatar numerado

### 5. Elementos de Información
- **CircularProgressIndicator**: Indicador de progreso circular
- **LinearProgressIndicator**: Barra de progreso lineal con porcentaje
- **Simulación de progreso**: Progreso animado de 0 a 100%
- **Carrusel de iconos**: Diferentes iconos que cambian al presionar un botón
- **Cards informativos**: Información organizada en tarjetas

## Cómo Ejecutar

1. Asegúrate de tener Flutter instalado
2. Navega al directorio del proyecto
3. Ejecuta: `flutter pub get`
4. Ejecuta: `flutter run`
