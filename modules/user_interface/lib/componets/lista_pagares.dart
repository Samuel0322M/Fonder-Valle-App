import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ListaPagare extends StatefulWidget {
  final Map<int, String> pagarList; // Mapa de pagarés (ID → Descripción)
  final void Function(int pagarId) onSeleccionado; // Callback para notificar al padre la selección

  const ListaPagare({
    super.key,
    required this.pagarList,
    required this.onSeleccionado,
  });

  @override
  _ListaPagareState createState() => _ListaPagareState();
}

class _ListaPagareState extends State<ListaPagare> {
  int? _valorSeleccionado;

  @override
  void didUpdateWidget(covariant ListaPagare oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si la lista de pagarés cambió, limpiamos la selección anterior
    if (!mapEquals(widget.pagarList, oldWidget.pagarList)) {
      setState(() {
        _valorSeleccionado = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValorValido =
        _valorSeleccionado == null || widget.pagarList.containsKey(_valorSeleccionado);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: isValorValido
          ? DropdownButtonFormField<int>(
              value: _valorSeleccionado,
              hint: const Text('Selecciona un pagaré'),
              items: widget.pagarList.entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (int? nuevoValor) {
                if (nuevoValor != null) {
                  setState(() {
                    _valorSeleccionado = nuevoValor;
                  });
                  widget.onSeleccionado(nuevoValor);
                }
              },
              decoration: InputDecoration(
                labelText: 'Opciones',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          : const Text("Selecciona una cédula válida para mostrar los pagarés"),
    );
  }
}
