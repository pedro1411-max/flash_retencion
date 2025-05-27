import 'package:flash_retencion/constanst.dart';
import 'package:flash_retencion/screens/facture.dart';
import 'package:flash_retencion/widgets/buscar_alicuotas.dart';
import 'package:flash_retencion/widgets/buscar_rif.dart';
import 'package:flutter/material.dart';

TextEditingController retencionController = TextEditingController();
TextEditingController activityController = TextEditingController();
TextEditingController documentoController = TextEditingController();
TextEditingController nombreController = TextEditingController();
CedulaTipo? cedulaTipo = CedulaTipo.venezolano;
Map alicuota = {};
List<String> actidades = [];
String? actividadalicuota;

class CreateFacture extends StatefulWidget {
  const CreateFacture({super.key});
  @override
  State<CreateFacture> createState() => _CreateFatureState();
}

class _CreateFatureState extends State<CreateFacture> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CompraTipo? compraTipo = CompraTipo.compra;
  PorcentajeTipo? porcentajeTipo = PorcentajeTipo.p2;
  bool? checkedValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          "Modelo de Retencion",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Documento de identidad: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${cedulaTipo!.name[0].toString().toUpperCase()}-${documentoController.text}",
              ),
            ],
          ),
          Text("Nombre: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(nombreController.text.toString()),
          Text(
            "Actividad Economica",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(activityController.text),
          SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Descripcion",
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Retencion (IVA)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: TextFormField(
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffix: Text("%"),
                  ),
                  controller: retencionController,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 15),
              Text(
                'Impuesto sobre la renta',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            child: CheckboxListTile(
              title: Text("Excento de ISLR"),
              value: checkedValue,
              onChanged: (newValue) {
                setState(() {
                  checkedValue = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
          ),
          checkedValue == true ? SizedBox() : SizedBox(),
          checkedValue == true
              ? SizedBox()
              : Row(
                  children: [
                    SizedBox(width: 20),
                    DropdownButton(
                      value: compraTipo,
                      items: CompraTipo.values.map((CompraTipo e) {
                        return DropdownMenuItem<CompraTipo>(
                          value: e,
                          child: Text(e.name.toUpperCase().toString()),
                        );
                      }).toList(),
                      onChanged: (d) {
                        setState(() {
                          compraTipo = d;
                        });
                      },
                    ),
                    compraTipo == CompraTipo.compra
                        ? SizedBox()
                        : cedulaTipo == CedulaTipo.juridico ||
                              cedulaTipo == CedulaTipo.gubernamental
                        ? DropdownButton(
                            value: porcentajeTipo,
                            items: PorcentajeTipo.values.map((
                              PorcentajeTipo e,
                            ) {
                              return DropdownMenuItem<PorcentajeTipo>(
                                value: e,
                                child: Text(e.name[1].toUpperCase().toString()),
                              );
                            }).toList(),
                            onChanged: (d) {
                              setState(() {
                                porcentajeTipo = d;
                              });
                            },
                          )
                        : Text('1'),
                    compraTipo == CompraTipo.compra ? SizedBox() : Text("%"),
                  ],
                ),
          SizedBox(height: 20),
          actidades.isNotEmpty
              ? Column(
                  children: [
                    Text(
                      "Actividades-Alicuotas",

                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 400,
                      child: DropdownButton(
                        isExpanded: true,
                        value: actividadalicuota,
                        items: actidades.map((String e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (d) {
                          setState(() {
                            actividadalicuota = d;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                )
              : SizedBox(),
          TextFormField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Monto Base",
              suffixText: 'Bs',
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    retencionController.clear();
                    activityController.clear();
                  },
                  label: Icon(Icons.data_saver_off),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Facture()),
                    );
                  },
                  label: Icon(Icons.calculate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Busqueda extends StatefulWidget {
  const Busqueda({super.key});
  @override
  State<Busqueda> createState() => _BusquedaState();
}

class _BusquedaState extends State<Busqueda> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          top: 30,
          right: 30,
          bottom: 100,
        ),
        child: Card(
          elevation: 20,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    "Buscar contribuyente",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: documentoController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Documento de identidad",
                                prefix: DropdownButton(
                                  value: cedulaTipo,
                                  items: CedulaTipo.values.map((CedulaTipo e) {
                                    return DropdownMenuItem<CedulaTipo>(
                                      value: e,
                                      child: Text(
                                        e.name[0].toUpperCase().toString(),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (d) {
                                    setState(() {
                                      cedulaTipo = d;
                                    });
                                  },
                                ),
                                suffix: IconButton(
                                  onPressed: () async {
                                    actidades.clear();
                                    // final List? info = await buscarRif(
                                    // context,
                                    //documentoController.text,
                                    //cedulaTipo,
                                    //);

                                    alicuota = await busaralicuotas(
                                      context,
                                      documentoController.text,
                                    );
                                    for (var element in alicuota.keys) {
                                      actidades.add(element);
                                    }

                                    //      if (info?[0] != null) {
                                    //      nombreController.text = info?[0];
                                    //    retencionController.text = info?[1];
                                    //  activityController.text = info?[2];
                                    // }
                                  },
                                  icon: Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nombre",
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  nombreController.clear();
                                  documentoController.clear();
                                },
                                label: Icon(Icons.data_saver_off),
                              ),
                              SizedBox(height: 20),
                              Text("Limpiar"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  if (documentoController.text != '' &&
                                      nombreController.text != '') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateFacture(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Scaffold(
                                            body: AlertDialog(
                                              content: SizedBox(
                                                width: 100,
                                                height: 50,
                                                child: Text(
                                                  'Falta informacion del contribuyente',
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Volver'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                label: Icon(Icons.feed),
                              ),
                              SizedBox(height: 20),
                              Text("Modelar"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
