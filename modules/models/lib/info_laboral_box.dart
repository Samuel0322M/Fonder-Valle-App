import 'package:hive/hive.dart';

part 'info_laboral_box.g.dart';

@HiveType(typeId: 9)
class InfoLaboralBox {
  @HiveField(0)
  String? cedulaProspecto;
  @HiveField(1)
  String? ocupacion; 
  @HiveField(2)
  String? tipoIndependiente;
  @HiveField(3)
  String? actividad; 
  @HiveField(4)
  int? nitEmpresa;
  @HiveField(5)
  String? nombreEmpresa;
  @HiveField(6)
  String? nombreJefe;
  @HiveField(7)
  int? numeroJefe;
  @HiveField(8)
  String fechaIngreso;
  @HiveField(9)
  String? descripcion;
  @HiveField(10)
  int? ingresos;
  @HiveField(11)
  int? gastos;
  @HiveField(12)
  bool isComplete;

  InfoLaboralBox({
    required this.cedulaProspecto,
    required this.ocupacion,
    this.tipoIndependiente,
    this.actividad,
    this.nitEmpresa,
    this.nombreEmpresa,
    this.nombreJefe,
    this.numeroJefe,
    required this.fechaIngreso,
    this.descripcion,
    required this.ingresos,
    required this.gastos,
    required this.isComplete,
  });
}
