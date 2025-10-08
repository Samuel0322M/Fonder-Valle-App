import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'permission.dart'; // importá el permiso

part 'authentication_data.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class AuthenticationData {
  @HiveField(0)
  @JsonKey(name: 'nombre_usuario')
  String userName;

  @HiveField(1)
  String? numberID;

  @HiveField(2)
  final List<Permission> permisos; // <-- nuevo campo

  AuthenticationData({
    required this.userName,
    this.numberID,
    required this.permisos,
  });

  factory AuthenticationData.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationDataToJson(this);

  factory AuthenticationData.empty() => AuthenticationData(
        userName: '',
        numberID: '',
        permisos: [],
      );
}
