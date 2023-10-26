import 'dart:convert';
import 'dart:io';

import 'package:scanner_qr/modelo/tipo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionController {
  //8970
  //45782

  static WebSocketChannel? _channel; // Propiedad estática para almacenar la conexión WebSocket

  // Constructor vacio
  ConnectionController();

  static Future<bool> isHostReachable(String host, int port, {Duration timeout = const Duration(seconds: 2)}) async {
    try {
      final socket = await Socket.connect(host, port, timeout: timeout);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Funcion usando dart:io para enviar datos por WebSocket
  static Future<Tipo?> sendaDataWithio(String data, String host, int port) async {
    try {
      if (await isHostReachable(host, port)) {
        _channel ??= WebSocketChannel.connect(
              Uri.parse('ws://$host:$port/803672868'),
              protocols: ['echo-protocol']);
        _channel!.sink.add(data);
        // Escucha la respuesta del servidor
        final respuesta = await _channel!.stream.first;
        print(respuesta);
        Map<String, dynamic> jsonMap = jsonDecode(respuesta);
        Tipo? tipo = Tipo.fromJson(jsonMap);
        print(jsonMap);
        return tipo;
      } else {
        print("No se pudo conectar con el servidor");
        return null;
      }
    } on WebSocketChannelException {
      print("Error WebSocketChannelException");
      return null;
    } catch (e) {
      print("Error al enviar el dato");
      print(e);
      return null;
    }
  }


  static void closeConnection() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
  }

}