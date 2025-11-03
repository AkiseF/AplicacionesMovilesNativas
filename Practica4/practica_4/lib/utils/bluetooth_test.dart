import 'package:flutter/foundation.dart';
import '../services/bluetooth_service.dart';

/// Clase de utilidad para probar la funcionalidad Bluetooth de forma aislada
class BluetoothTest {
  static final BluetoothService _bluetoothService = BluetoothService.instance;
  
  /// Prueba básica de inicialización de Bluetooth
  static Future<bool> testBluetoothInitialization() async {
    try {
      if (kDebugMode) {
        debugPrint('🧪 Iniciando prueba de inicialización Bluetooth...');
      }
      
      await _bluetoothService.initialize();
      
      final isEnabled = await _bluetoothService.isBluetoothEnabled();
      if (kDebugMode) {
        debugPrint('✅ Bluetooth habilitado: $isEnabled');
      }
      
      if (!isEnabled) {
        final enableResult = await _bluetoothService.requestEnable();
        if (kDebugMode) {
          debugPrint('✅ Resultado de habilitar Bluetooth: $enableResult');
        }
        return enableResult;
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error en prueba de inicialización: $e');
      }
      return false;
    }
  }
  
  /// Prueba de obtener dispositivos vinculados
  static Future<bool> testGetBondedDevices() async {
    try {
      if (kDebugMode) {
        debugPrint('🧪 Iniciando prueba de dispositivos vinculados...');
      }
      
      final bondedDevices = await _bluetoothService.getBondedDevices();
      if (kDebugMode) {
        debugPrint('✅ Dispositivos vinculados encontrados: ${bondedDevices.length}');
        for (var device in bondedDevices) {
          debugPrint('  - ${device.name ?? 'Sin nombre'} (${device.address})');
        }
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error en prueba de dispositivos vinculados: $e');
      }
      return false;
    }
  }
  
  /// Prueba de hacer el dispositivo visible
  static Future<bool> testMakeDiscoverable() async {
    try {
      if (kDebugMode) {
        debugPrint('🧪 Iniciando prueba de visibilidad...');
      }
      
      final result = await _bluetoothService.makeDiscoverable(timeout: 60);
      if (kDebugMode) {
        debugPrint('✅ Resultado de hacer visible: $result');
      }
      
      return result;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error en prueba de visibilidad: $e');
      }
      return false;
    }
  }
  
  /// Prueba de creación de mensaje Bluetooth
  static bool testMessageSerialization() {
    try {
      if (kDebugMode) {
        debugPrint('🧪 Iniciando prueba de serialización de mensajes...');
      }
      
      final message = BluetoothGameMessage(
        type: BluetoothGameMessageType.gameStart,
        data: {
          'difficulty': 'medium',
          'test': 'data',
        },
      );
      
      final serialized = message.serialize();
      if (kDebugMode) {
        debugPrint('✅ Mensaje serializado: $serialized');
      }
      
      final deserialized = BluetoothGameMessage.deserialize(serialized);
      if (kDebugMode) {
        debugPrint('✅ Mensaje deserializado: ${deserialized.type}, ${deserialized.data}');
      }
      
      return deserialized.type == message.type && 
             deserialized.data['difficulty'] == message.data['difficulty'];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error en prueba de serialización: $e');
      }
      return false;
    }
  }
  
  /// Ejecuta todas las pruebas
  static Future<Map<String, bool>> runAllTests() async {
    final results = <String, bool>{};
    
    if (kDebugMode) {
      debugPrint('🧪 ===== INICIANDO PRUEBAS DE BLUETOOTH =====');
    }
    
    results['initialization'] = await testBluetoothInitialization();
    results['bondedDevices'] = await testGetBondedDevices();
    results['makeDiscoverable'] = await testMakeDiscoverable();
    results['messageSerialization'] = testMessageSerialization();
    
    if (kDebugMode) {
      debugPrint('🧪 ===== RESULTADOS DE PRUEBAS =====');
      results.forEach((test, result) {
        debugPrint('${result ? '✅' : '❌'} $test: $result');
      });
      debugPrint('🧪 ===== FIN DE PRUEBAS =====');
    }
    
    return results;
  }
}