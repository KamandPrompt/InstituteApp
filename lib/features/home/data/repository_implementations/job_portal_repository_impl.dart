import 'package:vertex/features/home/data/data_sources/job_portal_data_sources.dart';
import '../../domain/entities/job_entity.dart';
import '../../domain/repositories/job_portal_repository.dart';

class JobPortalRepositoryImpl implements JobPortalRepository {
  final JobPortalDB jobPortalDatabase;
  JobPortalRepositoryImpl(this.jobPortalDatabase);

  @override
  Future<List<JobEntity>> getJobs() async {
    List<JobEntity> allJobs = [];
    final jobs = await jobPortalDatabase.getJobs();
    if (jobs.isNotEmpty) {
      for (int i = 0; i < jobs.length; i++) {
        allJobs.add(JobEntity(
          id: jobs[i].id,
          name: jobs[i].name,
          company: jobs[i].company,
          image: jobs[i].image,
          type: jobs[i].type,
          location: jobs[i].location,
          stipend: jobs[i].stipend,
          duration: jobs[i].duration,
          applyBy: jobs[i].applyBy,
          details: jobs[i].details,
          eligibilityCriteria: EligibilityCriteria(
            education: jobs[i].eligibilityCriteria.education,
            cgpa: jobs[i].eligibilityCriteria.cgpa,
            skills: jobs[i].eligibilityCriteria.skills,
          ),
          contact: Contact(
            name: jobs[i].contact.name,
            phoneNo: jobs[i].contact.phoneNo,
          ),
          website: jobs[i].website,
        ));
      }
      return allJobs;
    } else {
      return allJobs;
    }
  }
}
