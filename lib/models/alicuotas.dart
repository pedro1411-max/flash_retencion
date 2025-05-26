// Clase que representa cada objeto del JSON
class Entidad {
  String txtNombre;
  String txtDireccion;
  String txtStatus;
  String txtIdCodigo;
  String txtCodigoActividad;
  String txtDescripcion;
  double txtAlicuota;

  // Constructor de la clase
  Entidad({
    required this.txtNombre,
    required this.txtDireccion,
    required this.txtStatus,
    required this.txtIdCodigo,
    required this.txtCodigoActividad,
    required this.txtDescripcion,
    required this.txtAlicuota,
  });

  // Método para convertir un mapa (JSON) en un objeto Agroindustria
  factory Entidad.fromJson(Map<String, dynamic> json) {
    return Entidad(
      txtNombre: json['txtnombre'],
      txtDireccion: json['txtdireccion'],
      txtStatus: json['txtstatus'].trim(),
      txtIdCodigo: json['txtidcodigo'],
      txtCodigoActividad: json['txtcodigoactividad'],
      txtDescripcion: json['txtdescripcion'],
      txtAlicuota: double.parse(json['txtalicuota']),
    );
  }

  // Método para convertir un objeto Agroindustria en un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'txtnombre': txtNombre,
      'txtdireccion': txtDireccion,
      'txtstatus': txtStatus,
      'txtidcodigo': txtIdCodigo,
      'txtcodigoactividad': txtCodigoActividad,
      'txtdescripcion': txtDescripcion,
      'txtalicuota': txtAlicuota.toStringAsFixed(2),
    };
  }
}

// Clase para manejar una lista de objetos Agroindustria
class EntidadList {
  List<Entidad> items;

  // Constructor
  EntidadList({required this.items});

  // Método para convertir una lista de mapas (JSON) en una lista de objetos Agroindustria
  factory EntidadList.fromJsonList(List<dynamic> jsonList) {
    return EntidadList(
      items: jsonList.map((item) => Entidad.fromJson(item)).toList(),
    );
  }

  // Método para convertir una lista de objetos Agroindustria en una lista de mapas (JSON)
  List<Map<String, dynamic>> toJsonList() {
    return items.map((item) => item.toJson()).toList();
  }
}
