import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:user_interface/utils/application.dart';

class InfoReferenciasProvider {
  
  late Box box;

  Future<bool> inicializarBox() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final userID = Application().authenticationData.numberID; // Asegúrate de que userID esté definido en tu aplicación
    box = await Hive.openBox('info_Referencias_box_$userID');
    return box.isOpen;
  }

  Future<bool> guardarInfoReferencias(String cedulaProspecto, var infoReferencias) async {
    await box.put(cedulaProspecto, infoReferencias);
    return true;
  }

  Map<dynamic, dynamic> obtenerInfoReferencias(){
    Map<dynamic, dynamic> infoReferencias = box.toMap();
    return infoReferencias;
  }

  Future<dynamic> obtenerInfoReferenciasPorCedula(String cedulaProspecto) async {
    var infoReferencias = await box.get(cedulaProspecto);
    return infoReferencias;
  }

  Future<bool> eliminarInfoReferencias(String indice) async {
    await box.delete(indice);
    return true;
  }

  Future<bool> actualizarInfoReferencias(int indice, var infoReferencias) async {
    await box.putAt(indice, infoReferencias);
    return true;
  }
  

    dispose(){
    box.close();
  }
}