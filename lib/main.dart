import 'package:flutter/material.dart';
import 'package:scanner_qr/qr_scanner.dart';
import 'package:scanner_qr/scanned_data_model.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => ScannedDataModel(),
        child: MaterialApp(
          home: QRScanner(),
        ),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(0, 246, 28, 86),
          elevation: 0,
          toolbarHeight: 30,
        ),
      ),
      home: QRScanner(),
      debugShowCheckedModeBanner: false,
      title: 'QR Code Scanner',
    );
  }
}
