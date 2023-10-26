class Tipo {
  final String event;
  final int error;
  final descripcion;

  Tipo({
    required this.event,
    required this.error,
    required this.descripcion,});

  
  factory Tipo.fromJson(Map<String, dynamic> json) {
    return Tipo(
      event: json['type']['event'],
      error: json['type']['error'],
      descripcion: json['type']['descripcion'],
    );
  }

}
