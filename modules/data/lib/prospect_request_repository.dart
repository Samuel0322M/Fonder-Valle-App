import 'package:data/base/api_source.dart';
import 'package:data/base/save_repository.dart';
import 'package:domain/prospect_request_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/prospect_request.dart';
import 'package:models/prospect_response.dart';

mixin ProspectRequestApiSource
    on PostApiSource<List<ProspectResponse>, ProspectRequest> {}

@Injectable(as: ProspectRequestRepository)
class ProspectRequestRepositoryAdapter
    with SaveRepositoryAdapter<List<ProspectResponse>, ProspectRequest>
    implements ProspectRequestRepository {
  @override
  final ProspectRequestApiSource apiSource;

  ProspectRequestRepositoryAdapter(this.apiSource);
}
