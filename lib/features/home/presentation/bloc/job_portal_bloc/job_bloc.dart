import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vertex/features/home/domain/entities/job_entity.dart';

import '../../../domain/usecases/get_jobs.dart';

part 'job_event.dart';
part 'job_state.dart';

class JobPortalBloc extends Bloc<JobPortalEvent, JobPortalState> {
  final GetJobs getJobs;

  JobPortalBloc({required this.getJobs}) : super(JobPortalInitial()) {
    on<GetJobsEvent>(onGetJobsEvent);
  }

  void onGetJobsEvent(GetJobsEvent event, Emitter<JobPortalState> emit) async {
    emit(JobsLoading());
    try {
      final jobs = await getJobs.execute();
      emit(JobsLoaded(jobs: jobs));
    } catch (e) {
      emit(JobsLoadingError(message: "Error during login : $e"));
    }
  }
}
