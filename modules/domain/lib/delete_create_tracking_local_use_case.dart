import 'package:domain/repository/create_tracking_prospect_local_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteCreateTrackingLocalUseCase {
  final CreateTrackingProspectLocalRepository repository;

  DeleteCreateTrackingLocalUseCase(this.repository);

  Future<void> call(String prospectNumberID) async {
    await repository.deleteAll(prospectNumberID);
  }
}
