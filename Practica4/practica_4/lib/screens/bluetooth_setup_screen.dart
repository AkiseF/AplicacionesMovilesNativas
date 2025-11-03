import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import '../services/bluetooth_service.dart';
import '../providers/game_provider.dart';
import '../models/game_session.dart';
import '../utils/bluetooth_test.dart';
import '../utils/platform_utils.dart';
import 'difficulty_selection_screen.dart';
import 'game_screen.dart';

class BluetoothSetupScreen extends StatefulWidget {
  const BluetoothSetupScreen({super.key});

  @override
  State<BluetoothSetupScreen> createState() => _BluetoothSetupScreenState();
}

class _BluetoothSetupScreenState extends State<BluetoothSetupScreen> {
  final BluetoothService _bluetoothService = BluetoothService.instance;
  
  bool _isBluetoothEnabled = false;
  bool _isScanning = false;
  bool _isHost = false;
  bool _isWaitingForConnection = false;
  List<BluetoothDevice> _bondedDevices = [];
  final List<BluetoothDiscoveryResult> _discoveredDevices = [];
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  // Stream subscriptions for proper disposal
  StreamSubscription? _stateSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _discoverySubscription;

  @override
  void initState() {
    super.initState();
    _runBluetoothDiagnostic();
    _initializeBluetooth();
    _setupListeners();
  }

  Future<void> _runBluetoothDiagnostic() async {
    if (kDebugMode) {
      debugPrint('🔍 === DIAGNÓSTICO BLUETOOTH ===');
      debugPrint('📱 Plataforma: ${PlatformUtils.platformName}');
      debugPrint('📡 Bluetooth disponible: ${PlatformUtils.isBluetoothAvailable}');
      debugPrint('🤖 Android: ${PlatformUtils.isAndroid}');
      debugPrint('🍎 iOS: ${PlatformUtils.isIOS}');
      debugPrint('🌐 Web: ${PlatformUtils.isWeb}');
      debugPrint('=================================');
    }
  }

  Future<void> _runDetailedDiagnostic() async {
    final results = <String>[];
    
    try {
      results.add('=== DIAGNÓSTICO DETALLADO BLUETOOTH ===');
      results.add('Plataforma: ${PlatformUtils.platformName}');
      results.add('Bluetooth disponible: ${PlatformUtils.isBluetoothAvailable}');
      results.add('Android: ${PlatformUtils.isAndroid}');
      
      // Test 1: Servicio inicializado
      results.add('\n🔧 TEST 1: Servicio inicializado');
      final service = BluetoothService.instance;
      results.add('✅ Servicio obtenido');
      
      // Test 2: Estado Bluetooth
      results.add('\n📡 TEST 2: Estado Bluetooth');
      try {
        final isEnabled = await service.isBluetoothEnabled();
        results.add('Estado habilitado: $isEnabled');
      } catch (e) {
        results.add('❌ Error verificando estado: $e');
      }
      
      // Test 3: Dispositivos emparejados
      results.add('\n📱 TEST 3: Dispositivos emparejados');
      try {
        final devices = await service.getBondedDevices();
        results.add('Dispositivos encontrados: ${devices.length}');
        for (var device in devices) {
          results.add('  - ${device.name ?? "Sin nombre"} (${device.address})');
        }
      } catch (e) {
        results.add('❌ Error obteniendo dispositivos: $e');
      }
      
      // Test 4: Hacer dispositivo visible
      results.add('\n👁️ TEST 4: Hacer dispositivo visible');
      try {
        final result = await service.makeDiscoverable();
        results.add('Resultado: $result');
      } catch (e) {
        results.add('❌ Error: $e');
      }
      
      results.add('\n=== FIN DIAGNÓSTICO ===');
      
    } catch (e) {
      results.add('💥 Error general en diagnóstico: $e');
    }
    
    // Mostrar resultados en consola
    for (String result in results) {
      if (kDebugMode) {
        debugPrint(result);
      }
    }
    
    // Mostrar resumen en UI
    if (mounted) {
      _showSnackBar('Diagnóstico completado. Ver logs para detalles.', isError: false);
    }
  }

