# 📱 Aplicaciones Móviles Nativas - Práctica 3

Este repositorio contiene la implementación de la **Práctica 3** del curso de Aplicaciones Móviles Nativas, desarrollada con **Flutter** y **Kotlin**.

## 📋 Descripción de la Aplicación

### **Gestor de Archivos Móvil**
Una aplicación completa de gestión de archivos para dispositivos Android que permite:

- 📂 **Exploración de archivos**: Navegación fluida por el sistema de archivos interno y externo
- 👁️ **Visualización de contenido**: Visor integrado para texto, imágenes y documentos
- ✏️ **Edición de archivos**: Editor de texto completo con funciones de guardado
- 🔍 **Búsqueda avanzada**: Filtros por nombre, tipo, fecha y tamaño
- ⭐ **Favoritos y recientes**: Sistema de marcadores y historial automático
- 🎨 **Temas personalizables**: Colores institucionales IPN/ESCOM con modo claro/oscuro
- 📱 **Interfaz responsive**: Adaptable a diferentes tamaños de pantalla y orientaciones

### **Características Técnicas**
- **Arquitectura**: Clean Architecture (Presentation, Domain, Data)
- **Patrones de diseño**: Repository, Use Case, Provider, Factory, Singleton
- **Base de datos**: SQLite para almacenamiento local persistente
- **Gestión de estado**: Provider pattern para reactividad
- **Optimización**: Sistema de caché para miniaturas y archivos recientes

## ⚙️ Requisitos del Sistema

### **Versiones Mínimas Requeridas**

| Componente | Versión Mínima | Versión Recomendada |
|------------|---------------|-------------------|
| **Android Studio** | 2023.1.1 (Hedgehog) | 2024.1.1 (Koala) |
| **Flutter SDK** | 3.9.2 | 3.24.0+ |
| **Dart SDK** | 3.9.2 | 3.5.0+ |
| **Gradle** | 8.0 | 8.9 |
| **Android Gradle Plugin** | 8.1.0 | 8.7.0 |
| **Kotlin** | 1.9.0 | 2.0.0 |
| **Java JDK** | 11 | 17 |

### **API de Android**

| Nivel API | Versión Android | Soporte |
|-----------|----------------|---------|
| **API 24+** | Android 7.0 Nougat | ✅ Mínimo requerido |
| **API 30+** | Android 11 | ✅ Funcionalidades completas |
| **API 34** | Android 14 | ✅ Totalmente optimizado |

### **Especificaciones del Dispositivo**
- **RAM**: Mínimo 2GB, recomendado 4GB+
- **Almacenamiento**: 100MB libres para la aplicación
- **Procesador**: ARMv7 o ARM64

## � **APK Instalables Disponibles**

### **Archivos APK Listos para Instalación**

En el directorio `APK-Instalables/` encontrarás las aplicaciones compiladas:

| Archivo APK | Tipo | Tamaño | Descripción |
|-------------|------|--------|-------------|
| `GestorArchivos-Practica3-Release-v1.0.0-API24-ESCOM.apk` | **PRODUCCIÓN** | ~50 MB | Versión optimizada para uso final |
| `GestorArchivos-Practica3-Debug-v1.0.0-API24-ESCOM.apk` | **DESARROLLO** | ~148 MB | Versión con información de depuración |

### **Características de las APK**
- ✅ **API mínima**: Android 7.0 (API 24) 
- ✅ **Nombres descriptivos** con versión y compatibilidad
- ✅ **Application ID institucional**: `com.escom.ipn.gestor_archivos_practica3`
- ✅ **Arquitectura Clean** con Flutter/Kotlin
- ✅ **Temas ESCOM/IPN** preconfigurados
- ✅ **Permisos optimizados** para Android 7.0+

### **Instalación Rápida**
```bash
# Descargar APK de producción
# Habilitar "Fuentes desconocidas" en Android
# Instalar directamente desde el administrador de archivos
```

**📋 Instrucciones detalladas**: Ver `APK-Instalables/INSTRUCCIONES_INSTALACION.md`

## �🚀 Instrucciones de Instalación

### **1. Configuración del Entorno de Desarrollo**

```bash
# Verificar instalación de Flutter
flutter doctor

# Clonar el repositorio
git clone https://github.com/AkiseF/AplicacionesMovilesNativas.git
cd AplicacionesMovilesNativas/Practica3/practica_3

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación en modo debug
flutter run
```

### **2. Configuración de Android Studio**

1. **Instalar plugins requeridos**:
   - Flutter Plugin
   - Dart Plugin
   - Kotlin Plugin

2. **Configurar SDK de Android**:
   - Android SDK Platform 34
   - Android SDK Build-Tools 34.0.0
   - Android Emulator (opcional)

