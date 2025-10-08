import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:user_interface/pages/tirilla_desembolso_pdf.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/utils/application.dart';
import 'package:user_interface/utils/general_api.dart';
import 'package:user_interface/widgets/CurrencyInputFormatterCustom.dart';
import 'package:user_interface/widgets/buildlabel.dart';
import 'package:user_interface/widgets/dropdown_map_validated_widget.dart';
import 'package:user_interface/widgets/dropdown_validated_field_widget.dart';

final formatter = NumberFormat("#,###", "es_CO");

class PedidoItem {
  final String marca;
  final String linea;
  final String item;
  final int valor;

  PedidoItem({
    required this.marca,
    required this.linea,
    required this.item,
    required this.valor,
  });
}

class FormOrderInfo extends StatefulWidget {
  const FormOrderInfo({super.key, required this.numberID, required this.onCompleted});

  final String numberID;
  final Function(bool) onCompleted;

  @override
  State<FormOrderInfo> createState() => _FormOrderInfoState();
}

class _FormOrderInfoState extends State<FormOrderInfo> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final _marcaController = TextEditingController();
  final _lineaController = TextEditingController();
  final _itemController = TextEditingController();
  final _valorController = TextEditingController();
  final _descuentoController = TextEditingController();

  final ValueNotifier<String?> _marcaError = ValueNotifier(null);
  final ValueNotifier<String?> _lineaError = ValueNotifier(null);
  final ValueNotifier<String?> _itemError = ValueNotifier(null);

  final cedulaAsesor = Application().authenticationData.numberID;

  final Map<String, String> _marcas = {
    "1": "LG",
    "2": "SAMSUNG",
  };

  final Map<String, Map<String, String>> _lineas = {
    "1": {"1": "Lavadora", "2": "Televisor"},
    "2": {"3": "Celular", "4": "Tablet"},
  };

  final Map<String, Map<String, String>> _items = {
    "1": {
      "1": "Lavadora Carga Frontal - 22kg/48lbs - 6 Motion - Color plata-WM22VV26R",
      "2": "Lavadora Carga Frontal -16kg/35lbs - AIDD - Pet Care - Gris Grafito"
    },
    "2": {
      "1": "TV LG 65 Pulgadas 164 Cm 65UT8050PSB 4K-UHD LED Smart TV",
      "2": "TV LG 65 Pulgadas 165 Cm 65UT7300 4K-UHD LED Smart TV"
    },
  };

  final Map<String, Map<String, int>> _itemValores = {
    "1": {"1": 6399900, "2": 5299900},
    "2": {"1": 4299900, "2": 4199900},
  };

  String? _selectedMarcaId;
  String? _selectedLineaId;
  // ignore: unused_field
  String? _selectedItemId;
  String? _selectedPlazo;
  double? _vlrCuota;

  List<PedidoItem> _pedidoItems = [];

  Map<String, String> getLineasForMarca(String marcaId) {
    return _lineas[marcaId] ?? {};
  }

  Map<String, String> getItemsForLinea(String lineaId) {
    return _items[lineaId] ?? {};
  }

  int? getValorForItem(String lineaId, String itemId) {
    return _itemValores[lineaId]?[itemId];
  }

  int get totalPedido => _pedidoItems.fold(0, (sum, item) => sum + item.valor);

  int get cuotaInicial => int.tryParse(_descuentoController.text.replaceAll('.', '')) ?? 0;

  int get saldoPendiente => (cuotaInicial > totalPedido) ? 0 : totalPedido - cuotaInicial;

  void agregarItem() {
    if (_marcaController.text.isEmpty) _marcaError.value = "Seleccione una marca";
    if (_lineaController.text.isEmpty) _lineaError.value = "Seleccione una linea";
    if (_itemController.text.isEmpty) _itemError.value = "Seleccione un item";

    if (_marcaController.text.isNotEmpty &&
        _lineaController.text.isNotEmpty &&
        _itemController.text.isNotEmpty) {
      final nuevoItem = PedidoItem(
        marca: _marcas[_marcaController.text] ?? '',
        linea: getLineasForMarca(_selectedMarcaId!)[_lineaController.text] ?? '',
        item: getItemsForLinea(_selectedLineaId!)[_itemController.text] ?? '',
        valor: int.parse(_valorController.text),
      );

      setState(() {
        _pedidoItems.add(nuevoItem);
        _marcaController.clear();
        _lineaController.clear();
        _itemController.clear();
        _valorController.clear();
        _selectedMarcaId = null;
        _selectedLineaId = null;
        _selectedItemId = null;
        _marcaError.value = null;
      });
    }
  }

  void eliminarItem(int index) {
    setState(() {
      _pedidoItems.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Se ha eliminado el pedido")),
    );
  }

  Future<void> _consultarVlrCuota(String plazo) async {
    final saldo = saldoPendiente;

    print("este es el plazo $plazo, este es el monto $saldo");

    final response = await ApiService.bodyApi(
      body: {
        "operacion": "calcula_cuota",
        "numero_cuotas": plazo,
        "valor_desembolso": saldo,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("este es el data $data");
      final cuota = data["data"]["valor_cuota"];
      setState(() {
        _vlrCuota = (cuota as num).toDouble();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al calcular la cuota")),
      );
    }
  }

  void confirmarPedido() async {
    final cuota = cuotaInicial;
    if (cuota > totalPedido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("La cuota inicial no puede ser mayor que el total del pedido")),
      );
      return;
    }

    final saldo = saldoPendiente;

    var body = jsonEncode({
      "operacion": "desembolso",
      "identificacion": widget.numberID,
      "asesor": cedulaAsesor,
      "items": _pedidoItems
          .map((e) => {"marca": e.marca, "linea": e.linea, "item": e.item, "valor": e.valor})
          .toList(),
      "plazo": _selectedPlazo,
      "vlrCuota": _vlrCuota,
      "total": totalPedido,
      "saldoPendiente": saldo,
      "cuotaInicial": cuota,
      "id_scoring": '1',
      "id_empresa": '1',
    });

    print("este es el response: $body");

    final response = 
           await http.post(Uri.parse("https://finansuenos.cuotasoft.com/blank_api_proceso_desembolsos/"),
            //await http.post(Uri.parse("https://scriptcase.cuotasoft.com/scriptcase/app/Finansuenos/blank_api_proceso_desembolsos/"),
        headers: {
          'Content-Type': "application/json",
          'key': 'aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb'
        },
        body: body);

    print("este es el response: ${response.body}");

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirmación"),
          content: Text(
            "Pedido creado con éxito.\n\n"
            "Total: \$${formatter.format(totalPedido)}\n"
            "Cuota Inicial: \$${formatter.format(cuota)}\n"
            "Saldo Pendiente: \$${formatter.format(saldo)}\n"
            "Valor Cuota: \$${formatter.format(_vlrCuota)}",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                final Map<String, dynamic> data = jsonDecode(response.body);

                final String empresa = data["data"]["marca"];
                final int pagare = data["data"]["pagare"];
                final double interes = data["data"]["interes"];
                final String nombreAsesor = data["data"]["nombre_asesor"];
                final String nombreCliente = data["data"]["nombre_cliente"];
                final String puntoDeVenta = data["data"]["punto_de_venta"];
                final String fechaCompromiso = data["data"]["fecha_compromiso"];
                final Map<String, dynamic> planAmortizacion = data["data"]["plan_amortizacion"];

                print(
                    "objetos del response $empresa $pagare $interes $nombreCliente $nombreAsesor $puntoDeVenta $fechaCompromiso $planAmortizacion");

                final pdfBytes = await generarTirillaDesembolsoPdf(
                    empresa: empresa,
                    pagare: pagare,
                    interes: interes,
                    nombreAsesor: nombreAsesor,
                    nombreCliente: nombreCliente,
                    puntoDeVenta: puntoDeVenta,
                    fechaCompromiso: fechaCompromiso,
                    planAmortizacion: planAmortizacion,
                    cedulaCliente: widget.numberID,
                    valorCompra: saldo);

                await Printing.layoutPdf(
                  onLayout: (_) => pdfBytes,
                  name: 'plan_de_amortizacion${widget.numberID}.pdf',
                );

                setState(() {
                  _pedidoItems.clear();
                  _marcaController.clear();
                  _lineaController.clear();
                  _itemController.clear();
                  _valorController.clear();
                  _descuentoController.clear();
                  _selectedMarcaId = null;
                  _selectedLineaId = null;
                  _selectedItemId = null;
                  _selectedPlazo = null;
                  _vlrCuota = null;
                });
              },
              child: const Text("Aceptar"),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 404) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Atencion"),
          content: Text(
            "El cliente no tiene cupo aprobado",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Aceptar"),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 400) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Monto Excedido"),
          content: Text(
            "El monto solicitado excede el cupo Aprobado",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Aceptar"),
            ),
          ],
        ),
      );
    }  else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al confirmar pedido")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("Informacion Pedido",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              DropdownMapValidatedFieldWidget(
                controller: _marcaController,
                labelText: "Marcas",
                itemsMap: _marcas,
                errorNotifier: _marcaError,
                value: _selectedMarcaId,
                onChanged: (value) {
                  setState(() {
                    _selectedMarcaId = value;
                    _lineaController.clear();
                    _itemController.clear();
                    _valorController.clear();
                    _selectedLineaId = null;
                    _selectedItemId = null;
                  });
                },
              ),
              DropdownMapValidatedFieldWidget(
                controller: _lineaController,
                labelText: "Líneas",
                itemsMap: _selectedMarcaId != null ? getLineasForMarca(_selectedMarcaId!) : {},
                errorNotifier: _lineaError,
                value: _selectedLineaId,
                onChanged: (value) {
                  setState(() {
                    _selectedLineaId = value;
                    _itemController.clear();
                    _valorController.clear();
                    _selectedItemId = null;
                  });
                },
              ),
              DropdownMapValidatedFieldWidget(
                controller: _itemController,
                labelText: "item",
                itemsMap: _selectedLineaId != null ? getItemsForLinea(_selectedLineaId!) : {},
                errorNotifier: _itemError,
                onChanged: (value) {
                  setState(() {
                    _selectedItemId = value;
                    final valor = getValorForItem(_selectedLineaId!, value!);
                    _valorController.text = valor?.toString() ?? "";
                  });
                },
              ),
              const SizedBox(height: 10),
              const LeftAlignedLabel("Valor del item"),
              TextFormField(
                controller: _valorController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textFieldPositive),
                  ),
                ),
                inputFormatters: [
                  CurrencyInputFormatterCustom(), // ya no usas el otro
                ],
              ),
              const SizedBox(height: 16),
              const LeftAlignedLabel("Cuota Inicial"),
              TextFormField(
                controller: _descuentoController,
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyInputFormatterCustom()],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textFieldPositive),
                  ),
                ),
                onChanged: (_) => setState(() {
                  _selectedPlazo = null;
                  _vlrCuota = null;
                }),
              ),
              if (_pedidoItems.isNotEmpty) ...[
                DropdownValidatedFieldWidget(
                  labelText: "Plazo",
                  documentTypes: ['9', '10', '11', '12', '13', '14', '15', '16'],
                  value: _selectedPlazo,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlazo = value;
                    });
                    if (value != null) {
                      _consultarVlrCuota(value);
                    }
                  },
                ),
                if (_vlrCuota != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Valor Cuota: \$${formatter.format(_vlrCuota)}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Agregar Item"),
                      onPressed: agregarItem,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Items Agregados:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_pedidoItems.isEmpty) const Text("No hay Items agregados"),
              ..._pedidoItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return ListTile(
                  title: Text("${item.item} (${item.linea}) - ${item.marca}"),
                  subtitle: Text("Valor \$${formatter.format(item.valor)}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => eliminarItem(index),
                  ),
                );
              }),
              const Divider(),
              Center(
                child: Column(
                  children: [
                    Text("Total: \$${formatter.format(totalPedido)}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    if (cuotaInicial > 0) ...[
                      Text("Valor Cuota Inicial: \$${formatter.format(cuotaInicial)}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Saldo pendiente: \$${formatter.format(saldoPendiente)}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_pedidoItems.isNotEmpty && _selectedPlazo != null)
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Confirmar Pedido"),
                    onPressed: confirmarPedido,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
