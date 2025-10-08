import 'package:domain/create_prospect_tracking_use_case.dart';
import 'package:domain/save_create_tracking_prospect_local_use_case.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:models/create_tracking_request.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_interface/blocs/bloc.dart';
import 'package:user_interface/utils/application.dart';
import 'package:user_interface/utils/extensions/behavior_subject_extension.dart';
import 'package:user_interface/utils/internet_connectivity_universal_util.dart';
import 'package:user_interface/widgets/alert/dialog_content.dart';

@injectable
class CreateTrackingBloc extends Bloc {
  CreateTrackingBloc(
    this._createProspectTrackingUseCase,
    this._saveCreateTrackingProspectLocalUseCase,
    this._connectivityUtil,
  ) {
    _startMonitoringInternal();
  }

  final CreateProspectTrackingUseCase _createProspectTrackingUseCase;
  final SaveCreateTrackingProspectLocalUseCase
      _saveCreateTrackingProspectLocalUseCase;
  final InternetConnectivityUniversalUtil _connectivityUtil;

  String? _cedula;
  String? _date;
  String? _effective;
  int? _advisorId;
  String? _comment;
  double? _latitude;
  double? _longitude;
  String? _attachedFileBase64;

  final ValueNotifier<String?> idNumberError = ValueNotifier(null);
  final ValueNotifier<String?> advisorIDError = ValueNotifier(null);
  final ValueNotifier<String?> dateError = ValueNotifier(null);
  final ValueNotifier<String> formattedDateNotifier = ValueNotifier('');
  final ValueNotifier<bool> canGoBack = ValueNotifier(false);
  final ValueNotifier<String?> fileErrorNotifier = ValueNotifier(null);
  final ValueNotifier<String?> fileNameNotifier = ValueNotifier(null);
  final ValueNotifier<String?> effectiveNotifier = ValueNotifier(null);
  final ValueNotifier<String?> effectiveErrorNotifier = ValueNotifier(null);

  String? get effective => _effective;

  // Var connection
  final BehaviorSubject<bool> _connectivitySubject =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<bool> _statusSubject = BehaviorSubject.seeded(false);

  ValueStream<bool> get internetStatusStream => _statusSubject.stream;

  Stream<bool> get connectivityStream => _connectivitySubject.stream;

  bool get isConnected => _connectivitySubject.value;

  @override
  void dispose() {
    idNumberError.dispose();
    advisorIDError.dispose();
    dateError.dispose();
    formattedDateNotifier.dispose();
    canGoBack.dispose();
    _statusSubject.close();
    effectiveNotifier.dispose();
    effectiveErrorNotifier.dispose();
    super.dispose();
  }

  Future<void> _startMonitoringInternal() async {
    final initialStatus = await _connectivityUtil.hasInternet;
    _connectivitySubject.add(initialStatus);

    _connectivityUtil.onConnectivityChanged.listen(
      (isConnected) {
        print('CreateTrackingBloc: Connectivity changed to: $isConnected');
        _connectivitySubject.add(isConnected);
      },
      onError: (error) {
        print('🚨 CreateTrackingBloc: Error in connectivity stream: $error');
        _connectivitySubject.add(false);
      },
      onDone: () {
        print(
            '🚪 CreateTrackingBloc: Connectivity stream completed unexpectedly.');
        _connectivitySubject.add(false);
      },
    );
  }

  void clearAttachedFile() {
    _attachedFileBase64 = null;
    fileNameNotifier.value = null;
  }

  void updateAttachedFile(String base64, String fileName) {
    _attachedFileBase64 = base64;
    fileNameNotifier.value = fileName;
    fileErrorNotifier.value = null;
  }

  void updateIDNumber(String? value) {
    if (value == null) {
      return;
    }

    _cedula = value.trim();
    idNumberError.value = _cedula!.isEmpty ? l10n.requiredField : null;
  }

  void updateDate(DateTime date) {
    _date = DateFormat('yyyyMMdd').format(date);
    formattedDateNotifier.value = DateFormat('dd/MM/yyyy').format(date);
  }

/*  void updateEffective(String? value) {
    _effective = value;
    dateError.value = value == null ? l10n.requiredField : null;
  }*/

  void updateEffective(String? value) {
    if (value == null) {
      return;
    }
    effectiveNotifier.value = value;
    effectiveErrorNotifier.value = null;
  }

  void updateIdAsesor(String value) {
    final parsed = int.tryParse(value);
    _advisorId = parsed;
    advisorIDError.value = parsed == null ? l10n.invalidID : null;
  }

  void updateComment(String value) {
    _comment = value.trim();
  }

  String get formattedDate {
    if (_date == null) return '';
    final parsed = DateFormat('yyyyMMdd').parse(_date!);
    return DateFormat('dd/MM/yyyy').format(parsed);
  }

  bool validateForm() {
    updateIDNumber(_cedula ?? '');
    var numberID = Application().authenticationData.numberID;
    updateIdAsesor(numberID ?? '');

    final isDateValid = _date != null && _date!.isNotEmpty;

    return idNumberError.value == null &&
        advisorIDError.value == null &&
        isDateValid;
  }

  void createTracking() async {
    final isDateMissing = _date == null || _date!.isEmpty;

    if (!validateForm()) {
      final errorMessage =
          isDateMissing ? l10n.requiredDate : l10n.formContainsErrors;

      dialogSubject.addSecure(
        DialogContent(
          title: l10n.titleError,
          message: errorMessage,
          positiveButtonText: l10n.allAccept,
          dismissible: true,
        ),
      );
      return;
    }

    handleLoading(true);

    await getCurrentLocation();

    final geolocationString = (_latitude != null && _longitude != null)
        ? '$_latitude,$_longitude'
        : null;

    var request = CreateTrackingRequest(
      operation: "seguimientos",
      idNumber: _cedula!,
      date: _date!,
      efectiva: effectiveNotifier.value ?? "si",
      advisorId: _advisorId!,
      comment: _comment ?? '',
      geolocation: geolocationString,
      attached: _attachedFileBase64,
    );

    _createProspectTrackingUseCase.save(request).then((value) {
      handleLoading(false);
      showDialogMessage(
        message: l10n.trackingCreatedSuccessfully,
        positiveButtonCallback: () => canGoBack.value = true,
      );
    }).onError((error, trace) async {
      handleLoading(false);
      try {
        await _saveCreateTrackingProspectLocalUseCase.call(
          _cedula.toString(),
          request,
        );
        showDialogMessage(
          message:
              'Los datos han sido almacenado localmente hasta tener conexión a internet',
          positiveButtonCallback: () => canGoBack.value = true,
        );
      } catch (error, _) {
        showDialogMessage(message: l10n.messageErrorGeneral);
      }
    }).whenComplete(() {
      handleLoading(false);
    });
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
}
