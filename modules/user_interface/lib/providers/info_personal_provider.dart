import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:user_interface/utils/application.dart';

class InfoPersonalProvider {
  
  late Box box;

  Future<bool> inicializarBox() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final userID = Application().authenticationData.numberID; // Asegúrate de que userID esté definido en tu aplicación
    box = await Hive.openBox('info_personal_box_$userID');
    return box.isOpen;
  }

  Future<bool> guardarInfoPersonal(String cedulaProspecto, var infoPersonal) async {
    await box.put(cedulaProspecto, infoPersonal);
    return true;
  }

  Map<dynamic, dynamic> obtenerInfoPersonal(){
    Map<dynamic, dynamic> infoPersonal = box.toMap();
    return infoPersonal;
  }

  Future<dynamic> obtenerInfoPersonalPorCedula(String cedulaProspecto) async {
    var infoPersonal = await box.get(cedulaProspecto);
    return infoPersonal;
  }

  Future<bool> eliminarInfoPersonal(String indice) async {
    await box.delete(indice);
    return true;
  }

  Future<bool> actualizarInfoPersonal(int indice, var infoPersonal) async {
    await box.putAt(indice, infoPersonal);
    return true;
  }
  

    dispose(){
    box.close();
  }
}