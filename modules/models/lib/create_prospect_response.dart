import 'package:json_annotation/json_annotation.dart';

part 'create_prospect_response.g.dart';

@JsonSerializable()
class CreateProspectResponse {
  final int? code;
  final String? status;
  final String? message;
  final CreateProspectData? data;
  final String? idSolicitud;

  CreateProspectResponse({
    this.code,
    this.status,
    this.message,
    this.data,
    this.idSolicitud
  });

  factory CreateProspectResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateProspectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProspectResponseToJson(this);
}

@JsonSerializable()
class CreateProspectData {
  @JsonKey(name: 'id_prospecto')
  final int? prospectId;

  final RespuestaTransunion? respuestaTransunion;

  CreateProspectData({
    required this.prospectId,
    this.respuestaTransunion,
  });

  factory CreateProspectData.fromJson(Map<String, dynamic> json) =>
      _$CreateProspectDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProspectDataToJson(this);
}

@JsonSerializable()
class RespuestaTransunion {
  final String? CurrentQueue;
  final String? Decision;
  final String? ApplicationId;
  final dynamic Examen;

  RespuestaTransunion({
    this.CurrentQueue,
    this.Decision,
    this.ApplicationId,
    this.Examen,
  });

  factory RespuestaTransunion.fromJson(Map<String, dynamic> json) =>
      _$RespuestaTransunionFromJson(json);

  Map<String, dynamic> toJson() => _$RespuestaTransunionToJson(this);
}
