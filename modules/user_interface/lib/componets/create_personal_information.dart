import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/info_personal_box.dart';
import 'package:user_interface/providers/info_personal_provider.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/utils/general_api.dart';
import 'package:user_interface/widgets/buildlabel.dart';
import 'package:user_interface/widgets/dropdown_map_validated_widget.dart';

class FormPersonalInformation extends StatefulWidget {
  final String numberID;
  final ValueChanged<bool> onCompleted;

  const FormPersonalInformation({super.key, required this.numberID, required this.onCompleted});

  @override
  State<FormPersonalInformation> createState() => _FormPersonalInformationState();
}

class _FormPersonalInformationState extends State<FormPersonalInformation> {


  var infoPersonalProvider = InfoPersonalProvider();

  @override
  void initState() {
    super.initState();
    _initProvider(); // 👈 llamar a la función de inicialización
  }

  Future<void> _initProvider() async {
    await infoPersonalProvider.inicializarBox(); // 👈 importante esperar aquí
    await _cargarYAsignarInfo(); // ya puedes consultar el box
  }

  Future<void> _cargarYAsignarInfo() async {
    final infoPersonal = await infoPersonalProvider.obtenerInfoPersonalPorCedula(widget.numberID);

    if (infoPersonal != null) {
      setState(() {
        // Estado civil
        if (infoPersonal.estadoCivil != null && infoPersonal.estadoCivil!.isNotEmpty) {
          _civilStatusController.text = infoPersonal.estadoCivil!.keys.first;
        }

        // Personas a cargo
        _dependentsController.text = infoPersonal.personasACargo?.toString() ?? '';

        // Datos del cónyuge
        _spouseNameController.text = infoPersonal.nombreConyuge ?? '';
        _spousePhoneController.text = infoPersonal.celularConyuge?.toString() ?? '';
        if (infoPersonal.ocupacionConyuge != null && infoPersonal.ocupacionConyuge!.isNotEmpty) {
          _spouseOccupationController.text = infoPersonal.ocupacionConyuge!.keys.first;
        }
      });
    }
  }

