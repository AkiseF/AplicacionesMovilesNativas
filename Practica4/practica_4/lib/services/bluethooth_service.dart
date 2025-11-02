import 'dart:async';
import 'dart:convert';
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
    return BluetoothGameMessage(
      type: BluetoothGameMessageType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      data: json['data'] as Map<String, dynamic>,
    );
  }

  String serialize() => jsonEncode(toJson());

  factory BluetoothGameMessage.deserialize(String data) {
    return BluetoothGameMessage.fromJson(jsonDecode(data));
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
    final state = await _bluetooth.state;
    _stateController.add(state);

    // Listen to state changes
    _bluetooth.onStateChanged().listen((state) {
      _stateController.add(state);
    });
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
    return await _bluetooth.getBondedDevices();
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
    final result = await _bluetooth.requestDiscoverable(timeout);
    return result != null && result > 0;
  }

  /// Start server (host) - wait for incoming connections
  Future<bool> startServer() async {
    if (_isListening) return false;
    
    _isHost = true;
    _isListening = true;

    try {
      // Make device discoverable
      await makeDiscoverable();
      
      // Esperar conexiones entrantes
      await _bluetooth.requestEnable();
      
      print('🎮 Servidor Bluetooth iniciado, esperando conexiones...');
      print('📱 Haz que el otro dispositivo se conecte a este');
      
      // Nota: flutter_bluetooth_serial no tiene un método directo para crear servidor
      // El host debe esperar a que el cliente se conecte usando connectToDevice
      // Este es un approach simplificado - en producción considerarías usar sockets
      
      _isListening = true;
      return true;
    } catch (e) {
      print('❌ Error al iniciar servidor: $e');
      _isListening = false;
      return false;
    }
  }

  /// Connect to device (client)
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      print('📡 Conectando a ${device.name}...');
      
      // ✅ CORREGIDO: Sin el parámetro uuid
      final connection = await BluetoothConnection.toAddress(device.address);
      _handleConnection(connection);
      _connectedDevice = device;
      _isHost = false;

      print('✅ Conectado a ${device.name}');
      return true;
    } catch (e) {
      print('❌ Error al conectar: $e');
      return false;
    }
  }

  /// Handle established connection
  void _handleConnection(BluetoothConnection connection) {
    _connection = connection;
    _connectionStateController.add(BluetoothConnectionState.connected);

    // Listen to incoming messages
    _connection!.input!.listen(
      (data) {
        try {
          final message = utf8.decode(data);
          final gameMessage = BluetoothGameMessage.deserialize(message);
          _messageController.add(gameMessage);
          print('📨 Mensaje recibido: ${gameMessage.type}');
        } catch (e) {
          print('❌ Error al procesar mensaje: $e');
        }
      },
      onDone: () {
        print('🔌 Conexión cerrada');
        _handleDisconnection();
      },
      onError: (error) {
        print('❌ Error en conexión: $error');
        _handleDisconnection();
      },
    );
  }

  /// Send message through Bluetooth
  Future<bool> sendMessage(BluetoothGameMessage message) async {
    if (!isConnected) {
      print('❌ No hay conexión activa');
      return false;
    }

    try {
      final data = message.serialize();
      _connection!.output.add(utf8.encode(data));
      await _connection!.output.allSent;
      print('📤 Mensaje enviado: ${message.type}');
      return true;
    } catch (e) {
      print('❌ Error al enviar mensaje: $e');
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