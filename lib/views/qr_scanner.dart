import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanner_qr/controllers/DropdownButton.dart';
import 'package:scanner_qr/controllers/constantes.dart';
import 'package:scanner_qr/modelo/app_settings.dart';
import 'package:scanner_qr/views/result_screen.dart';
import 'package:scanner_qr/modelo/scanned_data_model.dart';
import 'package:provider/provider.dart';
import 'package:scanner_qr/views/settings.dart';

class QRScanner extends StatefulWidget {
  final Constantes constantes;

  const QRScanner({super.key, required this.constantes});

  @override
  QRScannerState createState() => QRScannerState();
}

class QRScannerState extends State<QRScanner> with WidgetsBindingObserver {
  String scannedData = "";
  List<String> scannedResults = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (mounted) {
      super.initState();
      WidgetsBinding.instance.addObserver(this);
      _setDefaultValues();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _setDefaultValues() async {
    bool existeArchivo = await widget.constantes.existFile();
    if (existeArchivo) {
      AppSettings? appSettings =
          await widget.constantes.leerObjetoDesdeArchivo();
      if (appSettings != null) {
        widget.constantes.appSettings = appSettings;
      }
    } else {
      // Abrimos la pantalla de configuración
      _showErrorDialog("No se ha encontrado el archivo de configuración");
      //dar un delay de dos segundos
      Future.delayed(const Duration(seconds: 2), () {
        _toSettings();
      });
    }
  }

  void _toSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Settings(
          constantes: widget.constantes,
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Puedes agregar código aquí si es necesario
    }
  }

  //Funcion para escanear el codigo de barras
  void startBarcodeScan() async {
    try {
      String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        "#FF0000", // Color personalizado para el botón de escaneo
        "Cancelar", // Texto del botón de cancelar
        true, // Mostrar luz de flash
        ScanMode.BARCODE, // Modo de escaneo (código de barras)
      );

      if (barcodeScanResult != '-1') {
        print(barcodeScanResult);
        navigateToSecondScreen(barcodeScanResult, "Scanned");
      }
    } on PlatformException {
      _showErrorDialog("Error al escanear el código");
    } catch (e) {
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
              style: TextStyle(fontWeight: FontWeight.w800)),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Volver",
                  style: TextStyle(
                      color: Color.fromARGB(255, 145, 14, 2),
                      fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );
  }

  // Funcion que servira par detectar el sistema operativo y mostrar el icono correspondiente
  bool isIOS() {
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  // Funcion para mostrar el teclado y que el usuario pueda poner el codigo de barras
  // Eliminar y Recogida
  void _showKeyboardDialog() async {
    DropdownButtonWidget dropdownButtonWidget = DropdownButtonWidget();
    bool pass =false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingresa el número'),
          content: TextField(
            decoration: InputDecoration(
              labelText: 'Número',
              labelStyle: const TextStyle(color: Colors.black),
              hintStyle: const TextStyle(color: Colors.black),
              hintText: 'Ingresa un número',
              hoverColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              contentPadding: const EdgeInsets.all(15.0),
            ),
            controller: controller,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            dropdownButtonWidget,
            TextButton(
              child: const Text(
                'Enviar',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13.2,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmación'),
                      content:
                          const Text('¿Estás seguro de que quieres enviarlo?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          
                          child: const Text('Confirmar'),
                          onPressed: () {
                            String number = controller.text;
                            // Comprueba si el número no está vacío
                            if (number != null && number.trim().isNotEmpty) {
                              // Guardar el número en SharedPreferences
                              //Reinciamos el valor del textfield
                              controller.text = "";
                              number = controller.text;
                              Navigator.of(context).pop();
                              // Enviamos el número y el valor seleccionado a la siguiente pantalla
                              navigateToSecondScreen(
                                  number, dropdownButtonWidget.selectedValue);
                            } else {
                              // Muestra un mensaje de error si el número está vacío
                               Navigator.of(context).pop();
                              
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToSecondScreen(String data, String? typeResult) {
    Provider.of<ScannedDataModel>(context, listen: false).addScannedData(data);
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: ResultScreen(
            constantes: widget.constantes,
            scannedData: data,
            type: typeResult,
          ),
        ),
      ),
    );
  }

  // Funciones para construir la interfaz de usuario en la parte superior
  Widget _buildHead(String firstText, String secondText) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            firstText,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13.2,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            secondText,
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Expanded(
      flex: 6,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var result
                in Provider.of<ScannedDataModel>(context).scannedResults)
              Card(
                child: ListTile(
                  title: Text(result),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTail(String text) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget buildAppbar(String title, BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(44, 208, 255, 0),
      toolbarHeight: 35,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
          fontFamily: 'Arial',
        ),
      ),
      leading: IconButton(
        icon: isIOS()
            ? const Icon(CupertinoIcons.settings_solid,
                color: Color.fromARGB(255, 0, 0, 0))
            : const Icon(Icons.settings, color: Color.fromARGB(255, 0, 0, 0)),
        onPressed: () {
          // Navega a la pestaña de configuración
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Settings(
                constantes: widget.constantes,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCameraIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          heroTag: "btn2",
          backgroundColor: const Color.fromARGB(132, 234, 254, 143),
          onPressed: () {
            startBarcodeScan();
          },
          child: isIOS()
              ? const Icon(CupertinoIcons.photo_camera_solid,
                  color: Color.fromARGB(255, 0, 0, 0))
              : const Icon(Icons.camera_alt,
                  color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
    );
  }

  //Creamos un boton para que el usuario pueda poner el codigo de barras por teclado
  Widget _buildKeyboardIcon() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          heroTag: "btn1",
          backgroundColor: const Color.fromARGB(132, 234, 254, 143),
          onPressed: () {
            _showKeyboardDialog();
          },
          child: isIOS()
              ? const Icon(CupertinoIcons.keyboard,
                  color: Color.fromARGB(255, 0, 0, 0))
              : const Icon(Icons.keyboard, color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar("BARD VISION", context),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHead("Pon el código de barras dentro del área de escaneo:",
                "Lista de códigos escaneados:"),
            _buildList(),
            _buildTail("Desarrollado por: Gistra.sl"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildKeyboardIcon(),
                _buildCameraIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
