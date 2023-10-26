import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner_qr/controllers/constantes.dart';
import 'package:scanner_qr/views/qr_scanner.dart';
import 'package:scanner_qr/modelo/scanned_data_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Inicializamos los plugins.
  // Obtenemos el directorio de documentos de la aplicación.
  final appDocumentsDirectory = await getApplicationDocumentsDirectory();
  // Obtenemos el directorio de soporte de la aplicación.
  final appSupportDirectory = await getApplicationSupportDirectory();
  // Obtenemos la ruta del archivo de configuración.
  final filePath = '${appDocumentsDirectory.path}/settings.txt';
  // Creamos una instancia de la clase Constantes.
  final Constantes constantes = Constantes(filePath:filePath);
  // Ejecutamos la aplicación.
    runApp(
      ChangeNotifierProvider(
        create: (context) => ScannedDataModel(),
        child: MaterialApp(
          home: QRScanner(constantes: constantes,),
        ),
      ),

    );
}
class MyApp extends StatelessWidget {
  final Constantes constantes;
  const MyApp({super.key, required this.constantes});

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
      home: QRScanner(constantes: constantes,),
      debugShowCheckedModeBanner: false,
      title: 'QR Code Scanner',
    );
  }
}
