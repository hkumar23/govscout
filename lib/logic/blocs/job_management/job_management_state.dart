import '../../../data/models/job.model.dart';
import '../../../utils/app_exception.dart';

abstract class JobManagementState {}

class JobManagementInitialState extends JobManagementState {}

class JobManagementErrorState extends JobManagementState {
  final AppException e;

  JobManagementErrorState(this.e);
}

class JobManagementLoadingState extends JobManagementState {}

class LoadJobsSuccessState extends JobManagementState {
  final List<Job> jobs;

  LoadJobsSuccessState(this.jobs);
}

class AddJobSuccessState extends JobManagementState {}

class UpdateJobSuccessState extends JobManagementState {}

class DeleteJobSuccessState extends JobManagementState {}

class VerifyJobSuccessState extends JobManagementState {}

class ToggleJobActiveStatusSuccessState extends JobManagementState {}

class SearchJobsSuccessState extends JobManagementState {
  final List<Job> jobs;

  SearchJobsSuccessState(this.jobs);
}

class SortJobsSuccessState extends JobManagementState {
  final List<Job> jobs;

  SortJobsSuccessState(this.jobs);
}

class RefreshJobsSuccessState extends JobManagementState {}

class SaveJobSuccessState extends JobManagementState {}

class UnsaveJobSuccessState extends JobManagementState {}

class LoadSavedJobsSuccessState extends JobManagementState {
  final List<Job> jobs;

  LoadSavedJobsSuccessState(this.jobs);
}
