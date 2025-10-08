import 'package:json_annotation/json_annotation.dart';

part 'form_prospect_response.g.dart';

@JsonSerializable()
class FormProspectResponse {
  final int? code;
  final String? status;
  final String? message;
  final FormProspectData? data;
  final String? idSolicitud;

  FormProspectResponse({
    this.code,
    this.status,
    this.message,
    this.data,
    this.idSolicitud
  });

  factory FormProspectResponse.fromJson(Map<String, dynamic> json) =>
      _$FormProspectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FormProspectResponseToJson(this);
}

@JsonSerializable()
class FormProspectData {
  @JsonKey(name: 'id_prospecto')
  final int? prospectId;

  final RespuestaTransunion? respuestaTransunion;

  FormProspectData({
    required this.prospectId,
    this.respuestaTransunion,
  });

  factory FormProspectData.fromJson(Map<String, dynamic> json) =>
      _$FormProspectDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormProspectDataToJson(this);
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
