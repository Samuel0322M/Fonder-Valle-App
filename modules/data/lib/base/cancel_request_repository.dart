import 'package:data/base/api_source.dart';
import 'package:domain/base/cancel_request_use_case.dart';

mixin CancelRequestRepositoryAdapter implements CancelRequestRepository {
  ApiSource get apiSource;

  @override
  void cancelRequest() {
    return (apiSource as CancelRequestApiSource).cancelRequest();
  }
}
