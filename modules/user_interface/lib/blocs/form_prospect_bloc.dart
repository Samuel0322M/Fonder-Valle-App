import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:models/department_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_interface/blocs/bloc.dart';
import 'package:user_interface/pages/transunion_code_send_page.dart';
import 'package:user_interface/pages/transunion_questions_page.dart';
import 'package:user_interface/utils/extensions/behavior_subject_extension.dart';
import 'package:user_interface/utils/internet_connectivity_universal_util.dart';
import 'package:user_interface/utils/load_department.dart';
import 'package:user_interface/widgets/alert/dialog_content.dart';

@injectable
class FormProspectBloc extends Bloc {
  FormProspectBloc(this._connectivityUtil) {
    _startMonitoringInternal();
  }

  final InternetConnectivityUniversalUtil _connectivityUtil;

  // Datos del formulario
  String? _firstName;
  String? _middleName;
  String? _lastName;
  String? _secondLastName;
  String? _idNumber;
  String? _contactPhone;
  String? _email;
  int? _amountToFinance;
  int? _amountIncome;
  String? _comment;
  double? _latitude;
  double? _longitude;
  DateTime? _expeditionDate;
  String? _occupation;
  String? _typeIdentification;
  String? _neighborhood;
  String? _selectedDepartmentId;
  String? _selectedCityId;
  String? _selectedSettlementId;
  String? _viaWhatsApp;

  final ValueNotifier<String?> firstNameError = ValueNotifier(null);
  final ValueNotifier<String?> lastNameError = ValueNotifier(null);
  final ValueNotifier<String?> idNumberError = ValueNotifier(null);
  final ValueNotifier<String?> contactPhoneError = ValueNotifier(null);
  final ValueNotifier<String?> emailError = ValueNotifier(null);
  final ValueNotifier<String?> neighborhoodError = ValueNotifier(null);
  final ValueNotifier<String?> amountToFinanceError = ValueNotifier(null);
  final ValueNotifier<String?> amountIncomeError = ValueNotifier(null);
  final ValueNotifier<bool> canGoBack = ValueNotifier(false);
  final ValueNotifier<String?> departmentError = ValueNotifier(null);
  final ValueNotifier<String?> cityError = ValueNotifier(null);
  final ValueNotifier<String?> settlementError = ValueNotifier(null);
  final ValueNotifier<String?> selectedDepartmentNotifier = ValueNotifier(null);
  final ValueNotifier<String?> selectedCityNotifier = ValueNotifier(null);
  final ValueNotifier<String?> selectedSettlementNotifier = ValueNotifier(null);
  final ValueNotifier<List<DepartmentResponse>> allDepartments = ValueNotifier([]);
  final ValueNotifier<List<String>> departmentsList = ValueNotifier([]);
  final ValueNotifier<List<String>> citiesList = ValueNotifier([]);
  final ValueNotifier<List<String>> settlementsList = ValueNotifier([]);
  final ValueNotifier<String?> expeditionDateError = ValueNotifier(null);
  final ValueNotifier<String?> navigationTarget = ValueNotifier(null);
  final ValueNotifier<String?> occupationError = ValueNotifier(null);
  final ValueNotifier<String?> typeIdentificationError = ValueNotifier(null);
  final ValueNotifier<String?> viaWhatsApp = ValueNotifier(null);

  // Var connection
  final BehaviorSubject<bool> _connectivitySubject = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _statusSubject = BehaviorSubject.seeded(false);

  ValueStream<bool> get internetStatusStream => _statusSubject.stream;
  Stream<bool> get connectivityStream => _connectivitySubject.stream;
  bool get isConnected => _connectivitySubject.value;

  late StreamSubscription<bool> connectivitySubscription;

  @override
  void dispose() {
    firstNameError.dispose();
    lastNameError.dispose();
    idNumberError.dispose();
    contactPhoneError.dispose();
    emailError.dispose();
    neighborhoodError.dispose();
    amountToFinanceError.dispose();
    amountIncomeError.dispose();
    canGoBack.dispose();
    departmentError.dispose();
    cityError.dispose();
    settlementError.dispose();
    _connectivitySubject.close();
    _statusSubject.close();
    connectivitySubscription.cancel();
    selectedDepartmentNotifier.dispose();
    selectedCityNotifier.dispose();
    selectedSettlementNotifier.dispose();
    occupationError.dispose();
    typeIdentificationError.dispose();
    viaWhatsApp.dispose();
    super.dispose();
  }

