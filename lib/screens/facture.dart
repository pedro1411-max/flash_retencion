import 'package:flash_retencion/database.dart';
import 'package:flash_retencion/main.dart';
import 'package:flash_retencion/models/retencion.dart';
import 'package:flutter/material.dart';

class Facture extends StatefulWidget {
  final guardar;
  final Retencion retencion;
  const Facture(this.guardar, this.retencion, {super.key});
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
            if (widget.guardar == false) {
              Navigator.pop(context);
            }
            if (widget.guardar) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(title: 'Flash Retencion'),
                ),
              );
            }
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
              Image.asset('assets/1.png', width: 100, height: 60),
              Center(
                child: Text(
                  'Retenciones',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              SizedBox(height: 20),
              rowResum("Documento: ", datos.documento),
              Text(
                'Nombre:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.00),
              ),
              Text(
                datos.nombre,
                style: TextStyle(fontSize: 18.00),
                softWrap: true,
              ),
              Text(
                'Descripcion:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.00),
              ),
              Text(
                datos.descripcion,
                style: TextStyle(fontSize: 18.00),
                softWrap: true,
              ),
              rowResum("Numero de factura:", datos.numFactura),
              rowResum('Numero de control:', datos.numControl),
              rowResum(
                'Fecha:',
                "${datos.fecha.day}/${datos.fecha.month}/${datos.fecha.year}",
              ),

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
              widget.guardar
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await Basedatos.insertar(datos);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyHomePage(title: 'Flash Retencion'),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Retención Guardada'),
                              ),
                            );
                          },
                          label: Icon(Icons.save_outlined),
                        ),
                        SizedBox(),
                      ],
                    )
                  : SizedBox(),
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
