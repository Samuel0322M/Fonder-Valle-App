import 'package:hive/hive.dart';

part 'info_referencias_box.g.dart';

@HiveType(typeId: 8)
class Referencia {
  @HiveField(0)
  String? cedulaProspecto;
  @HiveField(1)
  Map<String, String>? tipoReferenciaUno;
  @HiveField(2)
  Map<String, String>? relacionReferenciaUno;
  @HiveField(3)
  String? nombreReferenciaUno;
  @HiveField(4)
  int? celularReferenciaUno;
  @HiveField(5)
  Map<String, String>? tipoReferenciaDos;
  @HiveField(6)
  Map<String, String>? relacionReferenciaDos;
  @HiveField(7)
  String? nombreReferenciaDos;
  @HiveField(8)
  int? celularReferenciaDos;
  @HiveField(9)
  bool isComplete = false;

  Referencia({
    required this.cedulaProspecto,
    required this.tipoReferenciaUno,
    required this.relacionReferenciaUno,
    required this.nombreReferenciaUno,
    required this.celularReferenciaUno,
    required this.tipoReferenciaDos,
    required this.relacionReferenciaDos,
    required this.nombreReferenciaDos,
    required this.celularReferenciaDos,
    required this.isComplete,
  });

}
