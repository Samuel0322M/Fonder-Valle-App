mixin DatabaseObject {
  String? get dbId;
  void setDbId(String id);
  Map<String, dynamic> toJson();
}
