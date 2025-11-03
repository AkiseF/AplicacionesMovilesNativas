# 🔧 Diagnóstico de Problemas Bluetooth

## ❌ Problemas Comunes y Soluciones

### 1. **La aplicación se cierra al crear partida Bluetooth**

**Posibles causas:**
- Permisos de Bluetooth no otorgados
- Bluetooth no habilitado en el dispositivo
- Conflicto con otros servicios Bluetooth
- Error en la inicialización del servicio

**Soluciones:**
1. Verificar que Bluetooth esté habilitado
2. Otorgar permisos de ubicación y Bluetooth
3. Reiniciar Bluetooth del dispositivo
4. Ejecutar diagnóstico desde la app (botón 🐛 en modo debug)

### 2. **No se detectan dispositivos**

**Posibles causas:**
- Dispositivos no emparejados previamente
- Bluetooth del otro dispositivo no visible
- Permisos de ubicación denegados

**Soluciones:**
1. Emparejar dispositivos desde configuración Android
2. Hacer el otro dispositivo visible
3. Verificar permisos de ubicación

### 3. **Conexión falla o se interrumpe**

**Posibles causas:**
- Distancia excesiva entre dispositivos
- Interferencia Bluetooth
- Batería baja
- Otro dispositivo conectado

**Soluciones:**
1. Acercar dispositivos (máximo 10 metros)
2. Desconectar otros dispositivos Bluetooth
3. Verificar nivel de batería
4. Reintentar conexión

### 4. **El host no puede iniciar servidor**

**Posibles causas:**
- Puerto Bluetooth ocupado
- Permisos insuficientes
- Bluetooth no habilitado

**Soluciones:**
1. Cerrar otras aplicaciones Bluetooth
2. Reiniciar Bluetooth
3. Verificar permisos de aplicación

## 🔍 Pasos para Diagnóstico

1. **Abrir pantalla Bluetooth** - Desde menú principal
2. **Presionar botón 🐛** - Solo visible en modo debug
3. **Revisar logs** - Buscar mensajes de error específicos
4. **Ejecutar pruebas** - Usar botón "Ejecutar Pruebas" si está disponible

## 📋 Checklist Pre-Conexión

- [ ] Bluetooth habilitado en ambos dispositivos
- [ ] Dispositivos emparejados previamente
- [ ] Permisos otorgados (Bluetooth + Ubicación)
- [ ] Distancia menor a 10 metros
- [ ] Sin otros dispositivos Bluetooth conectados
- [ ] Batería suficiente en ambos dispositivos

## 🚨 Códigos de Error Comunes

- **`PlatformException`**: Problema con permisos o API nativa
- **`StateError`**: Bluetooth no inicializado correctamente
- **`TimeoutException`**: Tiempo de conexión agotado
- **`SocketException`**: Problema de red/conexión

## 📞 Información para Soporte

Si el problema persiste, proporcionar:
- Versión Android de ambos dispositivos
- Logs completos del diagnóstico
- Modelo de dispositivos
- Pasos exactos que causan el error