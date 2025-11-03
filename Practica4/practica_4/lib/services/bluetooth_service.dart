import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/character.dart';
import '../models/question.dart';
import '../models/game_session.dart';

enum BluetoothGameMessageType {
  characterSelection,
  question,
  answer,
  elimination,
  guess,
  gameStart,
  gameEnd,
  turnChange,
}

class BluetoothGameMessage {
  final BluetoothGameMessageType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  BluetoothGameMessage({
    required this.type,
    required this.data,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };

  factory BluetoothGameMessage.fromJson(Map<String, dynamic> json) {
    try {
      return BluetoothGameMessage(
        type: BluetoothGameMessageType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => throw ArgumentError('Invalid message type: ${json['type']}'),
        ),
        data: (json['data'] as Map<String, dynamic>?) ?? {},
      );
    } catch (e) {
      throw FormatException('Failed to parse BluetoothGameMessage: $e');
    }
  }

  String serialize() => jsonEncode(toJson());

  factory BluetoothGameMessage.deserialize(String data) {
    try {
      if (data.trim().isEmpty) {
        throw ArgumentError('Empty message data');
      }
      final decoded = jsonDecode(data);
      if (decoded is! Map<String, dynamic>) {
        throw ArgumentError('Invalid JSON format');
      }
      return BluetoothGameMessage.fromJson(decoded);
    } catch (e) {
      throw FormatException('Failed to deserialize message: $e');
    }
  }
}

class BluetoothService {
  static BluetoothService? _instance;
  static BluetoothService get instance => _instance ??= BluetoothService._();
  BluetoothService._();

  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;
  
  final StreamController<BluetoothGameMessage> _messageController = 
      StreamController<BluetoothGameMessage>.broadcast();
  
  final StreamController<BluetoothState> _stateController = 
      StreamController<BluetoothState>.broadcast();

  final StreamController<BluetoothConnectionState> _connectionStateController = 
      StreamController<BluetoothConnectionState>.broadcast();

  bool _isHost = false;
  bool _isListening = false;

  // Getters
  Stream<BluetoothGameMessage> get messageStream => _messageController.stream;
  Stream<BluetoothState> get stateStream => _stateController.stream;
  Stream<BluetoothConnectionState> get connectionStateStream => _connectionStateController.stream;
  bool get isConnected => _connection != null && _connection!.isConnected;
  bool get isHost => _isHost;
  BluetoothDevice? get connectedDevice => _connectedDevice;

  /// Initialize Bluetooth
  Future<void> initialize() async {
    try {
      if (kDebugMode) {
        debugPrint('🔧 BluetoothService: Iniciando inicialización...');
      }
      
      // Get initial state
      final state = await _bluetooth.state;
      if (kDebugMode) {
        debugPrint('📡 BluetoothService: Estado inicial - $state');
      }
      
      if (!_stateController.isClosed) {
        _stateController.add(state);
      }

      // Listen to state changes
      _bluetooth.onStateChanged().listen(
        (state) {
          if (kDebugMode) {
            debugPrint('📡 BluetoothService: Cambio de estado - $state');
          }
          if (!_stateController.isClosed) {
            _stateController.add(state);
          }
        },
        onError: (error) {
          if (kDebugMode) {
            debugPrint('❌ BluetoothService: Error en stream de estado - $error');
          }
        },
      );
      
      if (kDebugMode) {
        debugPrint('✅ BluetoothService: Inicialización completada');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('💥 BluetoothService: Error en inicialización - $e');
      }
      rethrow;
    }
  }

  /// Check if Bluetooth is enabled
  Future<bool> isBluetoothEnabled() async {
    final state = await _bluetooth.state;
    return state == BluetoothState.STATE_ON;
  }

  /// Request to enable Bluetooth
  Future<bool> requestEnable() async {
    return await _bluetooth.requestEnable() ?? false;
  }

