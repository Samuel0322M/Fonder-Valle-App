import 'package:api_source/api_source.dart';
import 'package:data/create_prospect_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_request.dart';
import 'package:models/create_prospect_response.dart';

@Injectable(as: CreateProspectApiSource)
class CreateProspectApiSourceAdapter implements CreateProspectApiSource {
  final ApiSource _apiSource;

  CreateProspectApiSourceAdapter(this._apiSource);

  @override
  Future<CreateProspectResponse> post(CreateProspectRequest request,
      [Map? args]) {
    //final endpoint = '${_apiSource.authority}${"ApiPaths.addNewpage"}';
    final endpoint = 'https://finansuenos.cuotasoft.com/api_creacion_prospecto_finan/';
    //final endpoint = 'https://scriptcase.cuotasoft.com/scriptcase/app/Finansuenos/api_creacion_prospecto_finan/';

    final Options options = Options(headers: {
      'key':'aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb',
    });

    return _apiSource.postApi(
      options: options,
      endpoint,
      data: request.toJson(),
      (value) => CreateProspectResponse.fromJson(value),
    );
  }
}
