import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:user_interface/utils/application.dart';

class InfoAddresProvider {
  late Box box;

  Future<bool> inicializarBox() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final userID = Application().authenticationData.numberID; // Asegúrate de que userID esté definido en tu aplicación
    box = await Hive.openBox('info_Addres_box_$userID');
    return box.isOpen;
  }

  Future<void> limpiarBox() async {
    await box.clear(); // vaciar registros
  }

  Future<bool> guardarInfoAddres(String cedulaProspecto, var infoAddres) async {
    await box.put(cedulaProspecto, infoAddres);
    return true;
  }

  Map<dynamic, dynamic> obtenerInfoAddres() {
    Map<dynamic, dynamic> infoAddres = box.toMap();
    return infoAddres;
  }

  Future<dynamic> obtenerInfoAddresPorCedula(String cedulaProspecto) async {
    var infoAddres = await box.get(cedulaProspecto);
    return infoAddres;
  }

  Future<bool> eliminarInfoAddres(String indice) async {
    await box.delete(indice);
    return true;
  }

  Future<bool> actualizarInfoAddres(int indice, var infoAddres) async {
    await box.putAt(indice, infoAddres);
    return true;
  }

  dispose() {
    box.close();
  }
}
