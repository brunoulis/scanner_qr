import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QrSettings extends StatefulWidget {
  String data;

  QrSettings({super.key, required this.data});

  @override
  QrSettingsState createState() => QrSettingsState();
}

class QrSettingsState extends State<QrSettings>{
  // Vista en la que simplemente se muestra el código QR
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Código QR'),
      ),
      body: Center(
        child: QrImageView(
          data: widget.data,
          version: QrVersions.auto,
          size: 300.0,
        ),
      ),
    );
  }
}