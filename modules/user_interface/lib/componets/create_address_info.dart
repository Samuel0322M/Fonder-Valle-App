import 'package:models/info_addres_box.dart';
import 'package:user_interface/providers/info_addres_provider.dart';
import 'package:user_interface/resources/theme/app_colors.dart';
import 'package:user_interface/utils/general_api.dart';
import 'package:user_interface/widgets/CurrencyInputFormatterCustom.dart';
import 'package:user_interface/widgets/buildlabel.dart';
import 'package:user_interface/widgets/dropdown_map_validated_widget.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class FormAddressInfo extends StatefulWidget {
  const FormAddressInfo({super.key, required this.numberID, required this.onCompleted});

  final String numberID;
  final ValueChanged<bool> onCompleted;

  @override
  State<FormAddressInfo> createState() => _FormAddressInfoState();
}

class _FormAddressInfoState extends State<FormAddressInfo> {
  final _formKey = GlobalKey<FormState>();

  final _addressController = TextEditingController();
  final _departmentController = TextEditingController();
  final _cityController = TextEditingController();
  final _settlementController = TextEditingController();
  final _housingTypeController = TextEditingController();
  final _houseValueController = TextEditingController();

  final _viaPrincipalController = TextEditingController();
  final _numeroUnoController = TextEditingController();
  final _letraUnoController = TextEditingController();
  final _complementoViaUnoController = TextEditingController();
  final _numeroDosController = TextEditingController();
  final _letraDosController = TextEditingController();
  final _complementoViaDosController = TextEditingController();
  final _numeroTresController = TextEditingController();
  final _letraTresController = TextEditingController();
  final _complementoViaTresController = TextEditingController();

  final ValueNotifier<String?> _departmentError = ValueNotifier(null);
  final ValueNotifier<String?> _cityError = ValueNotifier(null);
  final ValueNotifier<String?> _settlementError = ValueNotifier(null);
  final ValueNotifier<String?> _housingTypeError = ValueNotifier(null);

  bool isEditing = false;

  List<Map<String, dynamic>> _records = [];
  Map<String, String> _departmentsMap = {};
  Map<String, String> _citiesMap = {};
  Map<String, String> _settlementsMap = {};

  final Map<String, String> _housingTypes = {'P': 'Propia', 'F': 'Familiar', 'A': 'Arriendo'};

  final Map<String, String> _typeOfVia = {
    'AC': 'Avenida calle',
    'AD': 'Administración',
    'ADL': 'Adelante',
    'AER': 'Aeropuerto',
    'AG': '	Agencia',
    'AGP': 'Agrupación',
    'AK': 'Avenida carrera',
    'AL': 'Altillo',
    'ALD': 'Al lado',
    'ALM': 'Almacén',
    'AP	': 'Apartamento',
    'APTDO': 'Apartado',
    'ATR': 'Atrás',
    'AUT': 'Autopista',
    'AV': 'Avenida',
    'AVIAL': 'Anillo vial',
    'BG': 'Bodega',
    'BL': 'Bloque',
    'BLV': 'Boulevard',
    'BRR': 'Barrio',
    'C': 'Corregimiento',
    'CA': 'Casa',
    'CAS': 'Caserío',
    'CC': 'Centro comercial',
    'CD': 'Ciudadela',
    'CEL': 'Célula',
    'CEN': 'Centro',
    'CIR': 'Circular',
    'CL': 'Calle',
    'CLJ': 'Callejón',
    'CN': 'Camino',
    'CON': 'Conjunto residencial',
    'CONJ': 'Conjunto',
    'CR': 'Carrera',
    'CRT': 'Carretera',
    'CRV': 'Circunvalar',
    'CS': 'Consultorio',
    'DG': 'Diagonal',
    'DP': 'Depósito',
    'DPTO': 'Departamento',
    'DS': 'Depósito sótano',
    'ED': 'Edificio',
    'EN': 'Entrada',
    'ES': 'Escalera',
    'ESQ': 'Esquina',
    'ESTE': 'Este',
    'ET': 'Etapa',
    'EX': 'Exterior',
    'FCA': 'Finca',
    'GJ': 'Garaje',
    'GS': 'Garaje sótano',
    'GT': 'Glorieta',
    'HC': 'Hacienda',
    'HG': 'Hangar',
    'IN': 'Interior',
    'IP': 'Inspección de Policía',
    'IPD': 'Inspección Departamental',
    'IPM': 'Inspección Municipal',
    'KM': 'Kilómetro',
    'LC': 'Local',
    'LM': 'Local mezzanine',
    'LT': 'Lote',
    'MD': 'Módulo',
    'MJ': 'Mojón',
    'MLL': 'Muelle',
    'MN': 'Mezzanine',
    'MZ': 'Manzana',
    'NOMBRE': 'VIA	Vías de nombre común',
    'NORTE': 'Norte',
    'O': 'Oriente',
    'OCC': 'Occidente',
    'OESTE': 'Oeste',
    'OF': 'Oficina',
    'P': 'Piso',
    'PA': 'Parcela',
    'PAR': 'Parque',
    'PD': 'Predio',
    'PH': 'Penthouse',
    'PJ': 'Pasaje',
    'PL': 'Planta',
    'PN': 'Puente',
    'POR': 'Portería',
    'POS': 'Poste',
    'PQ': 'Parqueadero',
    'PRJ': 'Paraje',
    'PS': 'Paseo',
    'PT': 'Puesto',
    'PW': 'Park Way',
    'RP': 'Round Point',
    'SA': 'Salón',
    'SC': 'Salón comunal',
    'SD': 'Salida',
    'SEC': 'Sector',
    'SL': 'Solar',
    'SM': 'Súper manzana',
    'SS': 'Semisótano',
    'ST': 'Sótano',
    'SUITE': 'Suite',
    'SUR': 'Sur',
    'TER': 'Terminal',
    'TERPLN': 'Terraplén',
    'TO': 'Torre',
    'TV': 'Transversal',
    'TZ': 'Terraza',
    'UN': 'Unidad',
    'UR': 'Unidad residencial',
    'URB': 'Urbanización',
    'VRD': 'Vereda',
    'VTE': 'Variante',
    'ZF': 'Zona franca',
    'ZN': 'Zona',
  };

