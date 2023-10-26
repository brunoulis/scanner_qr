class AppSettings {

  // AppSettings Es una clase que vamos a utilizar para mas tarde en la conexiones
  // Y donde instanciaremos los valores de la configuración de la aplicación
  String address;
  String port;

  AppSettings({required this.address, required this.port});

  // Metodo para convertir el objeto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'port': port,
    };
  }
  // FromMap es un metodo que nos permite convertir un mapa a un objeto
  // En este caso, un objeto de tipo AppSettings
  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      address: map['address'],
      port: map['port'],
    );
  }
}