  Future<void> _startMonitoringInternal() async {
    final initialStatus = await _connectivityUtil.hasInternet;
    _connectivitySubject.add(initialStatus);

    connectivitySubscription = _connectivityUtil.onConnectivityChanged.listen(
      (isConnected) {
        _connectivitySubject.add(isConnected);
      },
      onError: (_) => _connectivitySubject.add(false),
      onDone: () => _connectivitySubject.add(false),
    );
  }

  // ----------------- VALIDACIONES -----------------

  Future<void> loadDepartmentsData() async {
    final data = await LoadDepartment().loadDepartmentsFromAsset();
    allDepartments.value = data;
    departmentsList.value = data.map((e) => e.dpto).toSet().toList()..sort();

    // 🔥 Restaurar selección si ya existe un departamento seleccionado
    final selectedDept = selectedDepartmentNotifier.value;
    final selectedCity = selectedCityNotifier.value;
    final selectedSettlement = selectedSettlementNotifier.value;

    if (selectedDept != null) {
      // reconstruir lista de municipios
      final filteredCities = allDepartments.value
          .where((e) => e.dpto == selectedDept)
          .map((e) => e.municipio)
          .toSet()
          .toList()
        ..sort();

      citiesList.value = filteredCities;

      if (selectedCity != null) {
        // reconstruir lista de centros poblados
        final filteredSettlements = allDepartments.value
            .where((e) => e.dpto == selectedDept && e.municipio == selectedCity)
            .map((e) => e.centroPoblado)
            .toSet()
            .toList()
          ..sort();

        settlementsList.value = filteredSettlements;

        if (selectedSettlement != null && !filteredSettlements.contains(selectedSettlement)) {
          selectedSettlementNotifier.value = null;
        }
      }
    }
  }

  void onSelectDepartment(String? departmentName) {
    if (departmentName == null) {
      return;
    }

    selectDepartment(
      codDepartment: _getDepartmentCode(departmentName),
      departmentName: departmentName,
    );

    final filtered = allDepartments.value
        .where((e) => e.dpto == departmentName)
        .map((e) => e.municipio)
        .toList()
      ..sort();

    citiesList.value = filtered;
    settlementsList.value = [];
    selectedCityNotifier.value = null;
  }

  void onSelectCity(String? cityName) {
    if (cityName == null) {
      return;
    }

    selectCity(
      codCity: _getCityCode(cityName),
      cityName: cityName,
    );

    final filtered = allDepartments.value
        .where((e) => e.dpto == selectedDepartmentNotifier.value && e.municipio == cityName)
        .map((e) => e.centroPoblado)
        .toSet()
        .toList()
      ..sort();
    settlementsList.value = filtered;
  }

  void onSelectSettlement(String? settlementName) {
    if (settlementName == null) {
      return;
    }

    final item = allDepartments.value.firstWhere((e) =>
        e.dpto == selectedDepartmentNotifier.value &&
        e.municipio == selectedCityNotifier.value &&
        e.centroPoblado == settlementName);

    selectSettlement(
      codPopulationCenter: item.codCentroPoblado,
      settlementName: settlementName,
    );
  }

  void selectDepartment({
    required String codDepartment,
    required String departmentName,
  }) {
    _selectedDepartmentId = codDepartment;
    selectedDepartmentNotifier.value = departmentName;
    selectedCityNotifier.value = null;
    selectedSettlementNotifier.value = null;

    departmentError.value = null;
    cityError.value = null;
    settlementError.value = null;
  }

  void selectCity({
    required String codCity,
    required String cityName,
  }) {
    _selectedCityId = codCity;
    selectedCityNotifier.value = cityName;
    selectedSettlementNotifier.value = null;

    cityError.value = null;
    settlementError.value = null;

    updateNeighborhood(cityName);
  }

  void selectSettlement({
    required String codPopulationCenter,
    required String settlementName,
  }) {
    _selectedSettlementId = codPopulationCenter;
    selectedSettlementNotifier.value = settlementName;

    settlementError.value = null;
  }

  void updateSelectedDepartment(String codDepartment) {
    _selectedDepartmentId = codDepartment;
    if (codDepartment.isNotEmpty) {
      departmentError.value = null;
    }
  }

  void updateSelectedCity(String codCity) {
    _selectedCityId = codCity;
    if (codCity.isNotEmpty) {
      cityError.value = null;
    }
  }

  String? getDepartmentNameByCode(String code) {
    try {
      return allDepartments.value.firstWhere((e) => e.codDepto == code).dpto;
    } catch (_) {
      return null;
    }
  }

