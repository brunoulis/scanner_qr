import 'package:flutter/material.dart';
import 'package:scanner_qr/connection_controller.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ResultScreen extends StatelessWidget {
  final String scannedData;

  ResultScreen({required this.scannedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Color.fromARGB(44, 208, 255, 0),
        toolbarHeight: 40,
        elevation: 0,
         shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        centerTitle: true,
        title: const Text('Resultado del Escaneo',
        style: TextStyle(
            color: Colors.black87,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Código Escaneado: $scannedData',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () async {
                await ConnectionController.sendaDataWithio(scannedData);
              },
              child: Text('Enviar por WebSocket'),
            ),
          ],
        ),
      ),
    );
  }
}
