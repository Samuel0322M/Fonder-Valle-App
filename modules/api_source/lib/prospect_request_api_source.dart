import 'package:api_source/api_source.dart';
import 'package:data/prospect_request_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:models/prospect_request.dart';
import 'package:models/prospect_response.dart';

@Injectable(as: ProspectRequestApiSource)
class ProspectRequestApiSourceAdapter implements ProspectRequestApiSource {
  final ApiSource _apiSource;

  ProspectRequestApiSourceAdapter(this._apiSource);

  @override
  Future<List<ProspectResponse>> post(ProspectRequest request, [Map? args]) {
    //final endpoint = '${_apiSource.authority}${"ApiPaths.addNewpage"}';
    final endpoint =
        'https://finansuenos.cuotasoft.com/api_creacion_prospecto_finan/';

    final Options options = Options(headers: {
      'key': 'aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb',
    });

    return _apiSource.postApi(
      options: options,
      endpoint,
      data: request.toJson(),
      (value) => (value["data"] as List)
        .map((item) => ProspectResponse.fromJson(item as Map<String, dynamic>))
        .toList(),
    );
  }
}