  String? getCityNameByCode(String deptoCode, String cityCode) {
    try {
      return allDepartments.value
          .firstWhere((e) => e.codDepto == deptoCode && e.codMpio == cityCode)
          .municipio;
    } catch (_) {
      return null;
    }
  }

  String? getSettlementNameByCode(String deptoCode, String cityCode, String settlementCode) {
    try {
      return allDepartments.value
          .firstWhere((e) =>
              e.codDepto == deptoCode &&
              e.codMpio == cityCode &&
              e.codCentroPoblado == settlementCode)
          .centroPoblado;
    } catch (_) {
      return null;
    }
  }

  String _getDepartmentCode(String departmentName) {
    return allDepartments.value.firstWhere((e) => e.dpto == departmentName).codDepto;
  }

  String _getCityCode(String cityName) {
    return allDepartments.value
        .firstWhere((e) => e.dpto == selectedDepartmentNotifier.value && e.municipio == cityName)
        .codMpio;
  }

  void updateSelectedSettlement(String codPopulationCenter) {
    _selectedSettlementId = codPopulationCenter;
    if (codPopulationCenter.isNotEmpty) {
      settlementError.value = null;
    }
  }

  void updateFirstName(String value) {
    _firstName = value.trim();
    firstNameError.value = _firstName!.isEmpty ? l10n.requiredField : null;
  }

  void updateMiddleName(String value) {
    _middleName = value.trim();
  }

  void updateLastName(String value) {
    _lastName = value.trim();
    lastNameError.value = _lastName!.isEmpty ? l10n.requiredField : null;
  }

  void updateSecondLastName(String value) {
    _secondLastName = value.trim();
  }

  void updateIdNumber(String value) {
    _idNumber = value.trim();
    idNumberError.value =
        (_idNumber!.isEmpty || int.tryParse(_idNumber!) == null) ? l10n.invalidNumber : null;
  }

  void updateNeighborhood(String value) {
    _neighborhood = value.trim();
    neighborhoodError.value = _neighborhood!.isEmpty ? l10n.requiredField : null;
  }

  void updatePhone(String value) {
    _contactPhone = value.trim();
    contactPhoneError.value = _contactPhone!.length < 7 ? l10n.invalidPhoneNumber : null;

    _contactPhone = value.trim().replaceAll(RegExp(r'\D'), '');

    if (_contactPhone!.isEmpty) {
      contactPhoneError.value = l10n.requiredField;
    } else if (_contactPhone!.length != 10) {
      contactPhoneError.value = l10n.invalidPhoneNumber;
    } else {
      contactPhoneError.value = null;
    }
  }

  void updateEmail(String value) {
    _email = value.trim();
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    emailError.value = emailRegex.hasMatch(_email!) ? null : l10n.invalidMail;
  }

  void updateAmountToFinance(String value) {
    final parsed = int.tryParse(value);
    _amountToFinance = parsed;
    amountToFinanceError.value = (parsed == null || parsed <= 0) ? l10n.invalidAmount : null;
  }

  void updateOccupation(String? value) {
    _occupation = value;
    occupationError.value =
        (_occupation == null || _occupation!.isEmpty) ? l10n.requiredField : null;
  }

  void updateTypeIdentification(String? value) {
    _typeIdentification = value;
    typeIdentificationError.value =
        (_typeIdentification == null || _typeIdentification!.isEmpty) ? l10n.requiredField : null;
  }

  void updateviaWhatsApp(String? value) {
    _viaWhatsApp = value;
    typeIdentificationError.value =
        (_viaWhatsApp == null || _viaWhatsApp!.isEmpty) ? l10n.requiredField : null;
  }

  void updateAmountIncome(String value) {
    final parsed = int.tryParse(value);
    _amountIncome = parsed;
    amountIncomeError.value = (parsed == null || parsed <= 0) ? l10n.invalidAmount : null;
  }

  void updateExpeditionDate(DateTime? date) {
    _expeditionDate = date;
    expeditionDateError.value = (_expeditionDate == null) ? l10n.requiredField : null;
  }

  void updateComment(String value) {
    _comment = value.trim();
  }

