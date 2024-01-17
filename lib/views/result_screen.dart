import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner_qr/controllers/connection_controller.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:scanner_qr/controllers/constantes.dart';
import 'package:scanner_qr/modelo/scanned_data_model.dart';
import 'package:scanner_qr/modelo/tipo.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final String scannedData;
  final Constantes constantes;
  final String? type;
  
  const ResultScreen(
      {super.key, required this.constantes, required this.scannedData,required this.type});

  
  @override
  ResultScreenState createState() => ResultScreenState();
}

class ResultScreenState extends State<ResultScreen> {
  // ignore: unused_field
  Tipo? _tipo;
  bool _loading = true;
  bool _error = false;

  IconData iconError = Icons.error_outline;
  IconData iconSuccess = Icons.check_circle_outline;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      //print("Datos escaneados "+widget.scannedData);
      
      sendData();
      
    }
  }

  @override
  void dispose() {
    super.dispose();
    ConnectionController.closeConnection();
  }

  void deleteElementList() {
    // Buscamos el dato en la lista de datos escaneados y lo eliminamos
    int index = Provider.of<ScannedDataModel>(context, listen: false)
        .scannedResults
        .indexOf(widget.scannedData);
    if (index != -1) {
      Provider.of<ScannedDataModel>(context, listen: false)
          .deleteScannedData(index);
    }
  }

  void sendData() async {
    Tipo? tipo;
    if (widget.type!= null){
      tipo = await ConnectionController.sendaDataWithioType(
          widget.scannedData,widget.type!,
          widget.constantes.appSettings!.address,
          int.parse(widget.constantes.appSettings!.port));
    }else{
      tipo = await ConnectionController.sendaDataWithio(
        widget.scannedData,
        widget.constantes.appSettings!.address,
        int.parse(widget.constantes.appSettings!.port));
    }
    
    if (tipo != null) {
      // Haz algo con el objeto tipo
      if (tipo.error == 0) {
        //print("Esta es la descripcion"+tipo.descripcion);
        _showSuccessSnackbar(tipo.descripcion);
        if (mounted) {
          setState(() {
            _tipo = tipo;
            _loading = false;
            _error = false;
          });
        }
      } else {
        _showErrorDialog(tipo.descripcion);
        _showErrorSnackbar("Vuelve a atrás y escanea de nuevo", 2);
        deleteElementList();
        if (mounted) {
          setState(() {
            _tipo = null;
            _loading = false;
            _error = true;
          });
        }
      }
    } else {
      _showErrorDialog("No se pudo conectar con el servidor");
      _showErrorSnackbar("Vuelve a atrás y escanea de nuevo", 1);
      deleteElementList();
      if (mounted) {
        setState(() {
          _tipo = null;
          _loading = false;
          _error = true;
        });
      }
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
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w800)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackbar(String message, int duracion) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: const Color.fromARGB(255, 155, 16, 16),
        duration: Duration(seconds: duracion),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(message, style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: const Color.fromARGB(255, 65, 148, 68),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  bool isIOS() {
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildState() {
    return Flexible(
      flex: 1,
      child: _error
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconError,
                  color: const Color.fromARGB(255, 187, 51, 41),
                ),
                const Text(
                  'Error al escanear el código',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 187, 51, 41)),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconSuccess,
                  color: const Color.fromARGB(255, 51, 117, 53),
                ),
                const Text(
                  'Código escaneado con éxito',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 51, 117, 53)),
                ),
              ],
            ),
    );
  }

  Widget _buildScannedData() {
    return Flexible(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: BarcodeWidget(
          barcode: Barcode.code128(),
          data: widget.scannedData,
          width: 250,
          height: 100,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(String title) {
    return AppBar(
      backgroundColor: const Color.fromARGB(44, 208, 255, 0),
      toolbarHeight: 40,
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
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      leading: IconButton(
        icon: isIOS()
            ? const Icon(
                CupertinoIcons.back,
                color: Colors.black,
              )
            : const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: _buildAppbar("Resultado del Escaneo"),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 0, 0)),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text() que mostrar si el escaneo fue exitoso o no
                  _buildState(),
                  _buildScannedData()
                ],
              ),
            ),
    );
  }
}
