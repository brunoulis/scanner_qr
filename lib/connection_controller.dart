import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionController {
  static const String webSocketUrl = 'ws://192.168.14.89:8970/ws'; // URL del servidor WebSocket

  // Constructor vacio
  ConnectionController();



// Funcion usando dart:io para enviar datos por WebSocket
static Future<void> sendaDataWithio(String data) async{
  try{ 
    // Crea el canal de comunicacion con protocol tls (wss)
    // Diferentes tipos de protocolos: https://developer.mozilla.org/es/docs/Web/API/WebSockets_API/Writing_WebSocket_servers
    final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.14.89:8970/803672868'),protocols: ['echo-protocol']);
    channel.sink.add(data);
    // Escucha la respuesta del servidor
    final respuesta = await channel.stream.first;
    print(respuesta);
    channel.sink.close();
    
  }on  WebSocketChannelException {
    print("Error al enviar el dato");
  }catch(e){
    print("Error al enviar el dato");
    print(e);
  }


}


}
