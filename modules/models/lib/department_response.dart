import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DepartmentResponse {
  final String codDepto;
  final String codMpio;
  final String dpto;
  final String municipio;
  final String codCentroPoblado;
  final String centroPoblado;

  DepartmentResponse(
      {required this.codDepto,
      required this.codMpio,
      required this.dpto,
      required this.municipio,
      required this.codCentroPoblado,
      required this.centroPoblado});

  factory DepartmentResponse.fromJson(Map<String, dynamic> json) {
    return DepartmentResponse(
      codDepto: json['COD_DEPTO'].toString(),
      codMpio: json['COD_MPIO'].toString(),
      dpto: json['DPTO'].toString(),
      municipio: json['MUNICIPIO'].toString(),
      codCentroPoblado: json['COD_CENTRO_POBLADO'].toString(),
      centroPoblado: json['CENTRO_POBLADO'],
    );
  }

  Map<String, dynamic> toJson() => {
        'COD_DEPTO': codDepto,
        'COD_MPIO': codMpio,
        'DPTO': dpto,
        'MUNICIPIO': municipio,
        'COD_CENTRO_POBLADO': codCentroPoblado,
        'CENTRO_POBLADO': centroPoblado,
      };
}
