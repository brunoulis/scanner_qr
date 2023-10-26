import 'package:flutter/material.dart';
import 'package:scanner_qr/connection_controller.dart';
import 'package:barcode_widget/barcode_widget.dart';


class ResultScreen extends StatefulWidget {
  final String scannedData;

  ResultScreen({required this.scannedData});

  @override
  ResultScreenState createState() => ResultScreenState();


}

class ResultScreenState extends State<ResultScreen> {
  

   // Agrega esta función para mostrar el diálogo
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error',
          style: TextStyle(
            fontWeight: FontWeight.w800
           )
          ),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK",
                style: TextStyle(
                color: Color.fromARGB(255, 145, 14, 2),
                fontWeight: FontWeight.w800
                            )
              ),
            ),
          ],
        );
      },
    );
  }


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
            Container(
              margin: EdgeInsets.only(bottom: 16),
              child: BarcodeWidget(
                barcode: Barcode.code128(),
                data: widget.scannedData,
                width: 200,
                height: 80,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Text(
              'Código Escaneado: ${widget.scannedData}',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () async {
                await ConnectionController.sendaDataWithio(widget.scannedData);
              },
              child: Text('Enviar por WebSocket'),
            ),
          ],
        ),
      ),
    );
  }
}
