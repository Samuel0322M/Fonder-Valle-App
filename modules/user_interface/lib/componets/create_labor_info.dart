import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:models/info_laboral_box.dart';
import 'package:user_interface/providers/info_laboral_provider.dart';
import 'package:user_interface/utils/general_api.dart';
import 'package:user_interface/widgets/dropdown_map_validated_widget.dart';

import 'package:user_interface/widgets/labor_form_fields.dart';

class FormLaborInfo extends StatefulWidget {
  const FormLaborInfo({super.key, required this.numberID, required this.onCompleted});

  final String numberID;
  final Function(bool) onCompleted;

  @override
  State<FormLaborInfo> createState() => _FormLaborInfoState();
}

class _FormLaborInfoState extends State<FormLaborInfo> {
  var infoLaboralProvider = InfoLaboralProvider();

  InfoLaboralBox? _infoLaboral;

  @override
  void initState() {
    super.initState();
    _initProvider(); // 👈 llamar a la función de inicialización
  }

  Future<void> _initProvider() async {
    await infoLaboralProvider.inicializarBox(); // 👈 importante esperar aquí
    await _cargarYAsignarInfo(); // ya puedes consultar el box
  }

  Future<void> _cargarYAsignarInfo() async {
    final infoLaboral = await infoLaboralProvider.obtenerInfoLaboralPorCedula(widget.numberID);

    if (infoLaboral != null) {

      _infoLaboral = infoLaboral;
      setState(() {
        _occupationController.text = infoLaboral.ocupacion;
        _independentTypeController.text = infoLaboral.tipoIndependiente ?? '';
        _activityController.text = infoLaboral.actividad ?? '';
        _companyNitController.text = infoLaboral.nitEmpresa.toString();
        _companyNameController.text = infoLaboral.nombreEmpresa ?? '';
        _bossNameController.text = infoLaboral.nombreJefe ?? '';
        _bossPhoneController.text = infoLaboral.numeroJefe.toString();
        _descriptionController.text = infoLaboral.descripcion ?? '';
        _incomeController.text = infoLaboral.ingresos.toString();
        _expensesController.text = infoLaboral.gastos.toString();

        print(infoLaboral.fechaIngreso);
        if (infoLaboral.fechaIngreso.isNotEmpty) {
          print(infoLaboral.fechaIngreso);
          final yearStr = infoLaboral.fechaIngreso.toString().substring(0, 4);
          final monthStr = infoLaboral.fechaIngreso.toString().substring(4, 6);
          final dayStr = infoLaboral.fechaIngreso.toString().substring(6, 8);
          _entryDateController.text = "$dayStr-$monthStr-$yearStr";
        }
      });
    }
  }

  @override
  void dispose() {
    infoLaboralProvider.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final _occupationController = TextEditingController();
  final _independentTypeController = TextEditingController();
  final _activityController = TextEditingController();
  final _companyNitController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _bossNameController = TextEditingController();
  final _bossPhoneController = TextEditingController();
  final _entryDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();
  DateTime? _entryDate;
  bool _loading = false;

  final ValueNotifier<String?> _occupationError = ValueNotifier(null);
  final ValueNotifier<String?> _independentTypeError = ValueNotifier(null);
  final ValueNotifier<String?> _activityError = ValueNotifier(null);

  final Map<String, String> _occupationOptions = {
    'I': 'Independiente',
    'E': 'Empleado',
    'P': 'Pensionado',
  };

  void _selectEntryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      print("estoy en picked");
      _entryDate = picked;

      _entryDateController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  } // dd-MM-yyyy

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    // Asegurarse de no mandar residuos
    final String ocupacion = _occupationController.text;
    final String tipoIndependiente = ocupacion == 'I' ? _independentTypeController.text : '';
    final String actividad = ocupacion == 'P'
        ? '0'
        : (ocupacion == 'E' || ocupacion == 'I')
            ? _activityController.text
            : '';

    final String nitEmpresa = ocupacion == 'P'
        ? '0'
        : ocupacion == 'I' && _independentTypeController.text == 'Informal'
            ? '0'
            : (ocupacion == 'E' ||
                    (ocupacion == 'I' && _independentTypeController.text == 'Formal'))
                ? _companyNitController.text
                : '';
    final String nombreEmpresa = ocupacion == 'P'
        ? 'N/A'
        : ocupacion == 'I' && _independentTypeController.text == 'Informal'
            ? '0'
            : (ocupacion == 'E' ||
                    (ocupacion == 'I' && _independentTypeController.text == 'Formal'))
                ? _companyNameController.text
                : '';

