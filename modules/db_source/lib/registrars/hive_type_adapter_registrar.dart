import 'package:hive/hive.dart';
import 'package:models/authentication_data.dart';
import 'package:models/consulta_transunion_response.dart';
import 'package:models/create_prospect_request.dart';
import 'package:models/create_tracking_request.dart';
import 'package:models/info_addres_box.dart';
import 'package:models/info_laboral_box.dart';
import 'package:models/info_personal_box.dart';
import 'package:models/info_referencias_box.dart';
import 'package:models/prospect_response.dart';
import 'package:models/login_request.dart';
import 'package:models/tracking_prospect_model.dart';

class HiveTypeAdapterRegistrar {
  static void registerAll() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(LoginRequestAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AuthenticationDataAdapter());
    }

    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ProspectResponseAdapter());
    }

    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CreateProspectRequestAdapter());
    }

    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(TrackingProspectModelAdapter());
    }

    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(CreateTrackingRequestAdapter());
    }
    //se registra el adaptador para InfoPersonalBox
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(InfoPersonalBoxAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(InfoAddresBoxAdapter());
    }

    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(ReferenciaAdapter());
    }
    
    if (!Hive.isAdapterRegistered(9)) {
      Hive.registerAdapter(InfoLaboralBoxAdapter());
    }

    if (!Hive.isAdapterRegistered(10)) {
    Hive.registerAdapter(ConsultaTransunionResponseAdapter());
    }
  }
}
