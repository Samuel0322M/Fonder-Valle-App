import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class LoginRequest {
  @HiveField(0)
  @JsonKey(name: 'operacion')
  String? operation = 'logueo';
  @HiveField(1)
  @JsonKey(name: 'login')
  String userName;
  @HiveField(2)
  @JsonKey(name: 'contrasena')
  String password;
  @HiveField(3)
  @JsonKey(name: 'nombre_usuario')
  final String? fullName;
  @HiveField(4)
  @JsonKey(name: 'permisos_apps')
  List<String>? permisosApps;

  LoginRequest(
      {this.operation,
      required this.userName,
      required this.password,
      this.fullName,
      required this.permisosApps});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  LoginRequest copyWith(
      {String? password, String? userName, String? fullName}) {
    return LoginRequest(
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      permisosApps: permisosApps ?? permisosApps,
    );
  }
}
