import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:user_interface/pages/recibo_pdf.dart';
import 'package:printing/printing.dart';

final formatter = NumberFormat("#,###", "es_CO");

class VistaPrecios extends StatefulWidget {
  final int pagoMinimo;
  final int pagoTotal;
  final int? idLiquidacion;
  final int idPrestamo;
  final String cedula;
  final String? nombreCliente;
  final VoidCallback onPagoExitoso;

  const VistaPrecios({
    super.key,
    required this.pagoMinimo,
    required this.pagoTotal,
    required this.idLiquidacion,
    required this.idPrestamo,
    required this.cedula,
    required this.onPagoExitoso,
    required this.nombreCliente,
  });

  @override
  State<VistaPrecios> createState() => _VistaPreciosState();
}

class _VistaPreciosState extends State<VistaPrecios> {
  int? valorPago;
  String? opcionSeleccionada;

  final TextEditingController _controller = TextEditingController();

  void _seleccionarOpcion(String tipo, int valor) {
    setState(() {
      opcionSeleccionada = tipo;
      valorPago = valor;
      _controller.clear(); // Limpia input personalizado si se selecciona una opción
    });
  }

  bool _isButtonDisabled = false;

  // ignore: unused_element
  Future<void> _handlePressed() async {
    setState(() {
      _isButtonDisabled = true;
    });

    // Simula una operación como guardar, esperar, etc.
    await Future.delayed(Duration(seconds: 2));

    // Si quieres reactivar el botón después:
    setState(() {
      _isButtonDisabled = false;
    });
  } 

  void _actualizarValorManual(String value) {
    final enteredValue = int.tryParse(value);

    if (enteredValue != null && enteredValue > widget.pagoTotal) {
      _controller.clear(); // limpia el campo

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Valor excedido'),
            content: Text(
                'El valor ingresado no puede ser mayor a \$${formatter.format(widget.pagoTotal)}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    valorPago = 0;
                  });
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        opcionSeleccionada = "manual";
        valorPago = enteredValue;
      });
    }
  }

  Widget _opcionBox(String titulo, int valor) {
    bool seleccionado = opcionSeleccionada == titulo;
    return GestureDetector(
      onTap: () => _seleccionarOpcion(titulo, valor),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: seleccionado ? AppColors.buttonPositive : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titulo,
                style: TextStyle(color: seleccionado ? AppColors.backgroundDark : Colors.black)),
            Text("\$ ${formatter.format(valor)}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: seleccionado ? AppColors.backgroundDark : Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _opcionBox("Pago Mínimo", widget.pagoMinimo),
        SizedBox(height: 12),
        _opcionBox("Pago Total", widget.pagoTotal),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: "Otro valor",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: _actualizarValorManual,
          ),
        ),
        SizedBox(height: 10),
        if (valorPago != null)
          Text(
            "Valor A Pagar: \$${formatter.format(valorPago)}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        SizedBox(height: 35),
        ElevatedButton(
          onPressed: _isButtonDisabled
              ? null
              : () async {
                  if (valorPago == null || widget.idLiquidacion == null || valorPago == 0) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Valor Pago no Valido"),
                            content: Text(
                                "El valor ingresado no es valido, porfavor intenta ingresando un valor valido"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Aceptar"),
                              ),
                            ],
                          );
                        });
                    return;
                  }

                  setState(() {
                    _isButtonDisabled = true;
                  });

                  final now = DateTime.now();
                  print(now);
                  final fecha = DateFormat('yyyyMMdd').format(now);

                  final body = {
                    "operacion": "aplica_pago",
                    "id_cupo": widget.idPrestamo.toString(),
                    "identificacion": widget.cedula,
                    "valor_recibo": valorPago.toString(),
                    "codigo_interno": "101",
                    "id_liquidacion": widget.idLiquidacion.toString(),
                    "viene_ws": 0,
                    "fecha_pago": fecha,
                  };

                  try {
                    final response = await http.post(
                      Uri.parse(
                          "https://scriptcase.cuotasoft.com/scriptcase/app/Finansuenos/blank_api_recibos_de_caja/"),
                      headers: {
                        "Content-Type": "application/json",
                        "key": "aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb",
                      },
                      body: jsonEncode(body),
                    );

                    if (response.statusCode == 200) {
                      final json = jsonDecode(response.body);
                      print("este es el envio $body");
                      print("✅ Pago realizado: $json");
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Pago Registrado correctamente ✅"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                  // 1. Simula cuotas (puedes reemplazar por las reales si las tienes)
                                  final cuotas = {
                                      'Total parcial': '11111',
                                      'interes': '5000',
                                      'IVA interes': '2500',
                                      'descuento': '1500',
                                      'total recibido': '150000',
                                };

                                  final numeroRecibo = "MF18-806";
                                  final detalle = "pago online";

                                  // 2. Generar PDF con función modular
                                  final pdfBytes = await generarReciboPdf(
                                      nombre: widget.nombreCliente ?? 'N/A',
                                      identificacion: widget.cedula,
                                      pago: valorPago.toString(),
                                      cuotas: cuotas,
                                      numeroRecibo: numeroRecibo,
                                      detalle: detalle);

                                  // 3. Mostrar el PDF
                                  await Printing.layoutPdf(
                                    onLayout: (_) => pdfBytes,
                                    name: 'recibo_pago_${widget.cedula}.pdf',
                                  );

                                  widget.onPagoExitoso();
                                },
                                child: Text("Aceptar"),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (response.statusCode == 500) {
                      print("❌ Error: ${response.statusCode}");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Error interno"),
                              content: Text(
                                  "Porfavor intenta nuevamente mas tarde, nos encontramos validando."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    widget.onPagoExitoso();
                                  },
                                  child: Text("Aceptar"),
                                ),
                              ],
                            );
                          });
                    } else {
                      String errorMessage;
                      if (response.statusCode == 500) {
                        errorMessage = "Por favor intenta nuevamente más tarde. Estamos validando.";
                      } else if (response.statusCode == 404) {
                        errorMessage = "No se encontraron valores para este pago.";
                      } else {
                        errorMessage = "Error inesperado (${response.statusCode})";
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text(errorMessage),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  widget.onPagoExitoso(); // ✅ limpia también en errores
                                },
                                child: Text("Aceptar"),
                              ),
                            ],
                          );
                        },
                      );

                      setState(() {
                        _isButtonDisabled = false;
                      });
                    }
                  } catch (e) {
                    print("❌ Excepción: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Excepción: $e")),
                    );
                    setState(() {
                      _isButtonDisabled = false;
                    });
                  }
                },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_isButtonDisabled ? "Procesando..." : "Confirmar Pago"),
              SizedBox(width: 10),
              Icon(Icons.check_circle, size: 28),
            ],
          ),
        ),
      ],
    );
  }
}
