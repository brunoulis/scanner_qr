import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String scannedData;

  ResultScreen({required this.scannedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Result'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Text(
          'QR Code Scanned: $scannedData',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}