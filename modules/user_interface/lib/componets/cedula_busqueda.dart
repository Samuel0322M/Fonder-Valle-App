import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CedulaWidget extends StatefulWidget {
  final void Function(String cedula, String nombreCliente, Map<int, String> prestamos)
      onClienteLoaded;

  const CedulaWidget({super.key, required this.onClienteLoaded});

  @override
  State<CedulaWidget> createState() => _CedulaWidgetState();
}

class _CedulaWidgetState extends State<CedulaWidget> {
  final TextEditingController _ctrlCedula = TextEditingController();
  bool _loading = false;

  Future<void> _buscar() async {
    final cedula = _ctrlCedula.text.trim();
    if (cedula.isEmpty) return;

    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse(
            'https://scriptcase.cuotasoft.com/scriptcase/app/Finansuenos/blank_api_recibos_de_caja/'),
        headers: {
          'Content-Type': 'application/json',
          'key': 'aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb'
        },
        body: jsonEncode({"operacion": "consulta_clientes", "identificacion": cedula}),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final clienteData = responseJson['data'];
        final nombreCliente = clienteData['nombre_cliente'];
        final prestamosRaw = clienteData['prestamos'];

        Map<int, String> prestamosMap = {};

        print(prestamosRaw);
        if (prestamosRaw is Map) {
          prestamosMap = {
            for (var entry in prestamosRaw.entries) int.parse(entry.key): entry.value,
          };
        }

        if (prestamosMap.isEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Sin creditos Vigentes"),
                  content: Text("Este cliente no tiene créditos vigentes."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Aceptar"),
                    ),
                  ],
                );
              });
        }

        widget.onClienteLoaded(cedula, nombreCliente, prestamosMap);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Cedula no Valida"),
                content: Text("La cedula no existe o el cliente no se encuentra."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Aceptar"),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de red: $e')),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ctrlCedula,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Número de cédula',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.blue)),
            ),
          ),
        ),
        SizedBox(width: 16),
        _loading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _buscar,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: Icon(Icons.search),
              ),
      ],
    );
  }
}
