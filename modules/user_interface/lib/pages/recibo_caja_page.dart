import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:user_interface/componets/cedula_busqueda.dart';
import 'package:user_interface/componets/lista_pagares.dart';
import 'package:user_interface/componets/vista_precios.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/resources/theme/appbar.dart';

class RecibosDeCaja extends StatefulWidget {
  const RecibosDeCaja({super.key});

  static const String route = '/recibo-de-caja';

  static Widget buildPage(BuildContext context, RouteSettings settings) {
    return const RecibosDeCaja();
  }

  @override
  State<RecibosDeCaja> createState() => _RecibosDeCajaState();
}

class _RecibosDeCajaState extends State<RecibosDeCaja> {
  int cedulaWidgetKey = 0;
  String cedula = '';
  int pagoMinimo = 0;
  int pagoTotal = 0;
  int? idLiquidacion;
  String nombreCliente = '';
  Map<int, String> prestamos = {};
  bool datosCargados = false;
  int? pagarIdSeleccionado;
  Map<String, dynamic>? detallePrestamo;

  Future<void> consultarDetallePrestamo(int idPrestamo) async {
    final url = Uri.parse(
        'https://scriptcase.cuotasoft.com/scriptcase/app/Finansuenos/blank_api_recibos_de_caja/');
    final body = {
      "operacion": "consulta_saldos",
      "id_cupo": idPrestamo.toString(),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'key': 'aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];

        setState(() {
          idLiquidacion = data['id_liquidacion'];
          pagoMinimo = data['pago_minimo'];
          pagoTotal = data['pago_total'];
        });
      } else {
        print("Error al obtener saldos");
      }
    } catch (e) {
      print("Error al consultar saldos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBarWidget(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent, // 👈 sin color de fondo
          elevation: 0, // 👈 sin sombra
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.iconDark,
            size: 20,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Recibo De Caja", style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CedulaWidget(
              key: ValueKey(cedulaWidgetKey),
              onClienteLoaded: (ced, nombre, prestamosMap) {
                setState(() {
                  pagarIdSeleccionado = null;
                  detallePrestamo = null;
                  idLiquidacion = null;
                  pagoMinimo = 0;
                  pagoTotal = 0;
                  cedula = ced;
                  nombreCliente = nombre;
                  prestamos = prestamosMap;
                  datosCargados = true;
                });
              },
            ),
            SizedBox(height: 20),
            if (datosCargados) ...[
              Text(nombreCliente, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              // ListaPagare con callback
              ListaPagare(
                pagarList: prestamos,
                onSeleccionado: (idSeleccionado) {
                  setState(() {
                    pagarIdSeleccionado = idSeleccionado;
                  });
                  consultarDetallePrestamo(idSeleccionado); //  Llama al endpoint con el id
                },
              ),

              // muestra el id cupo seleccionado en pantalla
              /*if (pagarIdSeleccionado != null) ...[
                SizedBox(height: 16),
                Text("Préstamo seleccionado: $pagarIdSeleccionado",
                    style: TextStyle(fontSize: 16, color: Colors.blue)),
              ],

              if (detallePrestamo != null) ...[
                SizedBox(height: 16),
                Text("Detalle recibido:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(jsonEncode(detallePrestamo), style: TextStyle(fontSize: 13)),
              ],*/

              SizedBox(height: 25),
            ],
            if (pagarIdSeleccionado != null && idLiquidacion != null)
              VistaPrecios(
                pagoMinimo: pagoMinimo,
                pagoTotal: pagoTotal,
                idLiquidacion: idLiquidacion,
                idPrestamo: pagarIdSeleccionado!,
                cedula: cedula,
                nombreCliente: nombreCliente,
                onPagoExitoso: () {
                  setState(() {
                    cedula = '';
                    nombreCliente = '';
                    prestamos = {};
                    datosCargados = false;
                    pagarIdSeleccionado = null;
                    idLiquidacion = null;
                    pagoMinimo = 0;
                    pagoTotal = 0;
                    detallePrestamo = null;
                    cedulaWidgetKey++;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
