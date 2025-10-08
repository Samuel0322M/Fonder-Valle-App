import 'package:domain/base/save_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:models/prospect_request.dart';
import 'package:models/prospect_response.dart';

mixin ProspectRequestRepository
    on SaveRepository<List<ProspectResponse>, ProspectRequest> {}

mixin ProspectRequestUseCase
    on SaveUseCase<List<ProspectResponse>, ProspectRequest> {}

@Injectable(as: ProspectRequestUseCase)
class ProspectRequestUseCaseAdapter
    with SaveUseCaseAdapter<List<ProspectResponse>, ProspectRequest>
    implements ProspectRequestUseCase {
  @override
  final ProspectRequestRepository repository;

  ProspectRequestUseCaseAdapter(this.repository);
}
