import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'permission.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Permission {
  @HiveField(0)
  @JsonKey(name: 'app_name')
  final String appName;

  @HiveField(1)
  @JsonKey(name: 'priv_access')
  final String privAccess;

  // si necesitás otros flags en el futuro podés agregarlos aquí

  Permission({
    required this.appName,
    required this.privAccess,
  });

  bool get canAccess => privAccess.toUpperCase() == 'Y';

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);
}
