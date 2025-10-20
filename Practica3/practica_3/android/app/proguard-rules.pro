# Reglas básicas de ProGuard para Flutter
# Mantener clases principales
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Reglas para gestión de archivos
-keep class java.io.** { *; }
-keep class java.nio.** { *; }