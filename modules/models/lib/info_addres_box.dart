import 'package:hive/hive.dart';

part 'info_addres_box.g.dart';

//se crea la tabla de info Addres
@HiveType(typeId: 7)
  class InfoAddresBox {
    @HiveField(0)
    String? cedulaProspecto;
    @HiveField(1)
    String? direccion;
    @HiveField(2)
    String? departamento;
    @HiveField(3)
    String? municipio;
    @HiveField(4)
    String? centroPoblado;
    @HiveField(5)
    String? tipoVivienda;
    @HiveField(6)
    int? valorCasa;
    @HiveField(7)
    bool? isComplete = false;

    InfoAddresBox({
      required this.cedulaProspecto,
      this.direccion,
      this.departamento,
      this.municipio,
      this.centroPoblado,
      this.tipoVivienda,
      this.valorCasa,
      this.isComplete
    });
  }

