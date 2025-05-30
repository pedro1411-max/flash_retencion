import 'package:flash_retencion/models/retencion.dart';
import 'package:flutter/material.dart';

class Facture extends StatefulWidget {
  final Retencion retencion;
  const Facture(this.retencion, {super.key});
  @override
  State<Facture> createState() => _FatureState();
}

class _FatureState extends State<Facture> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print(widget.retencion.montoTotal());
    final datos = widget.retencion;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Retenciones',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              SizedBox(height: 20),
              rowResum("Documento: ", datos.documento),
              rowResum("Nombre:", datos.nombre),
              rowResum("Descripcion:", datos.descripcion),
              SizedBox(height: 30),
              rowResum("Monto Base:", datos.montoBase.toStringAsFixed(2)),
              rowResum(
                "Monto con Iva:",
                datos.montoConIva().toStringAsFixed(2),
              ),
              rowResum(
                "Retencion al IVA:",
                datos.retencionIva().toStringAsFixed(2),
              ),
              rowResum(
                "Retencion al ISLR:",
                datos.retencionIslr().toStringAsFixed(2),
              ),
              rowResum(
                "Retencion por IAE:",
                datos.retencionIae().toStringAsFixed(2),
              ),
              rowResum("Monto Total:", datos.montoTotal().toStringAsFixed(2)),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Icon(Icons.save_outlined),
                  ),
                  SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Row rowResum(String element, String dato) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        element,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      Text(dato, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
    ],
  );
}
