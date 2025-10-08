import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_prospect_model.g.dart';

@HiveType(typeId: 4)
@JsonSerializable()
class TrackingProspectModel {
  @HiveField(0)
  @JsonKey(name: 'telefono')
  final String? phone;

  @HiveField(1)
  @JsonKey(name: 'correo')
  final String? email;

  @HiveField(2)
  @JsonKey(name: 'descripcion')
  final String? description;

  @HiveField(3)
  @JsonKey(name: 'fecha_llamada')
  final String? callDate;

  @HiveField(4)
  @JsonKey(name: 'hora_seguimiento')
  final String? trackingTime;

  @HiveField(5)
  @JsonKey(name: 'volver_a_llamar')
  final String? backToCall;

  @HiveField(6)
  @JsonKey(name: 'fecha_devolver')
  final String? dateBackToCall;

  @HiveField(7)
  @JsonKey(name: 'hora_volver_a_llamar')
  final String? timeBackToCall;

  @HiveField(8)
  @JsonKey(name: 'Comentario')
  final String? comment;

  @HiveField(9)
  @JsonKey(name: 'titulo')
  final String? title;

  @HiveField(10)
  @JsonKey(name: 'Asesor')
  final String? advisor;

  @HiveField(11)
  @JsonKey(name: 'geoposicionamiento')
  final String? geolocation;

  const TrackingProspectModel({
    this.phone,
    this.email,
    this.description,
    this.callDate,
    this.trackingTime,
    this.backToCall,
    this.dateBackToCall,
    this.timeBackToCall,
    this.comment,
    this.title,
    this.advisor,
    this.geolocation,
  });

  factory TrackingProspectModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingProspectModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingProspectModelToJson(this);
}
