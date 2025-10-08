import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:models/department_response.dart';

class LoadDepartment {
  Future<List<DepartmentResponse>> loadDepartmentsFromAsset() async {
    final jsonString =
        await rootBundle.loadString('assets/department_cities.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    final validEntries = jsonList.where((item) {
      final codMpio = item['COD_MPIO']?.toString();
      final codDepto = item['COD_DEPTO']?.toString();
      final municipio = item['MUNICIPIO'];
      final dpto = item['DPTO'];

      return codMpio != null &&
          int.tryParse(codMpio) != null &&
          codDepto != null &&
          int.tryParse(codDepto) != null &&
          municipio != null &&
          dpto != null;
    });

    return validEntries
        .map((e) => DepartmentResponse.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
