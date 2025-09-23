@echo off
REM Script para ejecutar el proyecto Flutter desde el directorio correcto

REM Cambiar al directorio donde está este archivo
cd /d "%~dp0"

REM Verificar que estamos en el directorio correcto
if not exist "pubspec.yaml" (
    echo Error: No se encontró pubspec.yaml. Asegúrate de estar en el directorio raíz del proyecto Flutter.
    pause
    exit /b 1
)

REM Mostrar directorio actual
echo Ejecutando Flutter desde: %CD%

REM Ejecutar Flutter
flutter run

REM Pausar para ver el resultado
pause