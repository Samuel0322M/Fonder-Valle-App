import 'dart:async';
import 'dart:ui';

import 'package:domain/create_prospect/local/create_prospect_local_use_case.dart';
import 'package:domain/create_prospect/remote/create_prospect_use_case.dart';
import 'package:domain/create_prospect_tracking_use_case.dart';
import 'package:domain/ge_all_prospect_local_use_case.dart';
import 'package:domain/get_all_create_tracking_prospect_local_use_case.dart';
import 'package:domain/delete_create_tracking_local_use_case.dart';
import 'package:domain/prospect_request_use_case.dart';
import 'package:domain/save_all_prospect_local_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';
import 'package:models/create_tracking_request.dart';
import 'package:models/prospect_request.dart';
import 'package:models/prospect_response.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_interface/blocs/bloc.dart';
import 'package:user_interface/utils/application.dart';
import 'package:user_interface/utils/extensions/behavior_subject_extension.dart';
import 'package:user_interface/utils/internet_connectivity_universal_util.dart';
import 'package:user_interface/widgets/alert/dialog_content.dart';

@injectable
class HomeBloc extends Bloc {
  HomeBloc(
    this._prospectRequestUseCase,
    this._saveAllProspectLocalUseCase,
    this._getAllProspectLocalUseCase,
    this._createProspectLocalUseCase,
    this._createProspectUseCase,
    this._getAllCreateTrackingProspectLocalUseCase,
    this._createProspectTrackingUseCase,
    this._deleteCreateTrackingLocalUseCase,
    this._connectivityUtil,
  ) {
    _startMonitoringInternal();
  }

  final ProspectRequestUseCase _prospectRequestUseCase;
  final SaveAllProspectLocalUseCase _saveAllProspectLocalUseCase;
  final GetAllProspectLocalUseCase _getAllProspectLocalUseCase;
  final CreateProspectLocalUseCase _createProspectLocalUseCase;
  final CreateProspectUseCase _createProspectUseCase;
  final DeleteCreateTrackingLocalUseCase _deleteCreateTrackingLocalUseCase;
  final InternetConnectivityUniversalUtil _connectivityUtil;

  final GetAllCreateTrackingProspectLocalUseCase
      _getAllCreateTrackingProspectLocalUseCase;
  final CreateProspectTrackingUseCase _createProspectTrackingUseCase;

  final BehaviorSubject<List<ProspectResponse>> _prospectSubject =
      BehaviorSubject();

  final BehaviorSubject<String> _nameAdvisorSubject = BehaviorSubject();

  Stream<List<ProspectResponse>> get prospectStream => _prospectSubject.stream;

  Stream<String> get nameAdvisorStream => _nameAdvisorSubject.stream;

  // Var connection
  final BehaviorSubject<bool> _connectivitySubject =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<bool> _statusSubject = BehaviorSubject.seeded(false);

  ValueStream<bool> get internetStatusStream => _statusSubject.stream;

  Stream<bool> get connectivityStream => _connectivitySubject.stream;

  bool get isConnected => _connectivitySubject.value;

  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void dispose() {
    _prospectSubject.close();
    _connectivitySubscription?.cancel();
    _connectivitySubject.close();
    super.dispose();
  }

  Future<void> _startMonitoringInternal() async {
    await _connectivityUtil.initialize();
    _connectivitySubscription?.cancel();

    final initialStatus = await _connectivityUtil.hasInternet;
    _connectivitySubject.add(initialStatus);

    _connectivitySubscription = _connectivityUtil.onConnectivityChanged.listen(
      (isConnected) {
        print('HomeBLOC: Connectivity changed to: $isConnected');
        _connectivitySubject.add(isConnected);
        syncDataLocal();
        if (!isConnected) {
          offlineMessage();
        }
      },
      onError: (error) {
        print('🚨 HomeBLOC: Error in connectivity stream: $error');
        _connectivitySubject.add(false);
        offlineMessage();
      },
      onDone: () {
        print('🚪 HomeBLOC: Connectivity stream completed unexpectedly.');
        _connectivitySubject.add(false);
        offlineMessage();
      },
    );
  }

