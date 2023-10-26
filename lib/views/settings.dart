import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner_qr/controllers/constantes.dart';
import 'package:scanner_qr/modelo/app_settings.dart';
import 'package:scanner_qr/views/qr_scanner.dart';

class Settings extends StatefulWidget {
  
  Constantes constantes;

  Settings({super.key, required this.constantes});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setDefaultValues();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(context),
                SizedBox(height: 30),
                _serverUriField(context),
                SizedBox(height: 25),
                _portField(context),
                SizedBox(height: 50),
                _saveButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setDefaultValues() async {
    bool existeArchivo = await widget.constantes.existFile();
    if (existeArchivo) {
      AppSettings? appSettings = await widget.constantes.leerObjetoDesdeArchivo();
      if (appSettings != null) {
        _addressController.text = appSettings.address;
        _portController.text = appSettings.port;
        // Guardamos las settings en constantes
        widget.constantes.appSettings = appSettings;
      }
    }
  }

  _header(context) {
    final headerIcon = Image.asset(
      "lib/assets/codigobarras.jpg",
      height: 200,
      width: 200,
    );

    return SizedBox(
      height: 200, // Specify a height for the SizedBox
      width: 200,  // Specify a width for the SizedBox
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
        labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Color.fromARGB(132, 0, 0, 0)),
        ),
        fillColor: Color.fromARGB(255, 80, 80, 80).withOpacity(0.1),
        filled: true,
      ),
      cursorColor: Color.fromARGB(255, 0, 0, 0),
      controller: _addressController,
    );
  }

_portField(context) {
  return TextField(
    decoration: InputDecoration(
      labelText: "Puerto",
      labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
      ),
      fillColor: Color.fromARGB(255, 80, 80, 80).withOpacity(0.1),
      filled: true,
    ),
    cursorColor: Color.fromARGB(255, 0, 0, 0),
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
        widget.constantes.guardarSettingsEnArchivo(appSettings);
        widget.constantes.appSettings = appSettings;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QRScanner(constantes: widget.constantes,)),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      child: const Text(
        "Guardar",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}