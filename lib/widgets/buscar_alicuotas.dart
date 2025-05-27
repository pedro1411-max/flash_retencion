import 'package:http/http.dart' as http;

import 'dart:convert';

Future<Map> busaralicuotas(context, String cedula) async {
  //String error = '';
  final json = await http.get(
    Uri.parse(
      'https://paez.pagosweb.com.ve/intra/api/agenteweb/consultarcomerciorif?txtrif=J$cedula',
    ),
  );

  List<dynamic> jsonData = jsonDecode(json.body);
  Map map = {};
  for (var element in jsonData) {
    map[element['txtdescripcion']] = element['txtalicuota'];
  }
  print(map);
  return map;
}
