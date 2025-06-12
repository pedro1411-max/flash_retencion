import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flash_retencion/database.dart';
import 'package:flash_retencion/models/retencion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportFacture extends StatefulWidget {
  const ReportFacture({super.key});
  @override
  State<ReportFacture> createState() => _ReportFactureState();
}

class _ReportFactureState extends State<ReportFacture> {
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  Future<void> selectStartDate(BuildContext context) async {
    endDate = null;
    endDateController.clear();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
        startDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
        endDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    Future<pw.Document> generatePDF(List<Retencion> dato) async {
      final logoBytes = await loadImageAsset('assets/1.png');
      final pdfImage = pw.MemoryImage(logoBytes);

      final pdf = pw.Document();
      for (var datos in dato) {
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
      }

      return pdf;
    }

    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: startDateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de inicio',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => selectStartDate(context),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: endDateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha de fin',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => selectEndDate(context),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 30),
                if (startDate != null && endDate != null)
                  Text(
                    'Rango seleccionado: ${endDate!.difference(startDate!).inDays} días',
                    style: const TextStyle(fontSize: 16),
                  ),
                SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final List<Retencion> ListOriginal =
                            await Basedatos.viewData();
                        final List<Retencion> ListFilter = ListOriginal.where((
                          e,
                        ) {
                          return (e.fecha.day >= startDate!.day &&
                                  e.fecha.month >= startDate!.month &&
                                  e.fecha.year >= startDate!.year) &&
                              (e.fecha.day <= endDate!.day &&
                                  e.fecha.month <= endDate!.month &&
                                  e.fecha.year <= endDate!.year);
                        }).toList();

                        try {
                          final pdf = await generatePDF(ListFilter);
                          final bytes = await pdf.save();
                          final fileName =
                              'Reportes_Plantillas_de_pago_Retencion.pdf';

                          if (Platform.isAndroid) {
                            // Android: Compartir directamente
                            await Printing.sharePdf(
                              bytes: bytes,
                              filename: fileName,
                            );
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
                              await OpenFile.open(
                                savePath,
                              ); // Abrir después de guardar

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('PDF guardado en: $savePath'),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                      label: Icon(Icons.print_outlined),
                    ),
                    SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
