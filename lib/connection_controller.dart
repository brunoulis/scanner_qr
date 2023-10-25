import 'package:web_socket_channel/io.dart';

class ConnectionController {
  static const String _webSocketUrl = 'ws://localhost:8080'; // URL del servidor WebSocket

  // Constructor vacio
  ConnectionController();

  static Future<bool> checkWebSocketConnection() async {
    try {
      final channel = IOWebSocketChannel.connect(_webSocketUrl); // Conexión al servidor WebSocket
      await channel.stream.first; // Espera a recibir el primer mensaje del servidor
      await channel.sink.close(); // Cierra la conexión
      return true; // La conexión fue exitosa
    } catch (e) {
      return false; // La conexión falló
    }
  }
}
