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

  ResultScreen({required this.constantes,required this.scannedData});

  @override
  ResultScreenState createState() => ResultScreenState();


}

class ResultScreenState extends State<ResultScreen> {
  Tipo? _tipo;
  bool _loading = true;


  @override
  void initState() {
    if(mounted){
      super.initState();
      sendData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    ConnectionController.closeConnection();
  }

  void deleteElementList(){
    // Buscamos el dato en la lista de datos escaneados y lo eliminamos  
      int index = Provider.of<ScannedDataModel>(context, listen: false).scannedResults.indexOf(widget.scannedData);
      if (index != -1) {
      Provider.of<ScannedDataModel>(context, listen: false).deleteScannedData(index);
      }
  }


  void sendData() async {
    Tipo? tipo = await ConnectionController.sendaDataWithio(widget.scannedData,widget.constantes.appSettings!.address, int.parse(widget.constantes.appSettings!.port));
    if (tipo != null) {
      // Haz algo con el objeto tipo
      if(tipo.error==0){
        print("Esta es la descripcion"+tipo.descripcion);
        _showSuccessSnackbar(tipo.descripcion);
        if(mounted){
          setState(() {
            _tipo = tipo;
            _loading = false;
          });
        }
      }else{
        _showErrorDialog(tipo.descripcion);
        _showErrorSnackbar("Vuelve a atrás y escanea de nuevo");
        deleteElementList();
        if(mounted){
          setState(() {
            _tipo = null;
            _loading = false;
          });
        }
      }

      
    }else{
      _showErrorDialog("No se pudo conectar con el servidor");
      _showErrorSnackbar("Vuelve a atrás y escanea de nuevo");
      deleteElementList();
      if(mounted){
        setState(() {
          _tipo = null;
          _loading = false;
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
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w800
                            )
              ),
            ),
          ],
        );
      },
    );
  }

    void _showErrorSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Color.fromARGB(255, 155, 16, 16),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 65, 148, 68),
        duration: const Duration(seconds: 1),
      ),
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
      body:
         _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 0, 0)),
              ),
            )
        : Center(
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
            ],
          ),
        ),
    );
  }
}
