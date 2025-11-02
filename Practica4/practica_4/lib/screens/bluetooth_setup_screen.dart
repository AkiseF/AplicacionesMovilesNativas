import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import '../services/bluethooth_service.dart';
import '../providers/game_provider.dart';
import '../models/game_session.dart';
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
  List<BluetoothDiscoveryResult> _discoveredDevices = [];
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
    _setupListeners();
  }

  Future<void> _initializeBluetooth() async {
    await _bluetoothService.initialize();
    final isEnabled = await _bluetoothService.isBluetoothEnabled();
    
    setState(() {
      _isBluetoothEnabled = isEnabled;
    });

    if (isEnabled) {
      _loadBondedDevices();
    }
  }

  void _setupListeners() {
    // Listen to Bluetooth state changes
    _bluetoothService.stateStream.listen((state) {
      setState(() {
        _isBluetoothEnabled = state == BluetoothState.STATE_ON;
      });
    });

    // Listen to connection state changes
    _bluetoothService.connectionStateStream.listen((state) {
      setState(() {
        _connectionState = state;
      });

      if (state == BluetoothConnectionState.connected) {
        _onConnectionEstablished();
      }
    });

    // Listen to incoming messages
    _bluetoothService.messageStream.listen((message) {
      _handleIncomingMessage(message);
    });
  }

  Future<void> _loadBondedDevices() async {
    final devices = await _bluetoothService.getBondedDevices();
    setState(() {
      _bondedDevices = devices;
    });
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

    _bluetoothService.startDiscovery().listen((result) {
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
    }).onDone(() {
      setState(() {
        _isScanning = false;
      });
    });
  }

  void _stopDeviceDiscovery() {
    _bluetoothService.cancelDiscovery();
    setState(() {
      _isScanning = false;
    });
  }

  Future<void> _startAsHost() async {
    setState(() {
      _isHost = true;
      _isWaitingForConnection = true;
    });

    final success = await _bluetoothService.startServer();
    
    if (!success) {
      setState(() {
        _isWaitingForConnection = false;
      });
      _showSnackBar('Error al iniciar el servidor', isError: true);
    } else {
      _showSnackBar('Esperando conexión de otro jugador...');
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _connectionState = BluetoothConnectionState.connecting;
    });

    final success = await _bluetoothService.connectToDevice(device);
    
    if (!success) {
      setState(() {
        _connectionState = BluetoothConnectionState.disconnected;
      });
      _showSnackBar('No se pudo conectar a ${device.name ?? "dispositivo"}', isError: true);
    }
  }

  void _onConnectionEstablished() {
    _showSnackBar('Conexión establecida', isError: false);
    
    if (_isHost) {
      // Host selects difficulty and starts game
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const DifficultySelectionScreen(
            gameMode: GameMode.twoPlayer,
          ),
        ),
      );
    } else {
      // Client waits for game start from host
      _showSnackBar('Esperando que el anfitrión inicie el juego...');
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
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final difficulty = DifficultyLevel.values.firstWhere(
      (e) => e.name == message.data['difficulty'],
    );
    final characterIds = List<int>.from(message.data['characterIds']);
    
    // Navigate to game screen
    gameProvider.startNewGame(
      GameMode.twoPlayer,
      difficulty: difficulty,
    ).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const GameScreen(),
        ),
      );
    });
  }

  void _handleCharacterSelection(BluetoothGameMessage message) {
    // Handle when opponent selects character
    print('Oponente seleccionó personaje: ${message.data['characterName']}');
  }

  void _handleQuestion(BluetoothGameMessage message) {
    // Handle incoming question from opponent
    print('Pregunta recibida: ${message.data['questionText']}');
  }

  void _handleAnswer(BluetoothGameMessage message) {
    // Handle answer to your question
    print('Respuesta recibida: ${message.data['answer']}');
  }

  void _handleElimination(BluetoothGameMessage message) {
    // Handle character elimination from opponent
    print('Oponente eliminó personaje: ${message.data['characterId']}');
  }

  void _handleGuess(BluetoothGameMessage message) {
    // Handle final guess from opponent
    print('Oponente adivinó: ${message.data['characterId']}');
  }

  void _handleTurnChange(BluetoothGameMessage message) {
    // Handle turn change
    print('Cambio de turno');
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

  @override
  void dispose() {
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
                        color: Colors.blue.withOpacity(0.1),
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
                        color: Colors.green.withOpacity(0.1),
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