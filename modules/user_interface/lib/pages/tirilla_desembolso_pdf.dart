import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final formatter = NumberFormat("#,###", "es_CO");

Future<pw.Image> pdfImageFromAsset(String assetPath, {double? width, double? height}) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List();
  final image = pw.MemoryImage(bytes);
  return pw.Image(image, width: width, height: height);
}

Future<Uint8List> generarTirillaDesembolsoPdf(
    {required String empresa,
    required int pagare,
    required double interes,
    required String nombreAsesor,
    required String nombreCliente,
    required String puntoDeVenta,
    required String fechaCompromiso,
    required Map<String, dynamic> planAmortizacion,
    required String cedulaCliente,
    required int valorCompra}) async {
  final pdf = pw.Document();
  final now = DateTime.now();
  final fecha = DateFormat('yyyy/MM/dd').format(now);
  final impresion = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final logoWidget = await pdfImageFromAsset("assets/images/finansuenos_logo.png", width: 230);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.letter,
      margin: const pw.EdgeInsets.all(32),

      // ✅ Encabezado en cada página
      header: (pw.Context context) {
        return pw.Column(
          children: [
            _buildCenteredText(impresion),
            pw.SizedBox(height: 6),
            pw.Center(child: logoWidget),
            pw.SizedBox(height: 12),
          ],
        );
      },

      // ✅ Pie de página con numeración
      footer: (pw.Context context) {
        return pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            "Página ${context.pageNumber} de ${context.pagesCount}",
            style: _estilo(isBold: false),
          ),
        );
      },

      build: (pw.Context context) => [
        _buildCenteredText(empresa),
        _buildCenteredText("CONTACTANOS: 8240772"),
        pw.SizedBox(height: 12),
        _text("Estos son los datos de tu compra:"),
        pw.SizedBox(height: 8),

        _fila("Nombre Completo:", nombreCliente),
        _fila("Identificación:", cedulaCliente),
        _divider(),
        pw.SizedBox(height: 16),

        _fila("Fecha de Compra:", fecha),
        _fila("Punto de Venta:", puntoDeVenta),
        _fila("Número de Pagaré:", pagare.toString()),
        _fila("Tasa Interés:", "$interes%"),
        pw.SizedBox(height: 16),

        _buildCenteredText("Valor Compra:", fontSize: 25),
        _buildCenteredText("\$${formatter.format(valorCompra)}", fontSize: 28),
        pw.SizedBox(height: 20),

        _buildCenteredText("Plan de Pagos"),
        pw.SizedBox(height: 8),

        // ✅ Tabla resumen de cuotas
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("# Cuota"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("Valor Cuota"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("Fecha Cuota"),
                ),
              ],
            ),
            ...planAmortizacion.entries.map((entry) {
              final cuota = entry.value;
              final yearStr = cuota["fecha_cuota"].toString().substring(0, 4);
              final monthStr = cuota["fecha_cuota"].toString().substring(4, 6);
              final dayStr = cuota["fecha_cuota"].toString().substring(6, 8);

              return pw.TableRow(children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText(cuota["nro_cuota"].toString().trim()),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child:
                      _buildCenteredText("\$${formatter.format(cuota["vlr_cuota"])}"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("$yearStr-$monthStr-$dayStr"),
                ),
              ]);
            }),
          ],
        ),

        pw.SizedBox(height: 20),

        _buildCenteredText("Detalle de las Cuotas:"),
        pw.SizedBox(height: 8),

        // ✅ Tabla de detalle extendida
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(2),
            4: const pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("# Cuota"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("Fecha Cuota"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("Capital"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("Interés"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("Aval"),
                ),
              ],
            ),
            ...planAmortizacion.entries.map((entry) {
              final cuota = entry.value;
              final yearStr = cuota["fecha_cuota"].toString().substring(0, 4);
              final monthStr = cuota["fecha_cuota"].toString().substring(4, 6);
              final dayStr = cuota["fecha_cuota"].toString().substring(6, 8);

              return pw.TableRow(children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText(cuota["nro_cuota"].toString().trim()),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("$yearStr-$monthStr-$dayStr"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("\$${formatter.format(cuota["valor_capital"])}"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: _buildCenteredText("\$${formatter.format(cuota["valor_interes"])}"),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child:
                      _buildCenteredText("\$${formatter.format(cuota["vlr_aval"])}"),
                ),
              ]);
            }),
          ],
        ),
      ],
    ),
  );

  return pdf.save();
}

pw.TextStyle _estilo({bool isBold = true, double fontSize = 12}) => pw.TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: PdfColors.black,
    );

pw.Widget _text(String text, {bool isBold = true, int maxLines = 1, double fontSize = 20}) {
  return pw.Container(
    width: double.infinity,
    child: pw.Text(
      text,
      style: _estilo(isBold: isBold, fontSize: fontSize),
      textAlign: pw.TextAlign.left,
      maxLines: maxLines,
      overflow: pw.TextOverflow.clip,
    ),
  );
}

pw.Widget _buildCenteredText(String text, {bool isBold = true, double fontSize = 18}) {
  return pw.Container(
    width: double.infinity,
    child: pw.Text(
      text,
      style: _estilo(isBold: isBold, fontSize: fontSize),
      textAlign: pw.TextAlign.center,
    ),
  );
}

pw.Widget _divider() {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 6),
    height: 1,
    color: PdfColors.black,
  );
}

pw.Widget _fila(String left, String right, {bool isBold = true, double fontSize = 20}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 2),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(left, style: _estilo(isBold: isBold, fontSize: fontSize)),
        pw.Text(right, style: _estilo(isBold: isBold, fontSize: fontSize)),
      ],
    ),
  );
}
