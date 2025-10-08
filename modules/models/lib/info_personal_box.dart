import 'package:hive/hive.dart';

part 'info_personal_box.g.dart';

//se crea la tabla de info personal
@HiveType(typeId: 6)
  class InfoPersonalBox {
    @HiveField(0)
    String? cedulaProspecto;
    @HiveField(1)
    Map<String, String>? estadoCivil;
    @HiveField(2)
    String? nombreConyuge;
    @HiveField(3)
    int? celularConyuge;
    @HiveField(4)
    Map<String, String>? ocupacionConyuge;
    @HiveField(5)
    int? personasACargo;
    @HiveField(6)
    bool isComplete = false;

    InfoPersonalBox({
      required this.cedulaProspecto,
      required this.estadoCivil,
      this.nombreConyuge,
      this.celularConyuge,
      this.ocupacionConyuge,
      required this.personasACargo,
      required this.isComplete
    });
  }

