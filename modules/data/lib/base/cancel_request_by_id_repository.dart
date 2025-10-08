import 'package:data/base/api_source.dart';
import 'package:domain/base/cancel_request_by_id_use_case.dart';

mixin CancelRequestByIdRepositoryAdapter
    implements CancelRequestByIdRepository {
  ApiSource get apiSource;

  @override
  void cancelRequest(String id) {
    return (apiSource as CancelRequestByIdApiSource).cancelRequest(id);
  }
}