    final String nombreJefe = ocupacion == 'E' ? _bossNameController.text : '';
    final String celularJefe = ocupacion == 'E' ? _bossPhoneController.text : '';

    String fechaIngreso;

      if (_entryDate != null) {
    // Nueva fecha seleccionada
    fechaIngreso = DateFormat('yyyyMMdd').format(_entryDate!);
  } else if (_infoLaboral!.fechaIngreso.isNotEmpty) {
    // Mantener la fecha que ya estaba guardada
    fechaIngreso = _infoLaboral!.fechaIngreso;
  } else {
    // No había fecha antes y tampoco seleccionó una nueva
    fechaIngreso = "";
  }

    final infoLaboralBox = InfoLaboralBox(
      cedulaProspecto: widget.numberID,
      ocupacion: ocupacion,
      tipoIndependiente: tipoIndependiente,
      actividad: actividad,
      nitEmpresa: int.tryParse(nitEmpresa) ?? 0,
      nombreEmpresa: nombreEmpresa,
      nombreJefe: nombreJefe,
      numeroJefe: int.tryParse(celularJefe) ?? 0,
      fechaIngreso: fechaIngreso,
      descripcion: _descriptionController.text,
      ingresos: int.tryParse(_incomeController.text.replaceAll('.', '')) ?? 0,
      gastos: int.tryParse(_expensesController.text.replaceAll('.', '')) ?? 0,
      isComplete: true,
    );

    await infoLaboralProvider.eliminarInfoLaboral(widget.numberID);
    await infoLaboralProvider.guardarInfoLaboral(widget.numberID, infoLaboralBox);

    final Map<String, dynamic> data = {
      "operacion": "actualiza_informacion_laboral",
      'identificacion': widget.numberID,
      'ocupacion': ocupacion,
      'tipo_independiente': tipoIndependiente,
      'actividad': actividad,
      'nit_empresa': nitEmpresa,
      'nombre_empresa': nombreEmpresa,
      'nombre_jefe': nombreJefe,
      'celular_jefe': celularJefe,
      'fecha_ingreso': fechaIngreso,
      'descripcion': _descriptionController.text,
      'ingresos': _incomeController.text.replaceAll('.', ''),
      'egresos': _expensesController.text.replaceAll('.', ''),
    };

    print("🔍 Payload final: ${jsonEncode(data)}");

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
              title: const Text("Información laboral guardada"),
              content: const Text("Información laboral guardada correctamente."),
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
              content: const Text("Error al guardar la información laboral."),
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
            content: const Text(
                "No se encontró información con el número de identificación notificado."),
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
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Informacion Laboral",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownMapValidatedFieldWidget(
                  controller: _occupationController,
                  labelText: 'Ocupación',
                  itemsMap: _occupationOptions,
                  errorNotifier: _occupationError,
                  initialValue: _occupationController.text,
                  onChanged: (value) {
                    setState(() {
                      _independentTypeController.clear();
                      _activityController.clear();
                      _companyNitController.clear();
                      _companyNameController.clear();
                      _bossNameController.clear();
                      _bossPhoneController.clear();
                      _entryDateController.clear();
                      _descriptionController.clear();
                      _incomeController.clear();
                      _expensesController.clear();
                    }); // para mostrar u ocultar campos del cónyuge
                  },
                ),
                const SizedBox(height: 16),
                LaborFormFields(
                  occupationController: _occupationController,
                  independentTypeController: _independentTypeController,
                  activityController: _activityController,
                  companyNitController: _companyNitController,
                  companyNameController: _companyNameController,
                  bossNameController: _bossNameController,
                  bossPhoneController: _bossPhoneController,
                  entryDateController: _entryDateController,
                  descriptionController: _descriptionController,
                  incomeController: _incomeController,
                  expensesController: _expensesController,
                  occupationError: _occupationError,
                  independentTypeError: _independentTypeError,
                  activityError: _activityError,
                  onDateTap: _selectEntryDate,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Guardar Info Laboral',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    );
  }
}
