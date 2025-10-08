import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consulta_transunion_response.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class ConsultaTransunionResponse {

  @HiveField(0)
  final String idProspect;
  @HiveField(1)
  final String cedulaCliente;
  @HiveField(2)
  final String? code;
  @HiveField(3)
  final String? decision;
  @HiveField(4)
  final String? homologada;
  @HiveField(5)
  final String? descripcion;
  @HiveField(6)
  final bool codeudor;

  const ConsultaTransunionResponse({
    required this.idProspect,
    required this.cedulaCliente,
    this.code,
    this.decision,
    this.homologada,
    this.descripcion,
    this.codeudor = false,
  });

  factory ConsultaTransunionResponse.fromJson(Map<String, dynamic> json) =>
      _$ConsultaTransunionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultaTransunionResponseToJson(this);

}



