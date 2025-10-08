import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:domain/create_prospect/local/create_prospect_local_use_case.dart';
import 'package:flutter/material.dart';
import 'package:domain/create_prospect/remote/create_prospect_use_case.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:models/create_prospect_request.dart';
import 'package:models/department_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_interface/blocs/bloc.dart';
import 'package:user_interface/pages/transunion_code_send_page.dart';
import 'package:user_interface/pages/transunion_questions_page.dart';
import 'package:user_interface/utils/application.dart';
import 'package:user_interface/utils/extensions/behavior_subject_extension.dart';
import 'package:user_interface/utils/internet_connectivity_universal_util.dart';
import 'package:user_interface/utils/load_department.dart';
import 'package:user_interface/widgets/alert/dialog_content.dart';

@injectable
class CreateProspectBloc extends Bloc {
  CreateProspectBloc(
    this._createProspectUseCase,
    this._createProspectLocalUseCase,
    this._connectivityUtil,
  ) {
    _startMonitoringInternal();
  }

  final CreateProspectUseCase _createProspectUseCase;

  final CreateProspectLocalUseCase _createProspectLocalUseCase;
  final InternetConnectivityUniversalUtil _connectivityUtil;

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
  String? _frontIdPhotoBase64;
  String? _backIdPhotoBase64;
  String? _facePhotoBase64;
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
  final ValueNotifier<String?> frontPhotoError = ValueNotifier(null);
  final ValueNotifier<String?> backPhotoError = ValueNotifier(null);
  final ValueNotifier<String?> facePhotoError = ValueNotifier(null);
  final ValueNotifier<Uint8List?> frontIdPhotoPreview = ValueNotifier(null);
  final ValueNotifier<Uint8List?> backIdPhotoPreview = ValueNotifier(null);
  final ValueNotifier<Uint8List?> facePhotoPreview = ValueNotifier(null);
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
  final ValueNotifier<String?> viaWhatsAppError = ValueNotifier(null);

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
    viaWhatsAppError.dispose();
    super.dispose();
  }

  Future<void> _startMonitoringInternal() async {
    final initialStatus = await _connectivityUtil.hasInternet;
    _connectivitySubject.add(initialStatus);

    connectivitySubscription = _connectivityUtil.onConnectivityChanged.listen(
      (isConnected) {
        print('CreateProspectBloc: Connectivity changed to: $isConnected');
        _connectivitySubject.add(isConnected);
      },
      onError: (error) {
        print('🚨 CreateProspectBloc: Error in connectivity stream: $error');
        _connectivitySubject.add(false);
      },
      onDone: () {
        print('🚪 CreateProspectBloc: Connectivity stream completed unexpectedly.');
        _connectivitySubject.add(false);
      },
    );
  }

  Future<void> loadDepartmentsData() async {
    final data = await LoadDepartment().loadDepartmentsFromAsset();
    allDepartments.value = data;
    departmentsList.value = data.map((e) => e.dpto).toSet().toList()..sort();
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

  void updateFrontIdPhoto(Uint8List bytes) {
    frontIdPhotoPreview.value = bytes;
    _frontIdPhotoBase64 = base64Encode(bytes);
  }

  void updateExpeditionDate(DateTime? date) {
    _expeditionDate = date;
    expeditionDateError.value = (_expeditionDate == null) ? l10n.requiredField : null;
  }

  void updateBackIdPhoto(Uint8List bytes) {
    backIdPhotoPreview.value = bytes;
    _backIdPhotoBase64 = base64Encode(bytes);
  }

  void updateFacePhoto(Uint8List bytes) {
    facePhotoPreview.value = bytes;
    _facePhotoBase64 = base64Encode(bytes);
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

  void updateviaWhatsApp(String? value) {
    _viaWhatsApp = value;
    viaWhatsAppError.value =
        (_viaWhatsApp == null || _viaWhatsApp!.isEmpty) ? l10n.requiredField : null;
  }

  void updateNeighborhood(String value) {
    _neighborhood = value.trim();
    neighborhoodError.value = _neighborhood!.isEmpty ? l10n.requiredField : null;
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

  void updateAmountIncome(String value) {
    final parsed = int.tryParse(value);
    _amountIncome = parsed;
    amountIncomeError.value = (parsed == null || parsed <= 0) ? l10n.invalidAmount : null;
  }

  void updateComment(String value) {
    _comment = value.trim();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialogMessage(
        title: 'Activar GPS',
        message: 'Para continuar, por favor activa el GPS de tu dispositivo.',
        dismissible: false,
        positiveButtonCallback: () {
          Geolocator.openLocationSettings();
        },
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    _latitude = position.latitude;
    _longitude = position.longitude;
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
    updateviaWhatsApp(_viaWhatsApp ?? '');

    final hasFieldError = [
      firstNameError.value,
      lastNameError.value,
      idNumberError.value,
      contactPhoneError.value,
      emailError.value,
      amountToFinanceError.value,
      amountIncomeError.value,
      expeditionDateError.value,
      viaWhatsAppError.value,
    ].any((e) => e != null);

    return !hasFieldError;
  }

  bool validateFile() {
    final hasError = [
      _frontIdPhotoBase64,
      _backIdPhotoBase64,
      _facePhotoBase64,
    ].any((e) => e == null);

    return !hasError;
  }

  void createProspect(BuildContext context) async {
    final isValid = validateForm();

    var numberID = Application().authenticationData.numberID;
    if (numberID == null || !isValid) {
      showDialogMessage(title: l10n.titleError);
      return;
    }

    /* if (!validateFile()) {
    showDialogMessage(title: l10n.titleError, message: "Cargue los archivos correctamente");
    return;
    }*/

    handleLoading(true);

    await getCurrentLocation();

    final geolocationString =
        (_latitude != null && _longitude != null) ? '$_latitude,$_longitude' : null;

    var createProspect = _buildCreateProspectRequest(numberID, geolocationString);

    _createProspectUseCase.save(createProspect).then((response) {
      final currentQueueValue = response.data?.respuestaTransunion?.CurrentQueue;
      final applicationId = response.data?.respuestaTransunion?.ApplicationId;
      final prospectId = response.data?.prospectId;
      final examen = response.data?.respuestaTransunion?.Examen;

      handleLoading(false);

      if (examen is Map<String, dynamic>) {
        // Si tenemos examen en formato JSON, vamos a la página de preguntas
        showDialogMessage(
            message:
                "${l10n.prospectusCreatedSuccessfully} \n Se ha consulado correctamente se procedera a realizar las preguntas",
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
            message:
                "${l10n.prospectusCreatedSuccessfully} \n Se ha consulado correctamente se procedera a solicitar el codigo OTP",
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
          message: "${l10n.prospectusCreatedSuccessfully} \n No se pudo confirmar la identidad del cliente.",
          positiveButtonCallback: () => canGoBack.value = true,
        );
      }
    }).onError((error, trace) {
      // Si falla la conexión o hay error en el endpoint
      handleLoading(false);

      _createProspectLocalUseCase.save(createProspect).then((_) {
        showDialogMessage(
          message: 'Se ha almacenado localmente',
          positiveButtonCallback: () => canGoBack.value = true,
        );
      }).onError((error, trace) {
        showDialogMessage(message: l10n.messageErrorGeneral);
      });
    }).whenComplete(() {
      handleLoading(false);
    });
  }

  CreateProspectRequest _buildCreateProspectRequest(String advisorId, String? geo) {
    return CreateProspectRequest(
        operation: "prospectos",
        firstName: _firstName!,
        middleName: _middleName,
        lastName: _lastName!,
        secondLastName: _secondLastName,
        idNumber: _idNumber!,
        phone: _contactPhone!,
        email: _email!,
        companyId: 1,
        amountToFinance: _amountToFinance!.toString(),
        amountToIncome: _amountIncome!.toString(),
        comment: _comment ?? "",
        geolocation: geo,
        advisorId: advisorId,
        occupation: _occupation,
        departmentId: _selectedDepartmentId,
        cityId: _selectedCityId,
        districtId: _selectedSettlementId,
        viaWhatsapp: _viaWhatsApp,
        expeditionDate:
            _expeditionDate != null ? DateFormat('yyyyMMdd').format(_expeditionDate!) : null);
  }

  void showDialogMessage(
      {String? title,
      String? message,
      bool dismissible = true,
      VoidCallback? positiveButtonCallback}) {
    dialogSubject.addSecure(
      DialogContent(
          title: title ?? l10n.allAppName,
          message: message ?? l10n.formContainsErrors,
          positiveButtonText: l10n.allAccept,
          dismissible: dismissible,
          positiveButtonCallback: positiveButtonCallback),
    );
  }
}
