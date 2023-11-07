// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scanner_qr/controllers/constantes.dart';
import 'package:scanner_qr/views/settings.dart';

class QrSettings extends StatefulWidget {
  String data;
  Constantes constantes;

  QrSettings({super.key, required this.data, required this.constantes});

  @override
  QrSettingsState createState() => QrSettingsState();
}

bool isIOS() {
  if (Platform.isIOS) {
    return true;
  } else {
    return false;
  }
}

class QrSettingsState extends State<QrSettings> {
  // Vista en la que simplemente se muestra el código QR
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Código QR'),
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Settings(
                              constantes: widget.constantes,
                            )));
              },
              icon: isIOS() ?const Icon(
                CupertinoIcons.back,
                color: Color.fromARGB(255, 0, 0, 0),
              ): const Icon(
                Icons.arrow_back,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
          ),
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
