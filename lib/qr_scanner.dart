import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scanner_qr/result_screen.dart';

void main() => runApp(MaterialApp(home: QRScanner()));

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'QR Code Scanner',
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
                      "Pon el código QR dentro del área de escaneo:",
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
              child: Stack(
                children: [
                  QRView(
                    key: qrKey,
                    onQRViewCreated: onQRViewCreated,
                    onPermissionSet: (crtl, p) => onPermissionSet(context, crtl, p),
                    overlay: QrScannerOverlayShape(
                      borderRadius: 10,
                      borderColor: Color.fromARGB(255, 246, 28, 86),
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 230,
                    )
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Developed by: GistraS.l",
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

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scannedData = scanData.code!;
        controller.dispose();
        navigateToSecondScreen(scannedData);
      });
    });
  }

  void navigateToSecondScreen(String data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultScreen(scannedData: data),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  
  onPermissionSet(BuildContext context, QRViewController crtl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No se ha concedido permiso para la cámara"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
