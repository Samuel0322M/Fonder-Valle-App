import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';


part 'create_prospect_request.g.dart';

@HiveType(typeId: 3)
@JsonSerializable(explicitToJson: true)
class CreateProspectRequest {
  @HiveField(0)
  @JsonKey(name: 'operacion')
  final String? operation;
  @HiveField(1)
  @JsonKey(name: 'email')
  final String? email;
  @HiveField(2)
  @JsonKey(name: 'cedula')
  final String? idNumber;
  @HiveField(3)
  @JsonKey(name: 'celular')
  final String? phone;
  @HiveField(4)
  @JsonKey(name: 'primer_nombre')
  final String? firstName;
  @HiveField(5)
  @JsonKey(name: 'segundo_nombre')
  final String? middleName;
  @HiveField(6)
  @JsonKey(name: 'primer_apellido')
  final String? lastName;
  @HiveField(7)
  @JsonKey(name: 'segundo_apellido')
  final String? secondLastName;
  @HiveField(8)
  @JsonKey(name: 'id_asesor')
  final String advisorId;
  @HiveField(9)
  @JsonKey(name: 'id_empresa')
  final int? companyId;
  @HiveField(10)
  @JsonKey(name: 'valor_a_financiar')
  final String? amountToFinance;
  @HiveField(11)
  @JsonKey(name: 'comentario')
  final String? comment;
  @HiveField(12)
  @JsonKey(name: 'geoposicionamiento')
  final String? geolocation;
  @HiveField(13)
  @JsonKey(name: 'id_departamento')
  final String? departmentId;
  @HiveField(14)
  @JsonKey(name: 'id_ciudad')
  final String? cityId;
  @HiveField(15)
    @JsonKey(name: 'id_corregimiento')
  final String? districtId;
  @HiveField(16)
  @JsonKey(name: 'fecha_expedicion')
  final String? expeditionDate;
  @HiveField(17)
  @JsonKey(name: 'valor_ingresos_minimos')
  final String? amountToIncome;
  @HiveField(18)
  @JsonKey(name: 'ocupacion')
  final String? occupation;
  @HiveField(19)
  @JsonKey(name: 'tipo_identificacion')
  final String? typeIdentification;
  @HiveField(20)
  @JsonKey(name: 'id_solicitud')
  final String? idSolicitud;
  @HiveField(21)
  @JsonKey(name: 'via_whatsapp')
  final String? viaWhatsapp;


  CreateProspectRequest({
    this.operation,
    this.email,
    this.idNumber,
    this.phone,
    this.firstName,
    this.middleName,
    this.lastName,
    this.secondLastName,
    required this.advisorId,
    this.companyId,
    this.amountToFinance,
    this.comment,
    this.geolocation,
    this.departmentId,
    this.cityId,
    this.districtId,
    this.expeditionDate,
    this.amountToIncome,
    this.occupation,
    this.typeIdentification,
    this.idSolicitud,
    this.viaWhatsapp
  });

  factory CreateProspectRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProspectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProspectRequestToJson(this);
}

/*
  @JsonKey(name: 'foto_ant_cedula')
  final String? frontIdPhoto;
  @JsonKey(name: 'foto_pos_cedula')
  final String? backIdPhoto;
  @JsonKey(name: 'foto_rostro')
  final String? facePhoto;
  @HiveField(2)
  @JsonKey(name: 'barrio')
  final String? neighborhood;
  @HiveField(5)
  @JsonKey(name: 'direccion')
  final String? address;
  @HiveField(6)
  @JsonKey(name: 'id_ciudad')
  final String? cityId;
  @HiveField(7)
  @JsonKey(name: 'id_corregimiento')
  final String? districtId;
  @HiveField(8)
  @JsonKey(name: 'celular_dos')
  final String? secondaryPhone;
  @HiveField(22)
  @JsonKey(name: 'referencias', defaultValue: [])
  final List<Referencia> referencias;
  @HiveField(11)
  @JsonKey(name: 'id_departamento')
  final String? departmentId;
  
  */