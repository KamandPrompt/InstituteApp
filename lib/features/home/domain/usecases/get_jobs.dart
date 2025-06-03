import 'package:vertex/features/home/domain/entities/job_entity.dart';
import 'package:vertex/features/home/domain/repositories/job_portal_repository.dart';

class GetJobs {
  final JobPortalRepository repository;

  GetJobs(this.repository);

  Future<List<JobEntity>> execute() {
    return repository.getJobs();
  }
}
