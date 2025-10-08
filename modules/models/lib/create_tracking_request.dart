import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_tracking_request.g.dart';

@HiveType(typeId: 5)
@JsonSerializable(explicitToJson: true)
class CreateTrackingRequest {
  @HiveField(0)
  @JsonKey(name: 'operacion')
  final String operation;

  @HiveField(1)
  @JsonKey(name: 'cedula')
  final String idNumber;

  @HiveField(2)
  @JsonKey(name: 'fecha')
  final String date;

  @HiveField(3)
  @JsonKey(name: 'efectiva')
  final String efectiva;

  @HiveField(4)
  @JsonKey(name: 'id_asesor')
  final int advisorId;

  @HiveField(5)
  @JsonKey(name: 'comentario')
  final String? comment;

  @HiveField(6)
  @JsonKey(name: 'geoposicionamiento')
  final String? geolocation;

  @HiveField(7)
  @JsonKey(name: 'adjunto')
  final String? attached;

  const CreateTrackingRequest({
    required this.operation,
    required this.idNumber,
    required this.date,
    required this.efectiva,
    required this.advisorId,
    this.comment,
    this.geolocation,
    this.attached,
  });

  factory CreateTrackingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTrackingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTrackingRequestToJson(this);
}
