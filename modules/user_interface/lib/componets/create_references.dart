import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/info_referencias_box.dart';
import 'package:user_interface/providers/info_referencias_provider.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/utils/general_api.dart';
import 'package:user_interface/widgets/buildlabel.dart';
import 'package:user_interface/widgets/dropdown_map_validated_widget.dart';

class CreateReferences extends StatefulWidget {
  const CreateReferences({super.key, required this.numberID, required this.onCompleted});

  final String numberID;
  final Function(bool) onCompleted;

  @override
  State<CreateReferences> createState() => _CreateReferencesState();
}

class _CreateReferencesState extends State<CreateReferences> {
  final _formKey = GlobalKey<FormState>();
  final infoReferenciasProvider = InfoReferenciasProvider();

  final Map<String, String> _tipoReferencias = {
    "C": "Comercial",
    "F": "Familiar",
    "L": "Laboral",
    "P": "Personal"
  };

  final Map<String, Map<String, String>> _relacionReferencias = {
    "C": {"10": "Cliente", "9": "Proveedor", "11": "Otro"},
    "F": {
      "15": "Conyuge",
      "5": "Cuñad@",
      "1": "Herman@",
      "4": "Madre",
      "3": "Padre",
      "2": "Prim@",
      "6": "Ti@",
      "7": "Yerno",
      "8": "Nuera",
    },
    "L": {"13": "Compañero", "12": "Jefe", "14": "Otro"},
    "P": {"16": "Vecino", "17": "Conocido"}
  };

  bool _loading = false;

  // Usamos un modelo que encapsula cada referencia
  late List<ReferenciaFormController> referenciasControllers;

  @override
  void initState() {
    super.initState();
    referenciasControllers = [
      ReferenciaFormController(),
      ReferenciaFormController(),
    ];
    _initProvider();
  }

  @override
  void dispose() {
    for (var ref in referenciasControllers) {
      ref.dispose();
    }
    infoReferenciasProvider.dispose();
    super.dispose();
  }

  Future<void> _initProvider() async {
    await infoReferenciasProvider.inicializarBox();
    await _cargarYAsignarInfo();
  }

  Future<void> _cargarYAsignarInfo() async {
    final infoReferencias =
        await infoReferenciasProvider.obtenerInfoReferenciasPorCedula(widget.numberID);

    if (!mounted || infoReferencias == null) return;

    setState(() {
      referenciasControllers[0].fromReferencia(
        tipo: infoReferencias.tipoReferenciaUno,
        relacion: infoReferencias.relacionReferenciaUno,
        nombre: infoReferencias.nombreReferenciaUno,
        celular: infoReferencias.celularReferenciaUno?.toString(),
      );

      referenciasControllers[1].fromReferencia(
        tipo: infoReferencias.tipoReferenciaDos,
        relacion: infoReferencias.relacionReferenciaDos,
        nombre: infoReferencias.nombreReferenciaDos,
        celular: infoReferencias.celularReferenciaDos?.toString(),
      );

      _loading = false;
    });
  }

  Future<void> _submitForm() async {
    // 1️⃣ Validar dropdowns y campos
    for (var ref in referenciasControllers) {
      ref.validate();
    }

    bool formValid = _formKey.currentState!.validate();
    bool hasError = referenciasControllers.any((ref) => ref.hasError) || !formValid;

    if (hasError) return;

    setState(() => _loading = true);

    // 2️⃣ Crear modelo para Hive
    final referencias = Referencia(
      cedulaProspecto: widget.numberID,
      tipoReferenciaUno: referenciasControllers[0].tipoMap(_tipoReferencias),
      relacionReferenciaUno:
          referenciasControllers[0].relacionMap(_relacionReferencias),
      nombreReferenciaUno: referenciasControllers[0].nombre.text,
      celularReferenciaUno: int.parse(referenciasControllers[0].celular.text),
      tipoReferenciaDos: referenciasControllers[1].tipoMap(_tipoReferencias),
      relacionReferenciaDos:
          referenciasControllers[1].relacionMap(_relacionReferencias),
      nombreReferenciaDos: referenciasControllers[1].nombre.text,
      celularReferenciaDos: int.parse(referenciasControllers[1].celular.text),
      isComplete: true,
    );

    await infoReferenciasProvider.eliminarInfoReferencias(widget.numberID);
    await infoReferenciasProvider.guardarInfoReferencias(widget.numberID, referencias);

    // 3️⃣ Enviar al API
    var dataReferencias = referenciasControllers.map((ref) {
      return ReferenciaApi(
        tipo: ref.tipoSeleccionado ?? '',
        relacion: ref.relacionSeleccionada ?? '',
        nombre: ref.nombre.text.trim(),
        celular: ref.celular.text.trim(),
      ).toJson();
    }).toList();

    final data = {
      "operacion": "crea_referencias",
      'identificacion': widget.numberID,
      'datos': dataReferencias,
    };

    try {
      final response = await ApiService.bodyApi(body: data);

      if (response.statusCode == 201) {
        await _showMessage("Referencias guardadas", "Referencias guardadas correctamente.", true);
      } else {
        await _showMessage("Error", "Error al guardar la información de referencias.");
      }
    } catch (e) {
      await _showMessage("Error",
          "No se encontró información con el número de identificación notificado.");
    }

    setState(() => _loading = false);
  }