3. **Configurar variables de entorno**:
   ```bash
   ANDROID_HOME=C:\Users\[usuario]\AppData\Local\Android\Sdk
   FLUTTER_HOME=C:\flutter
   ```

### **3. Construcción para Producción**

```bash
# Generar APK de release
flutter build apk --release

# Generar App Bundle (recomendado para Play Store)
flutter build appbundle --release

# Instalar en dispositivo físico
flutter install
```

## 🔐 Permisos Requeridos y Justificación

### **Permisos Críticos**

| Permiso | Justificación | Nivel de Riesgo |
|---------|---------------|----------------|
| `READ_EXTERNAL_STORAGE` | **Lectura de archivos**: Necesario para explorar y visualizar archivos del usuario | 🟡 Medio |
| `WRITE_EXTERNAL_STORAGE` | **Escritura de archivos**: Requerido para crear, editar y eliminar archivos | 🟡 Medio |
| `MANAGE_EXTERNAL_STORAGE` | **Acceso completo (Android 11+)**: Permite gestión completa del almacenamiento | 🔴 Alto |

### **Permisos Adicionales**

| Permiso | Justificación | Nivel de Riesgo |
|---------|---------------|----------------|
| `INTERNET` | **Compartir archivos**: Para funciones de compartir vía web | 🟢 Bajo |
| `ACCESS_MEDIA_LOCATION` | **Metadatos de imágenes**: Leer información EXIF de fotos | 🟢 Bajo |

### **Implementación de Seguridad**

- ✅ **Scoped Storage**: Cumple con políticas de Android 10+
- ✅ **Permisos en tiempo de ejecución**: Solicitud dinámica según funcionalidad
- ✅ **Validación de rutas**: Prevención de acceso a directorios restringidos
- ✅ **Manejo de excepciones**: Control robusto de errores de permisos

### **Configuración de Permisos**

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" 
                 tools:ignore="ScopedStorage" />
<uses-permission android:name="android.permission.INTERNET" />
```

## 📸 Capturas de Pantalla

| Funcionalidad | Captura | Descripción |
|---------------|---------|-------------|
| **Pantalla Principal** | ![Pantalla Principal](screenshots/home_screen.png) | Explorador de archivos con navegación breadcrumbs |
| **Visor de Imágenes** | ![Visor de Imágenes](screenshots/image_viewer.png) | Visualización con zoom y controles de navegación |
| **Editor de Texto** | ![Editor de Texto](screenshots/text_editor.png) | Editor completo con resaltado de sintaxis |
| **Búsqueda Avanzada** | ![Búsqueda](screenshots/search_screen.png) | Filtros múltiples para localizar archivos |
| **Favoritos y Recientes** | ![Favoritos](screenshots/favorites_screen.png) | Gestión de marcadores y historial |
| **Configuración de Temas** | ![Temas](screenshots/theme_settings.png) | Temas institucionales IPN/ESCOM |
| **Gestión de Archivos** | ![Operaciones](screenshots/file_operations.png) | Crear, copiar, mover y eliminar archivos |
| **Vista Responsive** | ![Responsive](screenshots/responsive_view.png) | Adaptación a tablets y modo landscape |

### **Estructura de Capturas**
```
Practica3/
├── screenshots/
│   ├── home_screen.png
│   ├── image_viewer.png
│   ├── text_editor.png
│   ├── search_screen.png
│   ├── favorites_screen.png
│   ├── theme_settings.png
│   ├── file_operations.png
│   └── responsive_view.png
└── README.md
```

## 📁 Estructura del Proyecto

```
Practica3/
├── practica_3/                    # Aplicación Flutter
│   ├── lib/                      # Código fuente Dart
│   ├── android/                  # Configuración Android/Kotlin
│   └── README.md                 # Documentación técnica detallada
├── APK-Instalables/              # 📦 APK listas para instalar
│   ├── GestorArchivos-Practica3-Release-v1.0.0-API24-ESCOM.apk
│   ├── GestorArchivos-Practica3-Debug-v1.0.0-API24-ESCOM.apk
│   └── INSTRUCCIONES_INSTALACION.md
├── screenshots/                  # Capturas de pantalla
├── Reporte_Técnico_PMJR_2021630506.docx  # Reporte académico
└── README.md                     # Este archivo
```

## 👥 Información del Desarrollador

- **Estudiante**: [Nombre del Estudiante]
- **Matrícula**: 2021630506
- **Materia**: Aplicaciones Móviles Nativas
- **Institución**: ESCOM - IPN
- **Periodo**: 2025-1

## 🔗 Enlaces Útiles

- [Documentación Técnica Completa](practica_3/README.md)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Kotlin for Android](https://kotlinlang.org/docs/android-overview.html)
- [Material Design Guidelines](https://material.io/design)

---

**© 2025 - Escuela Superior de Cómputo, Instituto Politécnico Nacional**