  @override
  void dispose() {
    infoPersonalProvider.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _civilStatusController = TextEditingController();
  final TextEditingController _dependentsController = TextEditingController();

  final TextEditingController _spouseNameController = TextEditingController();
  final TextEditingController _spousePhoneController = TextEditingController();
  final TextEditingController _spouseOccupationController = TextEditingController();

  final ValueNotifier<String?> _civilStatusError = ValueNotifier(null);
  final ValueNotifier<String?> _spouseOccupationError = ValueNotifier(null);

  bool _loading = false;

  final Map<String, String> _civilStatusOptions = {
    's': 'Soltero',
    'c': 'Casado',
    'd': 'Separado',
    'v': 'Viudo'
  };

  final Map<String, String> _spouseOccupations = {
    'Empleado': 'Empleado',
    'Independiente': 'Independiente',
    'Ama': 'Ama de casa'
  };

  bool get _esSoltero => _civilStatusController.text == 's';

  Future<void> _submitForm() async {
    bool hasError = false;

    if (_civilStatusController.text.isEmpty) {
      _civilStatusError.value = "Campo Requerido";
      hasError = true;
    } else {
      _civilStatusError.value = null;
    }

    if (_spouseOccupationController.text.isEmpty && !_esSoltero) {
      _spouseOccupationError.value = "Campo Requerido";
      hasError = true;
    } else {
      _spouseOccupationError.value = null;
    }

    if (hasError) return;

    final isValid = _formKey.currentState!.validate();
    setState(() {
      if (isValid) {
        _loading = true;
      }
    });
    if (!isValid) return;

    String? nombreConyuge;
    int? celularConyuge;
    Map<String, String>? ocupacionConyuge;

    if (!_esSoltero) {
      nombreConyuge = _spouseNameController.text.isEmpty ? null : _spouseNameController.text;
      celularConyuge =
          _spousePhoneController.text.isEmpty ? null : int.parse(_spousePhoneController.text);
      ocupacionConyuge = _spouseOccupationController.text.isEmpty
          ? null
          : {
              _spouseOccupationController.text:
                  _spouseOccupations[_spouseOccupationController.text]!
            };
    }

// si es soltero => todo null
    final infoPersonalBox = InfoPersonalBox(
      cedulaProspecto: widget.numberID,
      estadoCivil: {
        _civilStatusController.text: _civilStatusOptions[_civilStatusController.text]!,
      },
      nombreConyuge: nombreConyuge,
      celularConyuge: celularConyuge,
      ocupacionConyuge: ocupacionConyuge,
      personasACargo:
          _dependentsController.text.isEmpty ? 0 : int.parse(_dependentsController.text),
      isComplete: true,
    );

    await infoPersonalProvider.eliminarInfoPersonal(widget.numberID);
    await infoPersonalProvider.guardarInfoPersonal(widget.numberID, infoPersonalBox);

    final data = {
      "operacion": "actualiza_informacion_personal",
      "identificacion": widget.numberID,
      'estado_civil': _civilStatusController.text,
      'personas_a_cargo': _dependentsController.text,
      'nombre_conyuge': _spouseNameController.text,
      'celular_conyuge': _spousePhoneController.text,
      'ocupacion_conyuge': _spouseOccupationController.text,
    };
    print(data);

    try {
      final response = await ApiService.bodyApi(body: data);

      print("🔍 Status code: ${response.statusCode}");
      print("🔍 Body: ${response.body}");
      print("🔍 Headers: ${response.headers}");

      if (response.statusCode == 200) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Información Personal guardada"),
              content: const Text("Información personal guardada correctamente."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onCompleted(true);
                  },
                  child: const Text("Aceptar"),
                ),
              ],
            );
          },
        );
      } else {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Error al guardar la información Personal."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Aceptar"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content:
                const Text("No se encontro informacion con el número de identificación notificado"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Aceptar"),
              ),
            ],
          );
        },
      );
      print("Error al enviar los datos: $e");
    }
    setState(() => _loading = false);
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
                  Center(
                    child: Text("Informacion Personal",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  DropdownMapValidatedFieldWidget(
                    controller: _civilStatusController,
                    labelText: 'Estado civil',
                    itemsMap: _civilStatusOptions,
                    errorNotifier: _civilStatusError,
                    initialValue: _civilStatusController.text,
                    onChanged: (value) {
                      setState(() {}); // para mostrar u ocultar campos del cónyuge
                    },
                  ),
                  const SizedBox(height: 16),
                  if (!_esSoltero) ...[
                    const LeftAlignedLabel("Nombre del cónyuge"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _spouseNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textFieldPositive),
                        ),
                      ),
                      validator: (value) => !_esSoltero && (value == null || value.isEmpty)
                          ? 'Campo requerido'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    const LeftAlignedLabel("Celular del cónyuge"),
                    const SizedBox(height: 8),
                    TextFormField(
                        controller: _spousePhoneController,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.textFieldPositive),
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (!_esSoltero && (value == null || value.isEmpty)) {
                            return 'Campo requerido';
                          }
                          if (value?.length != 10) {
                            return 'Debe tener 10 digitos';
                          }
                          return null;
                        }),
                    DropdownMapValidatedFieldWidget(
                      controller: _spouseOccupationController,
                      labelText: 'Ocupación del cónyuge',
                      itemsMap: _spouseOccupations,
                      initialValue: _spouseOccupationController.text,
                      errorNotifier: _spouseOccupationError,
                    ),
                    const SizedBox(height: 16),
                  ],
                  const LeftAlignedLabel("Personas a cargo"),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _dependentsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textFieldPositive),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48), // Alto fijo
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Actualizar Info Adicional',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
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