  Future<void> _showMessage(String title, String content, [bool success = false]) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (success) widget.onCompleted(true);
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Agrega tu información de referencias",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(referenciasControllers.length, (i) {
                    return ReferenciaFormWidget(
                      index: i + 1,
                      refController: referenciasControllers[i],
                      tipoReferencias: _tipoReferencias,
                      relacionReferencias: _relacionReferencias,
                    );
                  }),
                  const SizedBox(height: 6),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Guardar referencias",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (_loading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class ReferenciaFormController {
  final tipoCtrl = TextEditingController();
  final relacionCtrl = TextEditingController();
  final nombre = TextEditingController();
  final celular = TextEditingController();

  final tipoError = ValueNotifier<String?>(null);
  final relacionError = ValueNotifier<String?>(null);

  String? tipoSeleccionado;
  String? relacionSeleccionada;

  void fromReferencia({
    Map<String, String>? tipo,
    Map<String, String>? relacion,
    String? nombre,
    String? celular,
  }) {
    if (tipo != null && tipo.isNotEmpty) {
      tipoCtrl.text = tipo.keys.first;
      tipoSeleccionado = tipo.keys.first;
    }
    if (relacion != null && relacion.isNotEmpty) {
      relacionCtrl.text = relacion.keys.first;
      relacionSeleccionada = relacion.keys.first;
    }
    this.nombre.text = nombre ?? '';
    this.celular.text = celular ?? '';
  }

  void validate() {
    tipoError.value = tipoCtrl.text.isEmpty ? "Campo requerido" : null;
    relacionError.value = relacionCtrl.text.isEmpty ? "Campo requerido" : null;
  }

  bool get hasError => tipoError.value != null || relacionError.value != null;

  Map<String, String> tipoMap(Map<String, String> map) =>
      {tipoCtrl.text: map[tipoCtrl.text]!};

  Map<String, String> relacionMap(Map<String, Map<String, String>> map) =>
      {relacionCtrl.text: map[tipoSeleccionado]![relacionCtrl.text]!};

  void dispose() {
    tipoCtrl.dispose();
    relacionCtrl.dispose();
    nombre.dispose();
    celular.dispose();
    tipoError.dispose();
    relacionError.dispose();
  }
}

class ReferenciaFormWidget extends StatefulWidget {
  final int index;
  final ReferenciaFormController refController;
  final Map<String, String> tipoReferencias;
  final Map<String, Map<String, String>> relacionReferencias;

  const ReferenciaFormWidget({
    super.key,
    required this.index,
    required this.refController,
    required this.tipoReferencias,
    required this.relacionReferencias,
  });

  @override
  State<ReferenciaFormWidget> createState() => _ReferenciaFormWidgetState();
}

class _ReferenciaFormWidgetState extends State<ReferenciaFormWidget> {
  @override
  Widget build(BuildContext context) {
    final refController = widget.refController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Referencia ${widget.index}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        DropdownMapValidatedFieldWidget(
          controller: refController.tipoCtrl,
          labelText: "Tipo de Referencia",
          itemsMap: widget.tipoReferencias,
          initialValue: refController.tipoCtrl.text,
          errorNotifier: refController.tipoError,
          onChanged: (String? newValue) {
            setState(() { // 👈 ahora fuerza el rebuild
              refController.tipoSeleccionado = newValue;
              refController.relacionSeleccionada = null;
              refController.relacionCtrl.clear();
            });
          },
        ),
        if (refController.tipoSeleccionado != null ||
            refController.tipoCtrl.text.isNotEmpty)
          DropdownMapValidatedFieldWidget(
            controller: refController.relacionCtrl,
            labelText: "Relación Referencia",
            itemsMap: widget.relacionReferencias[
                refController.tipoSeleccionado ?? refController.tipoCtrl.text]!,
            initialValue: refController.relacionCtrl.text,
            errorNotifier: refController.relacionError,
            onChanged: (String? newValue) {
              setState(() {
                refController.relacionSeleccionada = newValue;
              });
            },
          ),
        const SizedBox(height: 10),
        LeftAlignedLabel("Nombre"),
        const SizedBox(height: 6),
        TextFormField(
          controller: refController.nombre,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldPositive),
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "Campo requerido" : null,
        ),
        const SizedBox(height: 10),
        LeftAlignedLabel("Celular"),
        const SizedBox(height: 6),
        TextFormField(
          controller: refController.celular,
          maxLength: 10,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldPositive),
            ),
            counterText: '',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return "Campo requerido";
            if (value.length != 10) return "Debe tener 10 dígitos";
            return null;
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}


class ReferenciaApi {
  final String tipo;
  final String relacion;
  final String nombre;
  final String celular;

  ReferenciaApi({
    required this.tipo,
    required this.relacion,
    required this.nombre,
    required this.celular,
  });

  Map<String, dynamic> toJson() {
    return {
      'tipo': tipo,
      'relacion': relacion,
      'nombre': nombre,
      'celular': celular,
    };
  }
}
