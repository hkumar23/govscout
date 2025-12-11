import '../../../data/models/job.model.dart';

abstract class JobManagementEvent {}

class LoadJobsEvent extends JobManagementEvent {}

class AddJobEvent extends JobManagementEvent {
  final Job job;

  AddJobEvent(this.job);
}

class UpdateJobEvent extends JobManagementEvent {
  final String jobId;
  final Map<String, dynamic> updatedData;

  UpdateJobEvent(this.jobId, this.updatedData);
}

class DeleteJobEvent extends JobManagementEvent {
  final String jobId;

  DeleteJobEvent(this.jobId);
}

class VerifyJobEvent extends JobManagementEvent {
  final String jobId;
  final bool isVerified;

  VerifyJobEvent(this.jobId, this.isVerified);
}

class ToggleJobActiveStatusEvent extends JobManagementEvent {
  final String jobId;
  final bool isActive;

  ToggleJobActiveStatusEvent(this.jobId, this.isActive);
}

class SearchJobsEvent extends JobManagementEvent {
  final String query;

  SearchJobsEvent(this.query);
}

class FilterJobsEvent extends JobManagementEvent {
  final Map<String, dynamic> filters;

  FilterJobsEvent(this.filters);
}

class SortJobsEvent extends JobManagementEvent {
  final String sortBy;
  final bool ascending;

  SortJobsEvent(this.sortBy, this.ascending);
}

class RefreshJobsEvent extends JobManagementEvent {}

class LoadMoreJobsEvent extends JobManagementEvent {}

class ClearJobFiltersEvent extends JobManagementEvent {}

class ClearJobSearchEvent extends JobManagementEvent {}

class ApplyToJobEvent extends JobManagementEvent {
  final String jobId;
  final String userId;

  ApplyToJobEvent(this.jobId, this.userId);
}

class SaveJobEvent extends JobManagementEvent {
  final String jobId;
  final String userId;

  SaveJobEvent(this.jobId, this.userId);
}

class UnsaveJobEvent extends JobManagementEvent {
  final String jobId;
  final String userId;

  UnsaveJobEvent(this.jobId, this.userId);
}

class IncrementJobViewsEvent extends JobManagementEvent {
  final String jobId;

  IncrementJobViewsEvent(this.jobId);
}

class LoadJobApplicationsEvent extends JobManagementEvent {
  final String jobId;

  LoadJobApplicationsEvent(this.jobId);
}

class UpdateJobApplicationStatusEvent extends JobManagementEvent {
  final String jobId;
  final String userId;
  final String status;

  UpdateJobApplicationStatusEvent(this.jobId, this.userId, this.status);
}

class DeleteJobApplicationEvent extends JobManagementEvent {
  final String jobId;
  final String userId;

  DeleteJobApplicationEvent(this.jobId, this.userId);
}

class LoadSavedJobsEvent extends JobManagementEvent {
  final String userId;

  LoadSavedJobsEvent(this.userId);
}

class LoadAppliedJobsEvent extends JobManagementEvent {
  final String userId;

  LoadAppliedJobsEvent(this.userId);
}
