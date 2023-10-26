import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:animations/animations.dart';
import 'package:scanner_qr/controllers/constantes.dart';
import 'package:scanner_qr/modelo/app_settings.dart';
import 'package:scanner_qr/views/result_screen.dart';
import 'package:scanner_qr/modelo/scanned_data_model.dart';
import 'package:provider/provider.dart';
import 'package:scanner_qr/views/settings.dart';


class QRScanner extends StatefulWidget {
  final Constantes constantes;
  
  const QRScanner({super.key,  required this.constantes});

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> with WidgetsBindingObserver {
  String scannedData = "";
  List<String> scannedResults = [];

  @override
  void initState() {
    if(mounted){
      super.initState();
      WidgetsBinding.instance!.addObserver(this);
      _setDefaultValues();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
  _setDefaultValues() async {
    if(mounted){
      bool existeArchivo = await widget.constantes.existFile();
      if (existeArchivo) {
        AppSettings? appSettings = await widget.constantes.leerObjetoDesdeArchivo();
        if (appSettings != null) {
          widget.constantes.appSettings = appSettings;
        }
      }else{
        // Abrimos la pantalla de configuración
        _showErrorDialog("No se ha encontrado el archivo de configuración");
        _toSettings();
      }
    }
  }


  void _toSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Settings(constantes: widget.constantes,),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Puedes agregar código aquí si es necesario
    }
  }

  void startBarcodeScan() async {
    try{
    String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      "#FF0000", // Color personalizado para el botón de escaneo
      "Cancelar", // Texto del botón de cancelar
      true, // Mostrar luz de flash
      ScanMode.BARCODE, // Modo de escaneo (código de barras)
    );

    if (barcodeScanResult != '-1') {
      navigateToSecondScreen(barcodeScanResult);
    }
    }on PlatformException{
      _showErrorDialog("Error al escanear el código");
    }catch(e){
      _showErrorDialog("Error desconocido $e");
    }
  }

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
              child: const Text("Volver",
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


  void navigateToSecondScreen(String data) {
    print("data: $data");

    print("------------------");

    Provider.of<ScannedDataModel>(context, listen: false).addScannedData(data);

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: ResultScreen(constantes: widget.constantes,scannedData: data),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(44, 208, 255, 0),
        toolbarHeight: 35,
        elevation: 0,
         shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.settings,
          color:  Color.fromARGB(255, 0, 0, 0),),
          onPressed: () {
            // Navega a la pestaña de configuración
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Settings(constantes: widget.constantes,),
              ),
            );
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 0,
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
                      "Lista de códigos escaneados:",
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var result in Provider.of<ScannedDataModel>(context).scannedResults)
                      Card(
                        child: ListTile(
                          title: Text(result),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Container(
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Desarrollado por: Gistra.sl",
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
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  backgroundColor: Color.fromARGB(132, 234, 254, 143),
                  onPressed: () {
                    startBarcodeScan();
                  },
                  child: const Icon(Icons.camera_alt,
                  color:  Color.fromARGB(255, 0, 0, 0),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}