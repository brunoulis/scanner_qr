import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner_qr/controllers/colors.dart';
import 'package:scanner_qr/controllers/constantes.dart';
import 'package:scanner_qr/views/qr_scanner.dart';
import 'package:scanner_qr/modelo/scanned_data_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Inicializamos los plugins.
  // Obtenemos el directorio de documentos de la aplicación.
  final appDocumentsDirectory = await getApplicationDocumentsDirectory();
  // Obtenemos el directorio de soporte de la aplicación.
  // ignore: unused_local_variable
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
          theme: ThemeData(
            primarySwatch: primary,
          ),
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
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 145, 14, 2),
        appBarTheme: const AppBarTheme(
          color: primary,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        //primarySwatch: primary,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Color.fromARGB(255, 145, 14, 2)), 
          iconColor: Color.fromARGB(255, 145, 14, 2), 
          prefixIconColor: Color(0xFFEAFE8F),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 145, 14, 2), width: 2.0),
             
          )),

        visualDensity: VisualDensity.adaptivePlatformDensity,
        
      )
      );
  }
  //backgroundColor: Color.fromARGB(0, 246, 28, 86),
}