  Future<void> _initializeBluetooth() async {
    try {
      if (kDebugMode) {
        debugPrint('🔧 Inicializando servicio Bluetooth...');
      }
      
      await _bluetoothService.initialize();
      
      if (kDebugMode) {
        debugPrint('✅ Servicio Bluetooth inicializado');
      }
      
      final isEnabled = await _bluetoothService.isBluetoothEnabled();
      
      if (kDebugMode) {
        debugPrint('📡 Estado Bluetooth: ${isEnabled ? "Habilitado" : "Deshabilitado"}');
      }
      
      if (mounted) {
        setState(() {
          _isBluetoothEnabled = isEnabled;
        });

        if (isEnabled) {
          _loadBondedDevices();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error al inicializar Bluetooth: $e');
      }
      if (mounted) {
        _showSnackBar('Error al inicializar Bluetooth: $e', isError: true);
      }
    }
  }

  void _setupListeners() {
    try {
      // Listen to Bluetooth state changes
      _stateSubscription = _bluetoothService.stateStream.listen(
        (state) {
          if (mounted) {
            setState(() {
              _isBluetoothEnabled = state == BluetoothState.STATE_ON;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            _showSnackBar('Error en estado Bluetooth: $error', isError: true);
          }
        },
      );

      // Listen to connection state changes
      _connectionSubscription = _bluetoothService.connectionStateStream.listen(
        (state) {
          if (mounted) {
            setState(() {
              _connectionState = state;
            });

            if (state == BluetoothConnectionState.connected) {
              _onConnectionEstablished();
            } else if (state == BluetoothConnectionState.disconnected) {
              setState(() {
                _isWaitingForConnection = false;
              });
            }
          }
        },
        onError: (error) {
          if (mounted) {
            _showSnackBar('Error en conexión: $error', isError: true);
          }
        },
      );

      // Listen to incoming messages
      _messageSubscription = _bluetoothService.messageStream.listen(
        (message) {
          if (mounted) {
            _handleIncomingMessage(message);
          }
        },
        onError: (error) {
          if (mounted) {
            _showSnackBar('Error en mensajes: $error', isError: true);
          }
        },
      );
    } catch (e) {
      _showSnackBar('Error configurando listeners: $e', isError: true);
    }
  }

  Future<void> _loadBondedDevices() async {
    try {
      if (kDebugMode) {
        debugPrint('🔍 Cargando dispositivos emparejados...');
      }
      
      final devices = await _bluetoothService.getBondedDevices();
      
      if (kDebugMode) {
        debugPrint('📱 Dispositivos emparejados encontrados: ${devices.length}');
        for (var device in devices) {
          debugPrint('  - ${device.name ?? "Sin nombre"} (${device.address})');
        }
      }
      
      if (mounted) {
        setState(() {
          _bondedDevices = devices;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error al cargar dispositivos emparejados: $e');
      }
      if (mounted) {
        _showSnackBar('Error al cargar dispositivos: $e', isError: true);
      }
    }
  }

  Future<void> _requestEnableBluetooth() async {
    final success = await _bluetoothService.requestEnable();
    if (success) {
      setState(() {
        _isBluetoothEnabled = true;
      });
      _loadBondedDevices();
    } else {
      _showSnackBar('No se pudo activar Bluetooth', isError: true);
    }
  }

  void _startDeviceDiscovery() {
    setState(() {
      _isScanning = true;
      _discoveredDevices.clear();
    });

    _discoverySubscription = _bluetoothService.startDiscovery().listen(
      (result) {
        if (mounted) {
          setState(() {
            final existingIndex = _discoveredDevices.indexWhere(
              (r) => r.device.address == result.device.address,
            );
            
            if (existingIndex >= 0) {
              _discoveredDevices[existingIndex] = result;
            } else {
              _discoveredDevices.add(result);
            }
          });
        }
      },
      onDone: () {
        if (mounted) {
          setState(() {
            _isScanning = false;
          });
        }
      },
    );
  }

  void _stopDeviceDiscovery() {
    _discoverySubscription?.cancel();
    _bluetoothService.cancelDiscovery();
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _startAsHost() async {
    try {
      if (kDebugMode) {
        debugPrint('🏠 Iniciando como anfitrión...');
      }
      
      setState(() {
        _isHost = true;
        _isWaitingForConnection = true;
      });

      if (kDebugMode) {
        debugPrint('📡 Llamando a startServer()...');
      }
      
      final success = await _bluetoothService.startServer();
      
      if (kDebugMode) {
        debugPrint('🎯 Resultado startServer: $success');
      }
      
      if (!success) {
        if (kDebugMode) {
          debugPrint('❌ Falló al iniciar servidor');
        }
        setState(() {
          _isWaitingForConnection = false;
          _isHost = false;
        });
        _showSnackBar('Error al iniciar el servidor', isError: true);
      } else {
        if (kDebugMode) {
          debugPrint('✅ Servidor iniciado exitosamente');
        }
        _showSnackBar('Esperando conexión de otro jugador...');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('💥 Excepción en _startAsHost: $e');
      }
      setState(() {
        _isWaitingForConnection = false;
        _isHost = false;
      });
      _showSnackBar('Error inesperado al iniciar servidor: $e', isError: true);
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      if (kDebugMode) {
        debugPrint('🔌 Intentando conectar a: ${device.name ?? "Sin nombre"} (${device.address})');
      }
      
      setState(() {
        _connectionState = BluetoothConnectionState.connecting;
      });

      if (kDebugMode) {
        debugPrint('📡 Llamando connectToDevice()...');
      }
      
      final success = await _bluetoothService.connectToDevice(device);
      
      if (kDebugMode) {
        debugPrint('🎯 Resultado connectToDevice: $success');
      }
      
      if (!success) {
        if (kDebugMode) {
          debugPrint('❌ Falló la conexión');
        }
        setState(() {
          _connectionState = BluetoothConnectionState.disconnected;
        });
        _showSnackBar('No se pudo conectar a ${device.name ?? "dispositivo"}', isError: true);
      } else {
        if (kDebugMode) {
          debugPrint('✅ Conexión iniciada exitosamente');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('💥 Excepción en _connectToDevice: $e');
      }
      setState(() {
        _connectionState = BluetoothConnectionState.disconnected;
      });
      _showSnackBar('Error inesperado al conectar: $e', isError: true);
    }
  }

  void _onConnectionEstablished() {
    try {
      if (kDebugMode) {
        debugPrint('🎉 Conexión establecida! IsHost: $_isHost');
      }
      
      _showSnackBar('Conexión establecida', isError: false);
      
      if (_isHost) {
        if (kDebugMode) {
          debugPrint('🏠 Navegando a selección de dificultad (anfitrión)...');
        }
        // Host selects difficulty and starts game
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DifficultySelectionScreen(
              gameMode: GameMode.twoPlayer,
            ),
          ),
        );
      } else {
        if (kDebugMode) {
          debugPrint('👥 Cliente esperando inicio de juego...');
        }
        // Client waits for game start from host
        _showSnackBar('Esperando que el anfitrión inicie el juego...');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('💥 Error en _onConnectionEstablished: $e');
      }
      _showSnackBar('Error al establecer conexión: $e', isError: true);
    }
  }

  void _handleIncomingMessage(BluetoothGameMessage message) {
    switch (message.type) {
      case BluetoothGameMessageType.gameStart:
        _handleGameStart(message);
        break;
      case BluetoothGameMessageType.characterSelection:
        _handleCharacterSelection(message);
        break;
      case BluetoothGameMessageType.question:
        _handleQuestion(message);
        break;
      case BluetoothGameMessageType.answer:
        _handleAnswer(message);
        break;
      case BluetoothGameMessageType.elimination:
        _handleElimination(message);
        break;
      case BluetoothGameMessageType.guess:
        _handleGuess(message);
        break;
      case BluetoothGameMessageType.turnChange:
        _handleTurnChange(message);
        break;
      default:
        break;
    }
  }

  void _handleGameStart(BluetoothGameMessage message) {
    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      final difficultyName = message.data['difficulty'] as String?;
      
      if (difficultyName == null) {
        _showSnackBar('Error: Dificultad no especificada', isError: true);
        return;
      }
      
      final difficulty = DifficultyLevel.values.firstWhere(
        (e) => e.name == difficultyName,
        orElse: () => DifficultyLevel.medium, // Default fallback
      );
      
      // Note: characterIds from message are not used as the game generates 
      // its own character board based on difficulty
      
      // Navigate to game screen
      gameProvider.startNewGame(
        GameMode.twoPlayer,
        difficulty: difficulty,
      ).then((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const GameScreen(),
            ),
          );
        }
      }).catchError((error) {
        if (mounted) {
          _showSnackBar('Error al iniciar juego: $error', isError: true);
        }
      });
    } catch (e) {
      _showSnackBar('Error al procesar inicio de juego: $e', isError: true);
    }
  }

  void _handleCharacterSelection(BluetoothGameMessage message) {
    // Handle when opponent selects character
    if (kDebugMode) {
      debugPrint('Oponente seleccionó personaje: ${message.data['characterName']}');
    }
  }

  void _handleQuestion(BluetoothGameMessage message) {
    // Handle incoming question from opponent
    if (kDebugMode) {
      debugPrint('Pregunta recibida: ${message.data['questionText']}');
    }
  }

  void _handleAnswer(BluetoothGameMessage message) {
    // Handle answer to your question
    if (kDebugMode) {
      debugPrint('Respuesta recibida: ${message.data['answer']}');
    }
  }

  void _handleElimination(BluetoothGameMessage message) {
    // Handle character elimination from opponent
    if (kDebugMode) {
      debugPrint('Oponente eliminó personaje: ${message.data['characterId']}');
    }
  }

  void _handleGuess(BluetoothGameMessage message) {
    // Handle final guess from opponent
    if (kDebugMode) {
      debugPrint('Oponente adivinó: ${message.data['characterId']}');
    }
  }

  void _handleTurnChange(BluetoothGameMessage message) {
    // Handle turn change
    if (kDebugMode) {
      debugPrint('Cambio de turno');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  Future<void> _runBluetoothTests() async {
    _showSnackBar('Ejecutando pruebas de Bluetooth...');
    
    try {
      final results = await BluetoothTest.runAllTests();
      
      final totalTests = results.length;
      final passedTests = results.values.where((result) => result).length;
      final failedTests = totalTests - passedTests;
      
      final message = 'Pruebas completadas: $passedTests/$totalTests exitosas';
      _showSnackBar(message, isError: failedTests > 0);
      
      // Show detailed results dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Resultados de Pruebas'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: results.entries.map((entry) => 
                Text('${entry.value ? '✅' : '❌'} ${entry.key}')
              ).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      _showSnackBar('Error ejecutando pruebas: $e', isError: true);
    }
  }

  @override
  void dispose() {
    // Cancel all stream subscriptions to prevent memory leaks
    _stateSubscription?.cancel();
    _connectionSubscription?.cancel();
    _messageSubscription?.cancel();
    _discoverySubscription?.cancel();
    
    if (_isScanning) {
      _stopDeviceDiscovery();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modo Multijugador'),
        centerTitle: true,
        actions: [
          // Botón de diagnóstico (visible en debug mode)
          if (kDebugMode)
            IconButton(
              icon: const Icon(Icons.bug_report),
              onPressed: _runDetailedDiagnostic,
              tooltip: 'Ejecutar diagnóstico',
            ),
          if (_isBluetoothEnabled && _connectionState == BluetoothConnectionState.disconnected)
            IconButton(
              icon: Icon(_isScanning ? Icons.stop : Icons.refresh),
              onPressed: _isScanning ? _stopDeviceDiscovery : _startDeviceDiscovery,
              tooltip: _isScanning ? 'Detener búsqueda' : 'Buscar dispositivos',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isBluetoothEnabled) {
      return _buildBluetoothDisabledView();
    }

    if (_connectionState == BluetoothConnectionState.connected) {
      return _buildConnectedView();
    }

    if (_isWaitingForConnection) {
      return _buildWaitingForConnectionView();
    }

    return _buildDeviceSelectionView();
  }

  Widget _buildBluetoothDisabledView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bluetooth_disabled,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Bluetooth Desactivado',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Activa Bluetooth para jugar con otro jugador',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _requestEnableBluetooth,
              icon: const Icon(Icons.bluetooth),
              label: const Text('Activar Bluetooth'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceSelectionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Debug Test Button (only in debug mode)
          if (kDebugMode)
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      '🧪 Prueba de Bluetooth (Debug)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _runBluetoothTests,
                      icon: const Icon(Icons.bug_report),
                      label: const Text('Ejecutar Pruebas'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (kDebugMode) const SizedBox(height: 16),
          // Host or Join section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Cómo quieres conectarte?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Create Game (Host)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_circle, color: Colors.blue),
                    ),
                    title: const Text('Crear Partida'),
                    subtitle: const Text('Sé el anfitrión y espera a que otro jugador se conecte'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _startAsHost,
                  ),
                  
                  const Divider(height: 32),
                  
                  // Join Game (Client)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.search, color: Colors.green),
                    ),
                    title: const Text('Unirse a Partida'),
                    subtitle: const Text('Busca y conéctate a una partida existente'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _startDeviceDiscovery,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Bonded Devices
          if (_bondedDevices.isNotEmpty) ...[
            Text(
              'Dispositivos Vinculados',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ..._bondedDevices.map((device) => _buildDeviceCard(device, isBonded: true)),
          ],
          
          // Discovered Devices
          if (_discoveredDevices.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Dispositivos Encontrados',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isScanning) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            ..._discoveredDevices.map((result) => _buildDeviceCard(result.device)),
          ],
          
          if (_isScanning && _discoveredDevices.isEmpty) ...[
            const SizedBox(height: 32),
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Buscando dispositivos...'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeviceCard(BluetoothDevice device, {bool isBonded = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isBonded ? Icons.bluetooth_connected : Icons.bluetooth,
          color: isBonded ? Colors.blue : Colors.grey,
        ),
        title: Text(device.name ?? 'Dispositivo Desconocido'),
        subtitle: Text(device.address),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: () => _connectToDevice(device),
      ),
    );
  }

  Widget _buildWaitingForConnectionView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Esperando Conexión',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Otro jugador puede conectarse a tu dispositivo ahora',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {
                _bluetoothService.disconnect();
                setState(() {
                  _isWaitingForConnection = false;
                  _isHost = false;
                });
              },
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green[400],
            ),
            const SizedBox(height: 24),
            Text(
              '¡Conectado!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Conectado a ${_bluetoothService.connectedDevice?.name ?? "dispositivo"}',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_isHost)
              const Text(
                'Selecciona la dificultad para comenzar',
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'Esperando que el anfitrión inicie el juego...',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}