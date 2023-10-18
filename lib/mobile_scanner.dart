import 'package:flutter/material.dart';

class QRScanner extends StatelessWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(),
      ),
    );
  }
}
