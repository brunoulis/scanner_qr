import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:animations/animations.dart';
import 'package:scanner_qr/result_screen.dart';

void main() => runApp(MaterialApp(home: QRScanner()));

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> with WidgetsBindingObserver {
  String scannedData = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Puedes agregar código aquí si es necesario
    }
  }

  void startBarcodeScan() async {
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      "#FF0000", // Color personalizado para el botón de escaneo
      "Cancelar", // Texto del botón de cancelar
      true, // Mostrar luz de flash
      ScanMode.BARCODE, // Modo de escaneo (código de barras)
    );

    if (barcodeScanResult != '-1') {
      navigateToSecondScreen(barcodeScanResult);
    }
  }

  void navigateToSecondScreen(String data) {
    print("data: $data");
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: ResultScreen(scannedData: data),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Scanner de Códigos',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Pon el código de barras dentro del área de escaneo:",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "El escaneo se iniciará automáticamente",
                      style: TextStyle(
                        fontSize: 12.9,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color.fromARGB(255, 209, 209, 209),
                    width: 10,
                  ),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      startBarcodeScan();
                    },
                    child: Text("Escanear código de barras"),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Desarrollado por: Tu Nombre",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


