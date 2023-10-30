import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner_qr/controllers/constantes.dart';
import 'package:scanner_qr/modelo/app_settings.dart';
import 'package:scanner_qr/views/qr_scanner.dart';

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

  @override
  void initState() {
    super.initState();
    _setDefaultValues();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body : _loading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 6, 6, 6)),
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
                    Expanded(
                      flex: 1,
                      child:_cancelButton(context)
                    ),
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
      ),
    );
  }

  _setDefaultValues() async {
    bool existeArchivo = await widget.constantes.existFile();
    if (existeArchivo) {
      AppSettings? appSettings = await widget.constantes.leerObjetoDesdeArchivo();
      if (appSettings != null) {
        _addressController.text = appSettings.address;
        // ignore: unnecessary_null_comparison
        if (appSettings.port =="" || appSettings.port == null) {
          _portController.text = "8970";
          appSettings.port =_portController.text;
        }else{
          _portController.text = appSettings.port;
        }
        // Guardamos las settings en constantes
        widget.constantes.appSettings = appSettings;
      }
    }else{
      _portController.text = "8970";
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
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 65, 148, 68),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  void _showCancelSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
        widget.constantes.guardarSettingsEnArchivo(appSettings);
        widget.constantes.appSettings = appSettings;
        _showSuccessSnackbar("Configuración guardada");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QRScanner(constantes: widget.constantes,)),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(35.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      child: const Text(
        "Guardar",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
  _cancelButton(context) {
    return ElevatedButton(
      onPressed: () {
        _showCancelSnackbar("No se guardaron los cambios");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QRScanner(constantes: widget.constantes,)),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(35.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: const Color.fromARGB(255, 145, 14, 2),
      ),
      child: const Text(
        "Cancelar",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}