  void getAllProspect() async {
    handleLoading(true);

    var numberID = Application().authenticationData.numberID;
    _nameAdvisorSubject.add(Application().authenticationData.userName);
    if (numberID == null) {
      showDialogMessage(
          title: l10n.titleError, message: "Inicie sesión nuevamente");
      return;
    }

    var prospectRequest = ProspectRequest(
      operation: "consulta_prospectos_asesor",
      advisorId: int.parse(numberID),
    );

    _prospectRequestUseCase.save(prospectRequest).then((value) async {
      _prospectSubject.addSecure(value);
      _saveAllProspectLocalUseCase.call(value);
      await syncAllCreateTrackingData(value);
      handleLoading(false);
    }).onError((error, trace) {
      _nameAdvisorSubject.add(Application().authenticationData.userName);
      _getAllProspectLocalUseCase.call().then((value) async {
        final createProspect = await _getCreateProspect();

        if (createProspect!.isNotEmpty) {
          value.addAll(createProspect);
        }

        _prospectSubject.addSecure(value);
        handleLoading(false);
      }).onError((error, trace) {
        handleLoading(false);
        showDialogMessage(message: l10n.messageErrorGeneral);
      });
    }).whenComplete(() {
      handleLoading(false);
    });
  }

  Future<void> syncAllCreateTrackingData(
      List<ProspectResponse> prospects) async {
    for (final prospect in prospects) {
      await syncDataCreateTracking(prospect.numberID);
    }
  }

Future<List<ProspectResponse>?> _getCreateProspect() async {
  print("estoy en getCreateProspect");
  return _createProspectLocalUseCase.getAll().then((createProspects) async {
    final responses = prospectResponseMapper(createProspects);

    if (responses.isNotEmpty) {
      // Guardamos en Hive también
      await _saveAllProspectLocalUseCase.call(responses);
    }
    return responses;
  });
}


  List<ProspectResponse> prospectResponseMapper(
      List<CreateProspectRequest> createProspects) {
    List<ProspectResponse> prospectResponse = [];

    print("estoy en prospect response");

    for (var createProspect in createProspects) {
      final name =
          '${createProspect.firstName}  ${createProspect.middleName ?? ''}';
      final lastaName =
          '${createProspect.lastName} ${createProspect.secondLastName ?? ''}';
      final nameProspect = '$name $lastaName';

      final newProspectResponse = ProspectResponse(
        numberID: createProspect.idNumber ?? '0',
        tipoIdentificacion: createProspect.typeIdentification,
        nameProspect: nameProspect,
        name: createProspect.firstName,
        secondName: createProspect.middleName ?? '',
        lastName: createProspect.lastName,
        secondLastName: createProspect.secondLastName ?? '',
        cellphone: createProspect.phone,
        email: createProspect.email,
        valueRequested: createProspect.amountToFinance, 
        incomeValue: createProspect.amountToIncome,
        occupation: createProspect.occupation,
        expeditionDate: createProspect.expeditionDate,
        description: createProspect.comment,
        comment: createProspect.comment,
        nameAdvise: Application().authenticationData.userName,
        geolocation: createProspect.geolocation,
        idSolicitud : createProspect.idSolicitud,
        departmentId: createProspect.departmentId,
        cityId: createProspect.cityId,
        districtId: createProspect.districtId,
        viaWhatsapp: createProspect.viaWhatsapp
      );

      print("nuevos datos: ${newProspectResponse.name}, ${newProspectResponse.secondLastName}");

      prospectResponse.add(newProspectResponse);
    }

    return prospectResponse;
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

  Future<void> syncDataLocal() async {
    final isOnline = await _connectivityUtil.hasInternet;
    if (!isOnline) {
      return;
    }

    final createProspects = await _createProspectLocalUseCase.getAll();
    if (createProspects.isEmpty) {
      print('No local prospects to sync.');
      return;
    }

    print('Attempting to sync ${createProspects.length} local prospects...');
    for (final createProspect in createProspects) {
      try {
        print(
            '_____createProspect________:::::::::::::${createProspect.toJson()}');
        await _createProspectUseCase.save(createProspect);
      } catch (e, stackTrace) {
        print(
            '❌ HomeBloc: Error syncing prospect ${createProspect.idNumber}: $e\n$stackTrace');
      }
    }

    getAllProspect();
  }

  Future<void> syncDataCreateTracking(String prospectNumberID) async {
    return _getAllCreateTrackingProspectLocalUseCase
        .call(prospectNumberID)
        .then((createTrackingProspects) =>
            trackingProspectMapper(createTrackingProspects, prospectNumberID));
  }

  Future<void> trackingProspectMapper(
    List<CreateTrackingRequest> createTrackingProspects,
    String prospectNumberID,
  ) async {
    for (var createTracking in createTrackingProspects) {
      print('_______________________:::::::::::::${createTracking.toJson()}');
      _createProspectTrackingUseCase.save(createTracking);
    }

    await _deleteCreateTrackingLocalUseCase.call(prospectNumberID);
    await _createProspectLocalUseCase.delete(prospectNumberID);
  }
}
