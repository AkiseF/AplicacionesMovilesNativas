#!/bin/bash

# Script para corregir el namespace de flutter_bluetooth_serial
# Autor: Asistente de IA
# Uso: ./fix_bluetooth_namespace.sh

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  Flutter Bluetooth Serial Fix  ${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

echo -e "${YELLOW}🔧 Corrigiendo namespace de flutter_bluetooth_serial...${NC}"
echo ""

# Encontrar la ruta del paquete
PACKAGE_PATH="$HOME/.pub-cache/hosted/pub.dev/flutter_bluetooth_serial-0.4.0/android/build.gradle"

# Verificar si el archivo existe
if [ ! -f "$PACKAGE_PATH" ]; then
    echo -e "${RED}❌ No se encontró flutter_bluetooth_serial en la cache${NC}"
    echo ""
    echo "Ruta buscada: $PACKAGE_PATH"
    echo ""
    echo "Posibles soluciones:"
    echo "1. Ejecuta 'flutter pub get' primero"
    echo "2. Verifica que flutter_bluetooth_serial esté en pubspec.yaml"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Paquete encontrado en:${NC}"
echo "   $PACKAGE_PATH"
echo ""

# Hacer backup
BACKUP_PATH="$PACKAGE_PATH.backup"
if [ -f "$BACKUP_PATH" ]; then
    echo -e "${YELLOW}⚠️  Ya existe un backup, será sobrescrito${NC}"
fi

cp "$PACKAGE_PATH" "$BACKUP_PATH"
echo -e "${GREEN}✅ Backup creado:${NC}"
echo "   $BACKUP_PATH"
echo ""

# Verificar si ya tiene namespace
if grep -q "namespace \"io.github.edufolly.flutterbluetoothserial\"" "$PACKAGE_PATH"; then
    echo -e "${YELLOW}⚠️  El namespace correcto ya existe${NC}"
    echo -e "${GREEN}✅ No se necesitan cambios${NC}"
    echo ""
    echo "Intenta ejecutar:"
    echo "  flutter clean"
    echo "  flutter pub get"
    echo "  flutter run"
    echo ""
    exit 0
fi

# Agregar namespace después de "android {"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' '/^android {$/a\
    namespace "io.github.edufolly.flutterbluetoothserial"
' "$PACKAGE_PATH"
else
    # Linux
    sed -i '/^android {$/a\    namespace "io.github.edufolly.flutterbluetoothserial"' "$PACKAGE_PATH"
fi

# Verificar si se agregó correctamente
if grep -q "namespace \"io.github.edufolly.flutterbluetoothserial\"" "$PACKAGE_PATH"; then
    echo -e "${GREEN}✅ Namespace agregado correctamente${NC}"
    echo ""
    echo -e "${BLUE}Próximos pasos:${NC}"
    echo "  1. flutter clean"
    echo "  2. flutter pub get"
    echo "  3. flutter run"
    echo ""
    echo -e "${GREEN}🎉 ¡Listo! Ahora tu proyecto debería compilar.${NC}"
else
    echo -e "${RED}❌ No se pudo agregar el namespace automáticamente${NC}"
    echo ""
    echo "Por favor, edita manualmente el archivo:"
    echo "  $PACKAGE_PATH"
    echo ""
    echo "Agrega esta línea después de 'android {':"
    echo '  namespace "io.github.edufolly.flutterbluetoothserial"'
    echo ""
    exit 1
fi

echo ""
echo -e "${BLUE}================================${NC}"
