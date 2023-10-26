import 'dart:convert';
import 'dart:io';

import 'package:scanner_qr/modelo/app_settings.dart';
import 'package:path_provider/path_provider.dart';

class Constantes{

  final String filePath;
  // Constructor Vacio
  Constantes({required this.filePath}); 

  
    // Guardamos el objeto AppSettings en constantes
  AppSettings? appSettings;

   final appDocumentsDirectory =  getApplicationDocumentsDirectory();
  final appSupportDirectory =  getApplicationSupportDirectory();

  // ------------------Metodos para guardar y recuperar las Settings----------------

  // Metodo para guardar las settings en un archivo
  Future<void> guardarSettingsEnArchivo(AppSettings appSettings) async {
    try {
      final file = File(filePath);
      // Convierte el objeto a un mapa
      Map<String, dynamic> objetoMap = appSettings.toMap();
      // Convierte el mapa a una cadena JSON
      String objetoJson = jsonEncode(objetoMap);
      // Escribe la cadena JSON en el archivo
      await file.writeAsString(objetoJson);
      //_logger.info('Configuraciones guardadas correctamente.');
      //print('Configuraciones guardadas correctamente.');
    } catch (e) {
      //_logger.severe('Error al guardar las configuraciones: $e');
      //print('Error al guardar las configuraciones: $e');
      // Puedes lanzar una excepción o manejar el error de otra manera según tus necesidades.
    }
  }

  // Metodo para leer las settings desde un archivo
  Future<AppSettings?> leerObjetoDesdeArchivo() async {
    try {
      final file = File(filePath);
      // Lee el contenido del archivo como una cadena JSON
      String contenido = await file.readAsString();
      // Decodifica la cadena JSON a un mapa
      Map<String, dynamic> objetoMap = jsonDecode(contenido);
      //_logger.info('Configuraciones leídas correctamente.');
      // Crea un objeto MiObjeto a partir del mapa
      //print(objetoMap);
      return AppSettings.fromMap(objetoMap);
    } catch (e) {
     // _logger.severe('Error al leer el archivo: $e');
      print('Error al leer el archivo: $e');
      return null;
    }
  }

  // Metodo para verificar si existe el archivo
  Future<bool> existFile() async {
    try {
      // guardar el file dentro de assets
      final file = File(filePath);
      //print("Este es el path "+filePath);
      bool existe = await file.exists();
      return existe;
    } catch (e) {
     // _logger.severe('Error al verificar si existe el archivo: $e');
      print('Error al verificar si existe el archivo: $e');
      return false;
    }
  }


}