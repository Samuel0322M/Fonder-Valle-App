import 'package:api_source/api_source.dart';
import 'package:data/create_prospect_tracking_repository.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:models/create_prospect_response.dart';
import 'package:models/create_tracking_request.dart';

@Injectable(as: CreateProspectTrackingApiSource)
class CreateProspectTrackingApiSourceAdapter implements CreateProspectTrackingApiSource {
  final ApiSource _apiSource;

  CreateProspectTrackingApiSourceAdapter(this._apiSource);

  @override
  Future<CreateProspectResponse> post(CreateTrackingRequest request,
      [Map? args]) {
    //final endpoint = '${_apiSource.authority}${"ApiPaths.addNewpage"}';
    final endpoint = 'https://finansuenos.cuotasoft.com/api_creacion_prospecto_finan/';


    final Options options = Options(headers: {
      'key':'aZx1ByC2wDv3EuFt4GsHr5IqJk6LmNn7OpQq8RsTu9VvWw0XyYzAaBb',
    });

    return _apiSource.postApi(
      options: options,
      endpoint,
      data: request.toJson(),
      (value) => CreateProspectResponse(),
    );
  }
}
