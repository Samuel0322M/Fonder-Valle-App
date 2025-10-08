import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:user_interface/utils/application.dart';

class InfoLaboralProvider {
  
  late Box box;

  Future<bool> inicializarBox() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final userID = Application().authenticationData.numberID; // Asegúrate de que userID esté definido en tu aplicación
    box = await Hive.openBox('info_Laboral_box_$userID');
    return box.isOpen;
  }

  Future<bool> guardarInfoLaboral(String cedulaProspecto, var infoLaboral) async {
    await box.put(cedulaProspecto, infoLaboral);
    return true;
  }

  Map<dynamic, dynamic> obtenerInfoLaboral(){
    Map<dynamic, dynamic> infoLaboral = box.toMap();
    return infoLaboral;
  }

  Future<dynamic> obtenerInfoLaboralPorCedula(String cedulaProspecto) async {
    var infoLaboral = await box.get(cedulaProspecto);
    return infoLaboral;
  }

  Future<bool> eliminarInfoLaboral(String indice) async {
    await box.delete(indice);
    return true;
  }

  Future<bool> actualizarInfoLaboral(int indice, var infoLaboral) async {
    await box.putAt(indice, infoLaboral);
    return true;
  }
  

    dispose(){
    box.close();
  }
}