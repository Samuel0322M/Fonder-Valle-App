import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

final formatter = NumberFormat("#,###", "es_CO");

Future<Uint8List> generarReciboPdf({
  required String nombre,
  required String identificacion,
  required String pago,
  required Map<String, dynamic> cuotas,
  required String numeroRecibo,
  required String detalle,
}) async {
  final pdf = pw.Document();
  final now = DateTime.now();
  final fecha = DateFormat('yyyy/MM/dd').format(now);
  final impresion = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  int pagoInt = int.tryParse(pago) ?? 0;
  int interesInt = int.tryParse(cuotas["interes"] ?? "0") ?? 0;
  int ivaInteresInt = int.tryParse(cuotas["IVA interes"] ?? "0") ?? 0;
  int descuentoInt = int.tryParse(cuotas["descuento"] ?? "0") ?? 0;

  // 📌 Definir ancho fijo (74 mm) y altura dinámica
  final PdfPageFormat customPageFormat = PdfPageFormat(
    74 * PdfPageFormat.mm, // ancho fijo
    300,       // alto dinámico
    marginAll: 5, 
    );

  pdf.addPage(
    pw.MultiPage(
      pageFormat: customPageFormat,
      margin: const pw.EdgeInsets.all(5),
      build: (context) => [
        _text("FINANSUEÑOS", isBold: true),
        _text("NIT: 901723445"),
        _text("DIREC: CALLE 7 # 7 - 11"),
        _text("TELEF: 8240772"),
        _divider(),

        _text("RECIBO DE CAJA: #$numeroRecibo"),
        _text("FECHA: $fecha"),
        _divider(),

        _text(nombre, maxLines: 2),
        _text("CC/NIT: $identificacion"),
        _text("Detalle: $detalle"),
        _divider(),

        _buildCenteredText("FACTURA CUOTA VALOR+INT"),
        _divider(),

        _text("--ANTICIPO-- # 0 \$${formatter.format(pagoInt)}"),
        _divider(),

        _fila("Total Parcial:", "\$${formatter.format(pagoInt)}"),
        _fila("Interes:", "\$${formatter.format(interesInt)}"),
        _fila("IVA Interes:", "\$${formatter.format(ivaInteresInt)}"),
        _fila("Descuento:", "\$${formatter.format(descuentoInt)}"),
        _fila("TOTAL RECIBO:", "\$${formatter.format(pagoInt)}"),
        _divider(),

        pw.SizedBox(height: 20),
        _fila("ELABORADO", "FIRMA Y SELLO"),
        _divider(),

        _text("USR: SAMUEL MARIN SANCHEZ"),
        _text("IMPRESO: $impresion"),
      ],
    ),
  );

  return pdf.save();
}

// ======= Helpers =======
pw.TextStyle _estilo({bool isBold = true, double fontSize = 9}) =>
    pw.TextStyle(
      fontSize: fontSize,
      fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
      color: PdfColors.black,
    );

pw.Widget _text(String text,
    {bool isBold = true, int maxLines = 1, double fontSize = 9}) {
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

pw.Widget _buildCenteredText(String text, {bool isBold = true}) {
  return pw.Container(
    width: double.infinity,
    child: pw.Text(
      text,
      style: _estilo(isBold: isBold),
      textAlign: pw.TextAlign.center,
    ),
  );
}

pw.Widget _divider() {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 4),
    height: 1,
    color: PdfColors.black,
  );
}

pw.Widget _fila(String left, String right, {bool isBold = true}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(left, style: _estilo(isBold: isBold)),
      pw.Text(right, style: _estilo(isBold: isBold)),
    ],
  );
}
