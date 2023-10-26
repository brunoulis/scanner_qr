import 'dart:convert';
import 'dart:io';

import 'package:scanner_qr/modelo/tipo.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionController {
  static const String webSocketUrl = 'ws://192.168.14.89:8970/ws'; // URL del servidor WebSocket

  // Constructor vacio
  ConnectionController();



// Funcion usando dart:io para enviar datos por WebSocket
static Future<Tipo?> sendaDataWithio(String data) async{
  try{ 
    // Crea el canal de comunicacion con protocol tls (wss)
    // Diferentes tipos de protocolos: https://developer.mozilla.org/es/docs/Web/API/WebSockets_API/Writing_WebSocket_servers
    final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.14.89:8970/803672868'),protocols: ['echo-protocol']);
    channel.sink.add(data);
    // Escucha la respuesta del servidor
    final respuesta = await channel.stream.first;
    print(respuesta);
    Map<String, dynamic> jsonMap = jsonDecode(respuesta);
    Tipo? tipo = Tipo.fromJson(jsonMap);
    print(jsonMap);
    channel.sink.close();
    return tipo;
  }on  WebSocketChannelException {
    print("Error WebSocketChannelException");
    return null;
  }
  on SocketException{
    print("Error SocketException");
    return null;
  }
  catch(e){
    print("Error al enviar el dato");
    print(e);
    return null;
  }


}


}
