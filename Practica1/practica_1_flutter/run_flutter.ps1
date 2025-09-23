#!/usr/bin/env pwsh
# Script para ejecutar el proyecto Flutter desde el directorio correcto

# Cambiar al directorio del proyecto Flutter
Set-Location -Path $PSScriptRoot

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "pubspec.yaml")) {
    Write-Error "Error: No se encontró pubspec.yaml. Asegúrate de estar en el directorio raíz del proyecto Flutter."
    exit 1
}

# Ejecutar Flutter
Write-Host "Ejecutando Flutter desde: $(Get-Location)" -ForegroundColor Green
flutter run