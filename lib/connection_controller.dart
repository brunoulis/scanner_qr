import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectionController {
  static const String webSocketUrl = 'ws://192.168.14.89:8970/ws'; // URL del servidor WebSocket

  // Constructor vacio
  ConnectionController();



// Funcion usando dart:io para enviar datos por WebSocket
static Future<void> sendaDataWithio(String data) async{
  try{
    final channel = WebSocketChannel.connect(Uri.parse('wss://192.168.14.89:8970/803672868'),);
    channel.sink.add(data);
    // Escucha la respuesta del servidor
    final respuesta = await channel.stream.first;
    print(respuesta);
    
  }catch(e){
    print("Error al enviar el dato");
    print(e);
  }


}


}
