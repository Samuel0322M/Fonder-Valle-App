import 'package:json_annotation/json_annotation.dart';

part 'prospect_request.g.dart';

@JsonSerializable(explicitToJson: true)
class ProspectRequest {
  @JsonKey(name: 'operacion')
  final String operation;

  @JsonKey(name: 'id_asesor')
  final int? advisorId;

  @JsonKey(name: 'identificacion')
  final int? numberID;

  ProspectRequest({required this.operation, this.advisorId, this.numberID});

  factory ProspectRequest.fromJson(Map<String, dynamic> json) =>
      _$ProspectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProspectRequestToJson(this);
}
