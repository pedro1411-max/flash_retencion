import 'package:flash_retencion/database.dart';
import 'package:flash_retencion/main.dart';
import 'package:flash_retencion/models/retencion.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

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
    final datos = widget.retencion;

    Future<Uint8List> loadImageAsset(String path) async {
      final data = await rootBundle.load(path);
      return data.buffer.asUint8List();
    }

    pw.Row buildPdfRow(String label, String value, {bool isTotal = false}) {
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      );
    }

    // Generar el documento PDF
    Future<pw.Document> generatePDF() async {
      final logoBytes = await loadImageAsset('assets/1.png');
      final pdfImage = pw.MemoryImage(logoBytes);

      final pdf = pw.Document();
      final datos = widget.retencion;

      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Column(
                    children: [
                      pw.Image(pdfImage, height: 80, fit: pw.BoxFit.contain),
                      pw.Text(
                        "J316208249",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      pw.Text(
                        "ZONA INDUSTRIAL ACARIGUA CALLE 2 ENTRE AVENIDAS 1 Y 2 GALPON 25",
                        style: pw.TextStyle(fontSize: 5),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Plantilla de pago/Retenciones',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 30),
              buildPdfRow("Documento:", datos.documento),
              buildPdfRow("Nombre:", datos.nombre),
              buildPdfRow("Descripción:", datos.descripcion),
              buildPdfRow("N° Factura:", datos.numFactura),
              buildPdfRow("N° de Control:", datos.numControl),

              buildPdfRow(
                "Fecha de creación:",
                "${datos.fecha.day}/${datos.fecha.month}/${datos.fecha.year}",
              ),
              pw.Divider(),
              buildPdfRow(
                "Monto Base:",
                "${datos.montoBase.toStringAsFixed(2)}bs",
              ),
              buildPdfRow(
                "IVA:",
                "${(datos.montoConIva()).toStringAsFixed(2)}bs",
              ),
              buildPdfRow(
                "Retención IVA:",
                "${datos.retencionIva().toStringAsFixed(2)}bs",
              ),
              buildPdfRow(
                "Retención ISLR:",
                "${datos.retencionIslr().toStringAsFixed(2)}bs",
              ),
              buildPdfRow(
                "Retención IAE:",
                "${datos.retencionIae().toStringAsFixed(2)}bs",
              ),

              pw.Divider(thickness: 2),
              buildPdfRow(
                "TOTAL:",
                "${datos.montoTotal().toStringAsFixed(2)}bs",
                isTotal: true,
              ),
            ],
          ),
        ),
      );

      return pdf;
    }

    // Función para compartir/guardar según plataforma
    Future<void> handlePDF() async {
      try {
        final pdf = await generatePDF();
        final bytes = await pdf.save();
        final fileName =
            'Plantila_de_pago_Retención_${widget.retencion.numFactura}.pdf';

        if (Platform.isAndroid) {
          // Android: Compartir directamente
          await Printing.sharePdf(bytes: bytes, filename: fileName);
        } else if (Platform.isWindows || Platform.isLinux) {
          // Windows/Linux: Seleccionar ruta
          final savePath = await FilePicker.platform.saveFile(
            dialogTitle: 'Guardar PDF de Retención',
            fileName: fileName,
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );

          if (savePath != null) {
            await File(savePath).writeAsBytes(bytes);
            await OpenFile.open(savePath); // Abrir después de guardar

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('PDF guardado en: $savePath')),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }

    // Helper para filas del PDF

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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        ElevatedButton.icon(
                          onPressed: () {
                            handlePDF();
                          },
                          label: Icon(Icons.print_outlined),
                        ),
                        SizedBox(),
                      ],
                    ),
              SizedBox(height: 10),
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
