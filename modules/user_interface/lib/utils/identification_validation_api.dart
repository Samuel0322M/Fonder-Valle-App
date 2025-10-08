import 'dart:convert';
import 'package:http/http.dart' as http;

class IdentificationValidationApi {
  static const String _baseUrl = "https://finansuenos.cuotasoft.com/blank_api_consulta_prospecto_creado/";
  //static const String _baseUrl = "https://scriptcase.cuotasoft.com/scriptcase/app/Finansuenos/blank_api_consulta_prospecto_creado/";
  static const Map<String, String> _headers = {
    'Content-Type': "application/json",
    'key': 'aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb',
  };
  static Future<http.Response> bodyApi({required Map<String, dynamic> body}) async {
    final response =
        await http.post(Uri.parse(_baseUrl), headers: _headers, body: jsonEncode(body));

    print("hola este es el response ${response.body}");

    return response;
  }
}