  bool validateForm() {
    updateFirstName(_firstName ?? '');
    updateLastName(_lastName ?? '');
    updateIdNumber(_idNumber ?? '');
    updatePhone(_contactPhone ?? '');
    updateEmail(_email ?? '');
    updateExpeditionDate(_expeditionDate);
    updateAmountToFinance(_amountToFinance?.toString() ?? '');
    updateAmountIncome(_amountIncome?.toString() ?? '');
    updateOccupation(_occupation ?? '');
    updateTypeIdentification(_typeIdentification ?? '');

    final hasFieldError = [
      firstNameError.value,
      lastNameError.value,
      idNumberError.value,
      contactPhoneError.value,
      emailError.value,
      amountToFinanceError.value,
      amountIncomeError.value,
      expeditionDateError.value,
    ].any((e) => e != null);

    return !hasFieldError;
  }

  // ----------------- SUBMIT -----------------
  Future<void> createProspect(BuildContext context) async {
    if (!validateForm()) {
      showDialogMessage(title: l10n.titleError, message: l10n.formContainsErrors);
      return;
    }

    if (!isConnected) {
      showDialogMessage(
        title: l10n.titleError,
        message: "No tienes conexión a internet",
      );
      return;
    }

    handleLoading(true);

    try {
      final url = Uri.parse("http://10.0.2.2:3001/api_creacion_prospecto_finan/prospecto/");
      final body = {
        "firstName": _firstName,
        "middleName": _middleName,
        "lastName": _lastName,
        "secondLastName": _secondLastName,
        "idNumber": _idNumber,
        "phone": _contactPhone,
        "email": _email,
        "amountToFinance": _amountToFinance?.toString(),
        "amountIncome": _amountIncome?.toString(),
        "comment": _comment ?? "",
        "geolocation": (_latitude != null && _longitude != null) ? "$_latitude,$_longitude" : null,
        "occupation": _occupation,
        "typeIdentification": _typeIdentification,
        "id_departamento": _selectedDepartmentId,
        "id_ciudad": _selectedCityId,
        "id_centro_poblado": _selectedSettlementId,
        "via_whatsapp": _viaWhatsApp,
        "expeditionDate":
            _expeditionDate != null ? DateFormat('yyyyMMdd').format(_expeditionDate!) : null,
      };

      print("Request Body: $body");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      handleLoading(false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Response Data: $data");

        // Ajustamos la lectura igual a lo que tenías
        final currentQueueValue = data["data"]?["respuestaTransunion"]?["CurrentQueue"];
        final applicationId = data["data"]?["respuestaTransunion"]?["ApplicationId"];
        final prospectId = data["data"]?["id_prospecto"];
        final examen = data["data"]?["respuestaTransunion"]?["Examen"];

        if (examen is Map<String, dynamic>) {
          // Si tenemos examen en formato JSON, vamos a la página de preguntas
          showDialogMessage(
              message: "Se ha consulado correctamente se procedera a realizar las preguntas",
              positiveButtonCallback: () {
                Navigator.pushNamed(
                  context,
                  TransunionQuestionsPage.route,
                  arguments: {
                    'applicationId': applicationId,
                    'prospectId': prospectId,
                    'examen': examen,
                    'cedulaCliente': _idNumber,
                  },
                );
              });
        } else if (currentQueueValue == "PinVerification_OTPInput") {
          // Si no hay examen, revisamos si es OTP u otro flujo
          showDialogMessage(
              message: "Se ha consulado correctamente se procedera a solicitar el codigo OTP",
              positiveButtonCallback: () {
                Navigator.pushNamed(
                  context,
                  transunionCodeValidation.route,
                  arguments: {
                    'applicationId': applicationId,
                    'prospectId': prospectId,
                    'cedulaCliente': _idNumber,
                  },
                );
              });
        } else {
          showDialogMessage(
            message: "No se pudo confirmar la identidad del cliente.",
            positiveButtonCallback: () => canGoBack.value = true,
          );
        }
      } else {
        showDialogMessage(
          title: l10n.titleError,
          message: "Error del servidor: ${response.statusCode}",
        );
        print("Error del servidor: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      handleLoading(false);
      showDialogMessage(message: "Error al enviar la información: $e");
      print("respuesta $e");
    }
  }

  // ----------------- UTILS -----------------
  void showDialogMessage({
    String? title,
    String? message,
    bool dismissible = true,
    VoidCallback? positiveButtonCallback,
  }) {
    dialogSubject.addSecure(
      DialogContent(
        title: title ?? l10n.allAppName,
        message: message ?? l10n.formContainsErrors,
        positiveButtonText: l10n.allAccept,
        dismissible: dismissible,
        positiveButtonCallback: positiveButtonCallback,
      ),
    );
  }
}
