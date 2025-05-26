import 'package:flash_retencion/models/alicuotas.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

Future<EntidadList> busaralicuotas(context, String cedula) async {
  //String error = '';
  final json = await http.get(
    Uri.parse(
      'https://paez.pagosweb.com.ve/intra/api/agenteweb/consultarcomerciorif?txtrif=J$cedula',
    ),
  );
  List<dynamic> jsonData = jsonDecode(json.body);
  EntidadList alicuotasList = EntidadList.fromJsonList(jsonData);
  return alicuotasList;
}
