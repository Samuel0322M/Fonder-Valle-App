import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prospect_response.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class ProspectResponse {
  // -------- CAMPOS DE LA API --------
  @HiveField(0)
  @JsonKey(name: 'identificacion', fromJson: _toString)
  final String numberID;

  @HiveField(1)
  @JsonKey(name: 'nombre_prospecto')
  final String? nameProspect;

  @HiveField(2)
  @JsonKey(name: 'celular', fromJson: _toString)
  final String? cellphone;

  @HiveField(3)
  @JsonKey(name: 'correo')
  final String? email;

  @HiveField(4)
  @JsonKey(name: 'valor_solicitado', fromJson: _toString)
  final String? valueRequested;

  @HiveField(5)
  @JsonKey(name: 'direccion_residencia')
  final String? residenceAddress;

  @HiveField(6)
  @JsonKey(name: 'barrio_residencia')
  final String? neighborhoodResidency;

  @HiveField(7)
  @JsonKey(name: 'Selfie')
  final String? selfie;

  @HiveField(8)
  @JsonKey(name: 'foto_ant_cedula')
  final String? photoBackCedula;

  @HiveField(9)
  @JsonKey(name: 'foto_pos_cedula')
  final String? photoFrontCedula;

  @HiveField(10)
  @JsonKey(name: 'id_solicitud')
  final String? idSolicitud;

  @HiveField(11)
  @JsonKey(name: 'nombre')
  final String? name;

  @HiveField(12)
  @JsonKey(name: 'apellido')
  final String? lastName;

  @HiveField(13)
  @JsonKey(name: 'segundo_apellido')
  final String? secondLastName;

  @HiveField(14)
  @JsonKey(name: 'tipo_identificacion', fromJson: _toString)
  final String? tipoIdentificacion;

  @HiveField(15)
  @JsonKey(name: 'fecha_expedicion')
  final String? expeditionDate;

  @HiveField(16)
  @JsonKey(name: 'ingreso_mensual', fromJson: _toString)
  final String? incomeValue;

  @HiveField(17)
  @JsonKey(name: 'ocupacion')
  final String? occupation;

  // -------- CAMPOS LOCALES (no vienen en API) --------

  @HiveField(18)
  final String? secondName;

  @HiveField(19)
  final String? description;

  @HiveField(20)
  final String? comment;

  @HiveField(21)
  final String? nameAdvise;

  @HiveField(22)
  final String? geolocation;

  //------ CAMPOS NUEVOS QUE VIENEN DE LA API -----------

  @HiveField(23)
  @JsonKey(name : "id_departamento", fromJson: _toString)
  final String? departmentId;

  @HiveField(24)
  @JsonKey(name : "id_ciudad", fromJson: _toString)
  final String? cityId;

  @HiveField(25)
  @JsonKey(name: "id_corregimiento", fromJson: _toString)
  final String? districtId;

  @HiveField(26)
  @JsonKey(name: "via_whatsapp")
  final String? viaWhatsapp;


  const ProspectResponse({
    required this.numberID,
    this.nameProspect,
    this.cellphone,
    this.email,
    this.valueRequested,
    this.residenceAddress,
    this.neighborhoodResidency,
    this.selfie,
    this.photoBackCedula,
    this.photoFrontCedula,
    this.description,
    this.comment,
    this.nameAdvise,
    this.geolocation, 
    this.idSolicitud,
    this.tipoIdentificacion,
    this.name,
    this.lastName,
    this.secondName,
    this.secondLastName, 
    this.expeditionDate,
    this.incomeValue,
    this.occupation,
    this.departmentId,
    this.cityId,
    this.districtId,
    this.viaWhatsapp
  });

  static String _toString(dynamic value) => value?.toString() ?? '';

  factory ProspectResponse.fromJson(Map<String, dynamic> json) =>
      _$ProspectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProspectResponseToJson(this);
}