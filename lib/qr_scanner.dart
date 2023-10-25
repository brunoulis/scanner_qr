import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scanner_qr/result_screen.dart';

void main() => runApp(MaterialApp(home: QRScanner()));

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> with WidgetsBindingObserver {
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String scannedData = "";
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        controller!.resumeCamera();
      }
    }
  }

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
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // ajusta el radio de las esquinas
                  border: Border.all(
                    color: Color.fromARGB(255, 209, 209, 209),
                    width: 10,
                  ),
                ),
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
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: IconButton(
                        icon: Icon(
                          isFlashOn ? Icons.flash_off : Icons.flash_on,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (controller != null) {
                            controller!.toggleFlash();
                            setState(() {
                              isFlashOn = !isFlashOn;
                            });
                          }
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (controller != null) {
                            controller!.flipCamera();
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
        controller.pauseCamera();
        navigateToSecondScreen(scannedData);
      });
    });
  }

  void navigateToSecondScreen(String data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultScreen(scannedData: data),
      ),
    ).then((value) {
      if (controller != null) {
        controller!.resumeCamera();
      }
    });
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
