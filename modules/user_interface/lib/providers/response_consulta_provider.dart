import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:user_interface/utils/application.dart';

class ResponseConsultaProvider {
  
  late Box box;

  Future<bool> inicializarBox() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final userID = Application().authenticationData.numberID; // Asegúrate de que userID esté definido en tu aplicación
    box = await Hive.openBox('response_consulta_provider_box_$userID');
    return box.isOpen;
  }

  Future<bool> guardarConsultaResponse(String cedulaProspecto, var consultaResponse) async {
    await box.put(cedulaProspecto, consultaResponse);
    return true;
  }

  Map<dynamic, dynamic> obtenerConsultaResponse(){
    Map<dynamic, dynamic> consultaResponse = box.toMap();
    return consultaResponse;
  }

  Future<dynamic> obtenerConsultaResponsePorCedula(String cedulaProspecto) async {
    var consultaResponse = await box.get(cedulaProspecto);
    return consultaResponse;
  }

  Future<bool> eliminarConsultaResponse(String indice) async {
    await box.delete(indice);
    return true;
  }

  Future<bool> actualizarConsultaResponse(int indice, var consultaResponse) async {
    await box.putAt(indice, consultaResponse);
    return true;
  } 
    dispose(){
    box.close();
  }
}