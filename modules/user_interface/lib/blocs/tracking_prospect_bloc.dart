import 'dart:async';

import 'package:domain/get_all_tracking_prospect_use_case.dart';
import 'package:domain/save_all_tracking_prospect_local_use_case.dart';
import 'package:domain/get_all_tracking_prospect_local_use_case.dart';
import 'package:domain/get_all_create_tracking_prospect_local_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_tracking_request.dart';
import 'package:models/prospect_request.dart';
import 'package:models/tracking_prospect_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_interface/blocs/bloc.dart';
import 'package:user_interface/utils/extensions/behavior_subject_extension.dart';
import 'package:user_interface/utils/internet_connectivity_universal_util.dart';
import 'package:user_interface/widgets/alert/dialog_content.dart';

@injectable
class TrackingProspectBloc extends Bloc {
  TrackingProspectBloc(
    this._getAllTrackingProspectUseCase,
    this._saveAllTrackingProspectLocalUseCase,
    this._getAllTrackingProspectLocalUseCase,
    this._getAllCreateTrackingProspectLocalUseCase,
    this._connectivityUtil,
  ) {
    _startMonitoringInternal();
  }

  final GetAllTrackingProspectUseCase _getAllTrackingProspectUseCase;
  final SaveAllTrackingProspectLocalUseCase
      _saveAllTrackingProspectLocalUseCase;
  final GetAllTrackingProspectLocalUseCase _getAllTrackingProspectLocalUseCase;
  final GetAllCreateTrackingProspectLocalUseCase
      _getAllCreateTrackingProspectLocalUseCase;
  final InternetConnectivityUniversalUtil _connectivityUtil;

  final BehaviorSubject<List<TrackingProspectModel>> _trackingProspectSubject =
      BehaviorSubject();

  Stream<List<TrackingProspectModel>> get trackingProspectStream =>
      _trackingProspectSubject.stream;

  // Var connection
  final BehaviorSubject<bool> _connectivitySubject =
      BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<bool> _statusSubject = BehaviorSubject.seeded(false);

  ValueStream<bool> get internetStatusStream => _statusSubject.stream;

  Stream<bool> get connectivityStream => _connectivitySubject.stream;

  bool get isConnected => _connectivitySubject.value;

  late StreamSubscription<bool> connectivitySubscription;
  @override
  void dispose() {
    _trackingProspectSubject.close();
    connectivitySubscription.cancel();
    _connectivitySubject.close();
    _statusSubject.close();
    super.dispose();
  }

  Future<void> _startMonitoringInternal() async {
    final initialStatus = await _connectivityUtil.hasInternet;
    _connectivitySubject.add(initialStatus);

    connectivitySubscription = _connectivityUtil.onConnectivityChanged.listen(
      (isConnected) {
        print('TrackingProspectBloc: Connectivity changed to: $isConnected');
        _connectivitySubject.add(isConnected);
      },
      onError: (error) {
        print('🚨 TrackingProspectBloc: Error in connectivity stream: $error');
        _connectivitySubject.add(false);
      },
      onDone: () {
        print(
            '🚪 TrackingProspectBloc: Connectivity stream completed unexpectedly.');
        _connectivitySubject.add(false);
      },
    );
  }

  void getTrackingProspect(String? identification) {
    if (identification == null) {
      return;
    }

    var numberID = int.parse(identification);

    var request = ProspectRequest(
      operation: "consulta_seguimientos_prospecto",
      numberID: numberID,
    );

    _getAllTrackingProspectUseCase.save(request).then((value) {
      _trackingProspectSubject.addSecure(value);
      _saveAllTrackingProspectLocalUseCase.call(value, identification);
      handleLoading(false);
    }).onError((error, trace) async {
      handleLoading(false);
      try {
        final trackingProspects =
            await _getAllTrackingProspectLocalUseCase.call(identification);
        final createTrackingProspectLocal =
            await getCreateTrackingProspectLocal(identification);
        _trackingProspectSubject.addSecure(trackingProspects);

        trackingProspects.addAll(createTrackingProspectLocal);
      } catch (error, _) {
        showError(message: l10n.messageErrorGeneral);
      }
    }).whenComplete(() {
      handleLoading(false);
    });
  }

  Future<List<TrackingProspectModel>> getCreateTrackingProspectLocal(
      String prospectNumberID) async {
    return _getAllCreateTrackingProspectLocalUseCase
        .call(prospectNumberID)
        .then((createTrackingProspects) =>
            trackingProspectMapper(createTrackingProspects));
  }

  List<TrackingProspectModel> trackingProspectMapper(
      List<CreateTrackingRequest> createTrackingProspects) {
    List<TrackingProspectModel> trackingProspects = [];

    for (var createTracking in createTrackingProspects) {
      print( '_______________________:::::::::::::${createTracking.toJson()}');
      final newTrackingProspectModel = TrackingProspectModel(
        callDate: createTracking.date,
        comment: createTracking.comment,
        geolocation: createTracking.geolocation,
      );

      trackingProspects.add(newTrackingProspectModel);
    }

    return trackingProspects;
  }

  void showError({String? title, String? message}) {
    dialogSubject.addSecure(
      DialogContent(
        title: title ?? l10n.allAppName,
        message: message ?? l10n.formContainsErrors,
        positiveButtonText: l10n.allAccept,
        dismissible: true,
      ),
    );
  }
}
