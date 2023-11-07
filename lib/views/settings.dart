import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner_qr/controllers/constantes.dart';
import 'package:scanner_qr/modelo/app_settings.dart';
import 'package:scanner_qr/views/qr_scanner.dart';
import 'package:scanner_qr/views/settings/qr_settings.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  Constantes constantes;

  Settings({super.key, required this.constantes});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  bool _loading = true;
  String scannedData = "";
  List<String> scannedResults = [];

  @override
  void initState() {
    if (mounted) {
      super.initState();
      //WidgetsBinding.instance.addObserver(this);
      _setDefaultValues();
    }
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isIOS() {
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  void startBarcodeScan() async {
    try {
      String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        "#FF0000", // Color personalizado para el botón de escaneo
        "Cancelar", // Texto del botón de cancelar
        true, // Mostrar luz de flash
        ScanMode.BARCODE, // Modo de escaneo (código de barras)
      );

      if (barcodeScanResult != '-1') {
        //Verificamos que el resultado sea ip:puerto
        List<String> result = barcodeScanResult.split(":");
        if (result.length == 2) {
          _addressController.text = result[0];
          _portController.text = result[1];
        } else {
          _showErrorDialog("El código no es válido");
        }
      } else {
        _showErrorDialog("No se ha podido escanear el código");
      }
    } on PlatformException {
      _showErrorDialog("Error al escanear el código");
    } catch (e) {
      _showErrorDialog("Error desconocido $e");
    }
  }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              // Pasamos a la pantalla de qr_settings
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => QrSettings(
                          data:
                              "${widget.constantes.appSettings!.address}:${widget.constantes.appSettings!.port}",
                          constantes: widget.constantes,
                        )),
              );
            },
            icon:isIOS()? const Icon(
              CupertinoIcons.qrcode,
              color: Color.fromARGB(255, 0, 0, 0),
            ) : const Icon(
              Icons.qr_code_2,
              color: Color.fromARGB(255, 0, 0, 0),
            )
            ),
        actions: [
          IconButton(
            onPressed: () {
              startBarcodeScan();
            },
            icon: isIOS()
                ? const Icon(CupertinoIcons.qrcode_viewfinder,
                    color: Color.fromARGB(255, 0, 0, 0))
                : const Icon(Icons.qr_code_scanner_sharp,
                    color: Color.fromARGB(255, 0, 0, 0)),
          )
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 6, 6, 6)),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(context),
                    const SizedBox(height: 30),
                    _serverUriField(context),
                    const SizedBox(height: 25),
                    _portField(context),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(flex: 1, child: _cancelButton(context)),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: _saveButton(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _setDefaultValues() async {
    if (mounted) {
      bool existeArchivo = await widget.constantes.existFile();
      if (existeArchivo) {
        AppSettings? appSettings =
            await widget.constantes.leerObjetoDesdeArchivo();
        if (appSettings != null) {
          _addressController.text = appSettings.address;
          // ignore: unnecessary_null_comparison
          if (appSettings.port == "" || appSettings.port == null) {
            _portController.text = "8970";
            appSettings.port = _portController.text;
          } else {
            _portController.text = appSettings.port;
          }
          // Guardamos las settings en constantes
          widget.constantes.appSettings = appSettings;
        }
      } else {
        _portController.text = "8970";
      }
    }

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          backgroundColor: const Color.fromARGB(255, 65, 148, 68),
          duration: const Duration(seconds: 1),
          animation: CurvedAnimation(
            parent: const AlwaysStoppedAnimation(1),
            curve: Curves.bounceInOut,
          )),
    );
  }

  void _showCancelSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: const Color.fromARGB(255, 145, 14, 2),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  _header(context) {
    final headerIcon = Image.asset(
      "lib/assets/codigobarras.jpg",
      height: 200,
      width: 200,
    );

    return SizedBox(
      height: 200, // Specify a height for the SizedBox
      width: 200, // Specify a width for the SizedBox
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            top: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: headerIcon,
          ),
        ],
      ),
    );
  }

  _serverUriField(context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "URI del Servidor",
        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color.fromARGB(132, 0, 0, 0)),
        ),
        fillColor: const Color.fromARGB(255, 80, 80, 80).withOpacity(0.1),
        filled: true,
      ),
      cursorColor: const Color.fromARGB(255, 0, 0, 0),
      controller: _addressController,
    );
  }

  _portField(context) {
    return TextField(
      decoration: InputDecoration(
        labelText: "Puerto",
        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        fillColor: const Color.fromARGB(255, 80, 80, 80).withOpacity(0.1),
        filled: true,
      ),
      cursorColor: const Color.fromARGB(255, 0, 0, 0),
      controller: _portController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
    );
  }

  _saveButton(context) {
    return ElevatedButton(
      onPressed: () {
        // ToDo Guardar la configuración
        AppSettings appSettings = AppSettings(
          address: _addressController.text,
          port: _portController.text,
        );
        if (appSettings.port == "") {
          _portController.text = "8970";
          _showCancelSnackbar("El puerto no puede estar vacío");
          return;
        } else if (appSettings.address == "") {
          _showCancelSnackbar("La dirección no puede estar vacía");
          return;
        } else {
          widget.constantes.guardarSettingsEnArchivo(appSettings);
          widget.constantes.appSettings = appSettings;
        }

        _showSuccessSnackbar("Configuración guardada");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => QRScanner(
                    constantes: widget.constantes,
                  )),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 13),
        backgroundColor: Color.fromARGB(255, 57, 57, 57),
      ),
      child: const Text(
        "Guardar",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  _cancelButton(context) {
    return ElevatedButton(
      onPressed: () {
        _showCancelSnackbar("No se guardaron los cambios");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => QRScanner(
                    constantes: widget.constantes,
                  )),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(45.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 13),
        backgroundColor: Color.fromARGB(207, 104, 17, 9),
      ),
      child: const Text(
        "Cancelar",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
