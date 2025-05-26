import 'package:flash_retencion/constanst.dart';
import 'package:flash_retencion/extension_methods/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<List?> buscarRif(context, String cedula, CedulaTipo? cedulaTipo) {
  TextEditingController capchaController = TextEditingController();
  String error = '';
  return showDialog<List?>(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder(
        future: () async {
          final imagen = await http.get(
            Uri.parse(
              'http://contribuyente.seniat.gob.ve/BuscaRif/Captcha.jpg',
            ),
          );

          final e = imagen.bodyBytes;

          return (e, imagen.headers);
        }(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bytes = Uint8List.fromList(snapshot.data!.$1.toList());

          final GlobalKey<FormState> formKey = GlobalKey<FormState>();

          return AlertDialog(
            content: SizedBox(
              width: 300,
              height: 150,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Image.memory(scale: 0.5, bytes),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        controller: capchaController,
                        validator: (value) {
                          if (error != '') {
                            return error;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    final responseee = await http.get(
                      Uri.parse(
                        // ignore: unnecessary_brace_in_string_interps
                        'http://contribuyente.seniat.gob.ve/BuscaRif/BuscaRif.jsp?${cedulaTipo == CedulaTipo.juridico || cedulaTipo == CedulaTipo.gubernamental ? 'p_rif' : 'p_cedula'}=${(cedulaTipo == CedulaTipo.juridico
                                ? 'j'
                                : cedulaTipo == CedulaTipo.gubernamental
                                ? 'g'
                                : '') + cedula}&codigo=${capchaController.text}',
                      ),
                      headers: {
                        'Cookie': snapshot.data!.$2['set-cookie'] ?? '',
                      },
                    );

                    RegExp exp = RegExp(
                      r'<b><font face="Verdana" size="2">[^<]*&nbsp;(?<name>[A-Za-zÀ-ÖØ-öø-ÿ. ,Ñ´]+)(\((?<namecomercial>[A-Za-zÀ-ÖØ-öø-ÿ. ,Ñ)(]+)\))?<\/b><\/font>',
                    );

                    RegExpMatch? match = exp.firstMatch(responseee.body);
                    print(responseee.body);
                    print(match?.namedGroup('name').toString());
                    RegExp ret = RegExp(
                      r'retención del (?<retencion>[0-9]+)% ',
                    );
                    RegExp act = RegExp(
                      r'Actividad Económica: (?<actividad>[A-Za-zÀ-ÖØ-öø-ÿ. ,Ñ´]+)',
                    );

                    RegExpMatch? match2 = ret.firstMatch(responseee.body);

                    RegExpMatch? match3 = act.firstMatch(responseee.body);
                    //Actividad Económica: (?<actividad>[A-Za-zÀ-ÖØ-öø-ÿ. ,Ñ´]+)

                    if (context.mounted) {
                      final nombre = match
                          ?.namedGroup('name')
                          .toString()
                          .split(' ')
                          .map((e) => e.toLowerCase().capitalize())
                          .join(' ')
                          .split('.')
                          .map((e) => e.capitalize())
                          .join('.');
                      final retencion = (match2?.namedGroup('retencion') == null
                          ? "0"
                          : match2?.namedGroup('retencion').toString());
                      final actividad = match3
                          ?.namedGroup('actividad')
                          .toString();
                      if (nombre == null) {
                        error = 'Codigo no coincide con la imagen';
                      } else {
                        if (nombre == 'No Existe El Contribuyente Solicitado') {
                          error = nombre;
                        } else {
                          error = '';
                        }
                      }

                      if (formKey.currentState!.validate()) {
                        Navigator.of(
                          context,
                        ).pop([nombre, retencion, actividad]);
                      }
                    }
                  } catch (e, b) {
                    debugPrint('$e $b');
                  }
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    },
  );
}