  bool get _showHouseValue => _housingTypeController.text == 'P';

  bool _loading = false;

  var infoAddresProvider = InfoAddresProvider();

  bool _jsonLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadFromJson();
    await _initProvider();
    if (mounted) {
      setState(() {
        _jsonLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    infoAddresProvider.dispose();
    super.dispose();
  }

  Future<void> _initProvider() async {
    await infoAddresProvider.inicializarBox(); // 👈 importante esperar aquí
    await _cargarYAsignarInfo(); // ya puedes consultar el box
  }

  Future<void> _cargarYAsignarInfo() async {
    final infoAddres = await infoAddresProvider.obtenerInfoAddresPorCedula(widget.numberID);

    if (!mounted) return;

    if (infoAddres != null) {
      setState(() {
        // Estado civil
        _addressController.text = infoAddres.direccion ?? '';

        if (infoAddres.departamento != null && infoAddres.departamento!.isNotEmpty) {
          _departmentController.text = infoAddres.departamento!;
          _onSelectDepartment(_departmentController.text);
        }

        if (infoAddres.municipio != null && infoAddres.municipio!.isNotEmpty) {
          _cityController.text = infoAddres.municipio!;
          _onSelectCity(_cityController.text);
        }

        if (infoAddres.centroPoblado != null && infoAddres.centroPoblado!.isNotEmpty) {
          _settlementController.text = infoAddres.centroPoblado!;
        }

        if (infoAddres.tipoVivienda != null && infoAddres.tipoVivienda!.isNotEmpty) {
          _housingTypeController.text = infoAddres.tipoVivienda!;
        }

        _houseValueController.text =
            (infoAddres.valorCasa != null) ? infoAddres.valorCasa.toString() : '0';
      });
    }
  }

  Future<void> _loadFromJson() async {
    final jsonStr = await rootBundle.loadString('assets/department_cities.json');
    final List raw = json.decode(jsonStr);

    _records = raw
        .cast<Map<String, dynamic>>()
        .where(
            (e) => e['DPTO'] != null && e['DPTO'] is String && e['DPTO'] != 'Nombre Departamento')
        .toList();

    _departmentsMap = {
      for (var item in _records) item['COD_DEPTO'].toString(): item['DPTO'].toString()
    };
  }

  void _onSelectDepartment(String? codDept) {
    _departmentController.text = codDept ?? '';
    _cityController.text = '';
    _settlementController.text = '';
    _settlementController.clear();
    _citiesMap = {
      for (var item in _records)
        if (item['COD_DEPTO'] == codDept) item['COD_MPIO'].toString(): item['MUNICIPIO'].toString()
    };
    _settlementsMap = {};
    setState(() {});
  }

  void _onSelectCity(String? codCity) {
    _cityController.text = codCity ?? '';
    _settlementController.text = '';
    _settlementController.clear();
    _settlementsMap = {
      for (var item in _records)
        if (item['COD_DEPTO'].toString() == _departmentController.text &&
            item['COD_MPIO'].toString() == codCity)
          item['COD_CENTRO_POBLADO'].toString(): item['CENTRO_POBLADO'].toString()
    };
    setState(() {});
  }

  void _onSelectSettlement(String? sett) {
    _settlementController.text = sett ?? '';
    setState(() {});
  }

  void _onSelectHousingType(String? type) {
    _housingTypeController.text = type ?? '';
    if (!_showHouseValue) _houseValueController.text = '0';
    setState(() {});
  }

  void _updateAddress() {
    final via = _viaPrincipalController.text;
    final num1 = _numeroUnoController.text;
    final letra1 = _letraUnoController.text;
    final complemento1 = _complementoViaUnoController.text;
    final num2 = _numeroDosController.text;
    final letra2 = _letraDosController.text;
    final complemento2 = _complementoViaDosController.text;
    final num3 = _numeroTresController.text;
    final letra3 = _letraTresController.text;
    final complemento3 = _complementoViaTresController.text;

    final direccion =
        '$via $num1$letra1 $complemento1 $num2$letra2 $complemento2 $num3$letra3 $complemento3';

    if (!mounted) return;
    setState(() {
      _addressController.text = direccion.trim();
    });
  }

  Future<void> _submitForm() async {
    bool hasError = false;

    // Validar Departamento
    if (_departmentController.text.isEmpty) {
      _departmentError.value = 'Campo requerido';
      hasError = true;
    } else {
      _departmentError.value = null;
    }

    // Validar Municipio
    if (_cityController.text.isEmpty) {
      _cityError.value = 'Campo requerido';
      hasError = true;
    } else {
      _cityError.value = null;
    }

    // Validar Centro Poblado (solo si hay lista)
    if (_settlementsMap.isNotEmpty && _settlementController.text.isEmpty) {
      _settlementError.value = 'Campo requerido';
      hasError = true;
    } else {
      _settlementError.value = null;
    }

    // Validar Tipo de vivienda
    if (_housingTypeController.text.isEmpty) {
      _housingTypeError.value = 'Campo requerido';
      hasError = true;
    } else {
      _housingTypeError.value = null;
    }

    // Validar otros campos del formulario
    if (!_formKey.currentState!.validate()) {
      hasError = true;
    }

    // Validar campos de texto normales
    bool formValid = _formKey.currentState!.validate();

    // Si algún dropdown o campo está mal, no continuar
    if (hasError || !formValid) return;

    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
    });

    final infoAddresBox = InfoAddresBox(
        cedulaProspecto: widget.numberID,
        direccion: _addressController.text,
        departamento: _departmentController.text,
        municipio: _cityController.text,
        centroPoblado: _settlementController.text,
        tipoVivienda: _housingTypeController.text,
        valorCasa: _houseValueController.text.replaceAll('.', '').isEmpty
            ? 0
            : int.parse(_houseValueController.text.replaceAll('.', '')),
        isComplete: true);

    print("tipo departamento ${_departmentController.text}, ${_departmentsMap[_departmentController.text]!}");
    await infoAddresProvider.eliminarInfoAddres(widget.numberID);
    await infoAddresProvider.guardarInfoAddres(widget.numberID, infoAddresBox);

    final data = {
      "operacion": "actualiza_informacion_residencia",
      "identificacion": widget.numberID,
      'direccion': _addressController.text,
      'departamento': _departmentController.text,
      'municipio': _cityController.text,
      'centro_poblado': _settlementController.text,
      'tipo_vivienda': _housingTypeController.text,
      'valor_casa': _houseValueController.text.replaceAll('.', ''),
    };

    print(data);

    try {
      final response = await ApiService.bodyApi(body: data);

      print("🔍 Status code: ${response.statusCode}");
      print("🔍 Body: ${response.body}");
      print("🔍 Headers: ${response.headers}");

      if (!mounted) return;
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
    if (!_jsonLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(0.9)), // 👈 limita el tamaño del texto
          child: Column(
                children: [
                  Text("Informacion Domicilio",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  DropdownMapValidatedFieldWidget(
                    labelText: "Via Principal",
                    controller: _viaPrincipalController,
                    itemsMap: _typeOfVia,
                    onChanged: (value) {
                      _viaPrincipalController.text = value ?? '';
                      _updateAddress();
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const LeftAlignedLabel("Numero"),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 90,
                            child: TextFormField(
                              controller: _numeroUnoController,
                              maxLength: 4,
                              onChanged: (_) => _updateAddress(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.textFieldPositive),
                                ),
                                counterText: "",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8, width: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const LeftAlignedLabel("Letra"),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 90,
                          child: TextFormField(
                            controller: _letraUnoController,
                            maxLength: 4,
                            onChanged: (_) => _updateAddress(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textFieldPositive),
                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8, width: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8),
                        const LeftAlignedLabel("Complemento Via"),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            controller: _complementoViaUnoController,
                            maxLength: 10,
                            onChanged: (_) => _updateAddress(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textFieldPositive),
                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  Row(children: [
                    const SizedBox(height: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LeftAlignedLabel("Numero"),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 90,
                            child: TextFormField(
                              controller: _numeroDosController,
                              maxLength: 4,
                              onChanged: (value) => _updateAddress(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.textFieldPositive),
                                ),
                                counterText: "",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8, width: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const LeftAlignedLabel("Letra"),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 90,
                          child: TextFormField(
                            controller: _letraDosController,
                            maxLength: 4,
                            onChanged: (value) => _updateAddress(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textFieldPositive),
                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8, width: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8),
                        const LeftAlignedLabel("Complemento Via"),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            controller: _complementoViaDosController,
                            maxLength: 4,
                            onChanged: (value) => _updateAddress(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textFieldPositive),
                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 8, width: 35),
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const LeftAlignedLabel("Numero"),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 90,
                            child: TextFormField(
                              controller: _numeroTresController,
                              maxLength: 4,
                              onChanged: (value) => _updateAddress(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.textFieldPositive),
                                ),
                                counterText: "",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8, width: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const LeftAlignedLabel("Letra"),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 90,
                          child: TextFormField(
                            controller: _letraTresController,
                            maxLength: 4,
                            onChanged: (value) => _updateAddress(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textFieldPositive),
                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8, width: 35),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8),
                        const LeftAlignedLabel("Complemento Via"),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            controller: _complementoViaTresController,
                            maxLength: 4,
                            onChanged: (value) => _updateAddress(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textFieldPositive),
                              ),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const LeftAlignedLabel("Dirección"),
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    controller: _addressController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.textFieldPositive),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                  ),
                  DropdownMapValidatedFieldWidget(
                    controller: _departmentController,
                    labelText: 'Departamento',
                    itemsMap: _departmentsMap,
                    errorNotifier: _departmentError,
                    initialValue: _departmentController.text,
                    onChanged: _onSelectDepartment,
                  ),
                  if (_citiesMap.isNotEmpty)
                    DropdownMapValidatedFieldWidget(
                      controller: _cityController,
                      labelText: 'Municipio',
                      itemsMap: _citiesMap,
                      errorNotifier: _cityError,
                      initialValue: _cityController.text,
                      onChanged: _onSelectCity,
                    ),
                  if (_settlementsMap.isNotEmpty)
                    DropdownMapValidatedFieldWidget(
                      controller: _settlementController,
                      labelText: 'Centro Poblado',
                      itemsMap: _settlementsMap,
                      errorNotifier: _settlementError,
                      initialValue: _settlementController.text,
                      onChanged: _onSelectSettlement,
                    ),
                  DropdownMapValidatedFieldWidget(
                    controller: _housingTypeController,
                    labelText: 'Tipo de vivienda',
                    itemsMap: _housingTypes,
                    errorNotifier: _housingTypeError,
                    initialValue: _housingTypeController.text,
                    onChanged: _onSelectHousingType,
                  ),
                  const SizedBox(height: 16),
                  if (_showHouseValue) ...[
                    const LeftAlignedLabel("Valor de la casa"),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _houseValueController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CurrencyInputFormatterCustom()],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textFieldPositive),
                        ),
                      ),
                      validator: (val) {
                        if (val != null) {
                          val = val.replaceAll('.', '');
                        }
                        if (_showHouseValue &&
                            (val == null || val.isEmpty || int.tryParse(val) == null)) {
                          return 'Valor válido requerido';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
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
                      child: Text(isEditing ? 'Actualizar' : 'Guardar Info Domicilio',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                    ),
                  ),
                ],
              ),
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
