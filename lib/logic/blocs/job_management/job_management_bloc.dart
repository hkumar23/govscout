import 'package:bloc/bloc.dart';

import '../../../data/repositories/jobs_repo.dart';
import '../../../utils/app_exception.dart';
import 'job_management_event.dart';
import 'job_management_state.dart';
import '../../../data/models/job.model.dart';

class JobManagementBloc extends Bloc<JobManagementEvent, JobManagementState> {
  final JobsRepository _jobsRepo = JobsRepository();

  final List<Job> gloablJobs = [];

  JobManagementBloc() : super(JobManagementInitialState()) {
    on<LoadJobsEvent>(_onLoadJobs);
    on<AddJobEvent>(_onAddJob);
    on<UpdateJobEvent>(_onUpdateJob);
    on<DeleteJobEvent>(_onDeleteJob);
    on<VerifyJobEvent>(_onVerifyJob);
    on<ToggleJobActiveStatusEvent>(_onToggleJobActiveStatus);
    on<SearchJobsEvent>(_onSearchJobs);
    on<SortJobsEvent>(_onSortJobs);
    on<RefreshJobsEvent>(_onRefreshJobs);
  }

  void _onLoadJobs(
    LoadJobsEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    // Implementation for loading jobs
  }

  void _onAddJob(
    AddJobEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    try {
      emit(JobManagementLoadingState());
      _jobsRepo.addJob(event.job);
      gloablJobs.add(event.job);
      emit(AddJobSuccessState());
    } catch (e) {
      emit(
        JobManagementErrorState(
          AppException('Failed to add job'),
        ),
      );
    }
  }

  void _onUpdateJob(
      UpdateJobEvent event, Emitter<JobManagementState> emit) async {
    // Implementation for updating a job
  }

  void _onDeleteJob(
      DeleteJobEvent event, Emitter<JobManagementState> emit) async {
    // Implementation for deleting a job
  }

  void _onVerifyJob(
      VerifyJobEvent event, Emitter<JobManagementState> emit) async {
    // Implementation for verifying a job
  }

  void _onToggleJobActiveStatus(ToggleJobActiveStatusEvent event,
      Emitter<JobManagementState> emit) async {
    // Implementation for toggling job active status
  }

  void _onSearchJobs(
      SearchJobsEvent event, Emitter<JobManagementState> emit) async {
    // Implementation for searching jobs
  }

  void _onSortJobs(
      SortJobsEvent event, Emitter<JobManagementState> emit) async {
    // Implementation for sorting jobs
  }

  void _onRefreshJobs(
      RefreshJobsEvent event, Emitter<JobManagementState> emit) async {
    // Implementation for refreshing jobs
  }
}