  /// Get list of bonded devices
  Future<List<BluetoothDevice>> getBondedDevices() async {
    try {
      if (kDebugMode) {
        debugPrint('📱 BluetoothService: Obteniendo dispositivos emparejados...');
      }
      
      final devices = await _bluetooth.getBondedDevices();
      
      if (kDebugMode) {
        debugPrint('📱 BluetoothService: Encontrados ${devices.length} dispositivos');
        for (var device in devices) {
          debugPrint('  - ${device.name ?? "Sin nombre"} (${device.address}) - Tipo: ${device.type}');
        }
      }
      
      return devices;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ BluetoothService: Error obteniendo dispositivos emparejados - $e');
      }
      rethrow;
    }
  }

  /// Get list of available devices (discovery)
  Stream<BluetoothDiscoveryResult> startDiscovery() {
    return _bluetooth.startDiscovery();
  }

  /// Cancel device discovery
  Future<void> cancelDiscovery() async {
    await _bluetooth.cancelDiscovery();
  }

  /// Make device discoverable for others to connect
  Future<bool> makeDiscoverable({int timeout = 300}) async {
    try {
      if (kDebugMode) {
        debugPrint('👁️ BluetoothService: Haciendo dispositivo visible por ${timeout}s...');
      }
      
      final result = await _bluetooth.requestDiscoverable(timeout);
      
      if (kDebugMode) {
        debugPrint('👁️ BluetoothService: Resultado visibilidad - $result');
      }
      
      final success = result != null && result > 0;
      
      if (kDebugMode) {
        debugPrint('👁️ BluetoothService: Éxito - $success');
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ BluetoothService: Error haciendo dispositivo visible - $e');
      }
      return false;
    }
  }

  /// Start server (host) - wait for incoming connections
  Future<bool> startServer() async {
    if (_isListening) return false;
    
    try {
      // Ensure Bluetooth is enabled
      final isEnabled = await isBluetoothEnabled();
      if (!isEnabled) {
        final enableResult = await requestEnable();
        if (!enableResult) {
          if (kDebugMode) {
            debugPrint('❌ No se pudo habilitar Bluetooth');
          }
          return false;
        }
      }

      // Make device discoverable
      final discoverableResult = await makeDiscoverable();
      if (!discoverableResult) {
        if (kDebugMode) {
          debugPrint('❌ No se pudo hacer el dispositivo visible');
        }
        return false;
      }
      
      _isHost = true;
      _isListening = true;
      
      if (kDebugMode) {
        debugPrint('🎮 Servidor Bluetooth iniciado, esperando conexiones...');
        debugPrint('📱 Haz que el otro dispositivo se conecte a este');
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error al iniciar servidor: $e');
      }
      _isListening = false;
      return false;
    }
  }

  /// Connect to device (client)
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      if (kDebugMode) {
        debugPrint('📡 Conectando a ${device.name}...');
      }
      
      // ✅ CORREGIDO: Sin el parámetro uuid
      final connection = await BluetoothConnection.toAddress(device.address);
      _handleConnection(connection);
      _connectedDevice = device;
      _isHost = false;

      if (kDebugMode) {
        debugPrint('✅ Conectado a ${device.name}');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error al conectar: $e');
      }
      return false;
    }
  }

  /// Handle established connection
  void _handleConnection(BluetoothConnection connection) {
    try {
      _connection = connection;
      _connectionStateController.add(BluetoothConnectionState.connected);

      // Listen to incoming messages
      final inputStream = _connection?.input;
      if (inputStream != null) {
        inputStream.listen(
          (data) {
            try {
              if (data.isNotEmpty) {
                final message = utf8.decode(data);
                final gameMessage = BluetoothGameMessage.deserialize(message);
                _messageController.add(gameMessage);
                if (kDebugMode) {
                  debugPrint('📨 Mensaje recibido: ${gameMessage.type}');
                }
              }
            } catch (e) {
              if (kDebugMode) {
                debugPrint('❌ Error al procesar mensaje: $e');
              }
            }
          },
          onDone: () {
            if (kDebugMode) {
              debugPrint('🔌 Conexión cerrada');
            }
            _handleDisconnection();
          },
          onError: (error) {
            if (kDebugMode) {
              debugPrint('❌ Error en conexión: $error');
            }
            _handleDisconnection();
          },
          cancelOnError: true,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error al configurar conexión: $e');
      }
      _handleDisconnection();
    }
  }

  /// Send message through Bluetooth
  Future<bool> sendMessage(BluetoothGameMessage message) async {
    if (!isConnected || _connection == null) {
      if (kDebugMode) {
        debugPrint('❌ No hay conexión activa');
      }
      return false;
    }

    try {
      final data = message.serialize();
      final encodedData = utf8.encode(data);
      
      // Check if connection is still valid before sending
      if (_connection!.isConnected) {
        _connection!.output.add(encodedData);
        await _connection!.output.allSent;
        if (kDebugMode) {
          debugPrint('📤 Mensaje enviado: ${message.type}');
        }
        return true;
      } else {
        if (kDebugMode) {
          debugPrint('❌ Conexión perdida al enviar mensaje');
        }
        _handleDisconnection();
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error al enviar mensaje: $e');
      }
      _handleDisconnection();
      return false;
    }
  }

  /// Send character selection
  Future<bool> sendCharacterSelection(Character character) async {
    return sendMessage(BluetoothGameMessage(
      type: BluetoothGameMessageType.characterSelection,
      data: {
        'characterId': character.id,
        'characterName': character.name,
      },
    ));
  }

  /// Send question
  Future<bool> sendQuestion(Question question) async {
    return sendMessage(BluetoothGameMessage(
      type: BluetoothGameMessageType.question,
      data: {
        'questionId': question.id,
        'questionText': question.text,
        'category': question.category.name,
      },
    ));
  }

  /// Send answer to question
  Future<bool> sendAnswer(bool answer) async {
    return sendMessage(BluetoothGameMessage(
      type: BluetoothGameMessageType.answer,
      data: {
        'answer': answer,
      },
    ));
  }

  /// Send character elimination
  Future<bool> sendElimination(Character character) async {
    return sendMessage(BluetoothGameMessage(
      type: BluetoothGameMessageType.elimination,
      data: {
        'characterId': character.id,
      },
    ));
  }

  /// Send final guess
  Future<bool> sendGuess(Character character) async {
    return sendMessage(BluetoothGameMessage(
      type: BluetoothGameMessageType.guess,
      data: {
        'characterId': character.id,
      },
    ));
  }

  /// Send game start signal with game configuration
  Future<bool> sendGameStart(GameSession gameSession) async {
    return sendMessage(BluetoothGameMessage(
      type: BluetoothGameMessageType.gameStart,
      data: {
        'difficulty': gameSession.difficulty.name,
        'characterIds': gameSession.gameBoard.map((c) => c.id).toList(),
      },
    ));
  }

  /// Send turn change
  Future<bool> sendTurnChange() async {
    return sendMessage(BluetoothGameMessage(
      type: BluetoothGameMessageType.turnChange,
      data: {},
    ));
  }

  /// Handle disconnection
  void _handleDisconnection() {
    _connectionStateController.add(BluetoothConnectionState.disconnected);
    _connection?.dispose();
    _connection = null;
    _connectedDevice = null;
    _isListening = false;
  }

  /// Disconnect from current connection
  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection!.close();
      _handleDisconnection();
    }
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _stateController.close();
    _connectionStateController.close();
  }
}

enum BluetoothConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}