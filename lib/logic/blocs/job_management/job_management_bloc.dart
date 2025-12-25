import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/firebase_collections.dart';
import '../../../data/repositories/jobs_repo.dart';
import '../../../utils/app_exception.dart';
import '../../../utils/app_methods.dart';
import 'job_management_event.dart';
import 'job_management_state.dart';

class JobManagementBloc extends Bloc<JobManagementEvent, JobManagementState> {
  final JobsRepository _jobsRepo = JobsRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription? _subNew;
  DocumentSnapshot? _lastDoc; // keep Firestore doc for pagination

  // final List<Job> gloablJobs = [];

  JobManagementBloc() : super(JobManagementInitialState()) {
    on<JobsFeedStartEvent>(_onJobsFeedStart);
    on<JobsFeedLoadMoreEvent>(_onJobsFeedLoadMore);
    on<JobsFeedRefreshEvent>(_onJobsFeedRefresh);
    on<JobsFeedNewJobsArrivedEvent>(_onJobsFeedNewJobsArrived);
    on<CreateJobEvent>(_onCreateJob);
    on<DeleteJobEvent>(_onDeleteJob);
    on<SaveJobEvent>(_onSaveJob);
    on<UnsaveJobEvent>(_onUnsaveJob);
    on<LoadSavedJobsEvent>(_onLoadSavedJobs);

    on<UpdateJobEvent>(_onUpdateJob);
    on<VerifyJobEvent>(_onVerifyJob);
    on<ToggleJobActiveStatusEvent>(_onToggleJobActiveStatus);
    on<SearchJobsEvent>(_onSearchJobs);
    on<SortJobsEvent>(_onSortJobs);
    on<RefreshJobsEvent>(_onRefreshJobs);
  }

  void _onLoadSavedJobs(
    LoadSavedJobsEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    emit(LoadSavedJobsLoadingState());
    try {
      final jobs = await _jobsRepo.getSavedJobs(event.userId);
      emit(LoadSavedJobsSuccessState(jobs));
    } catch (e) {
      emit(
        JobManagementErrorState(
          AppException(e.toString()),
        ),
      );
    }
  }

  void _onSaveJob(
    SaveJobEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    // emit(JobManagementLoadingState());
    try {
      await _jobsRepo.saveJob(
        jobId: event.jobId,
        userId: event.userId,
      );
      emit(SaveJobSuccessState());
      add(LoadSavedJobsEvent(event.userId));
    } catch (e) {
      emit(
        JobManagementErrorState(
          AppException(e.toString()),
        ),
      );
    }
  }

  void _onUnsaveJob(
    UnsaveJobEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    // emit(JobManagementLoadingState());
    try {
      await _jobsRepo.unsaveJob(event.jobId, event.userId);
      emit(UnsaveJobSuccessState());
      add(LoadSavedJobsEvent(event.userId));
    } catch (e) {
      emit(
        JobManagementErrorState(
          AppException(e.toString()),
        ),
      );
    }
  }

  void _onJobsFeedNewJobsArrived(
    JobsFeedNewJobsArrivedEvent event,
    Emitter<JobManagementState> emit,
  ) {
    try {
      final existing = {for (final j in event.oldJobs) j.id!: j};
      for (final j in event.newJobs) {
        existing[j.id!] = j;
      }
      final list = existing.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(
        LoadJobsSuccessState(
          jobs: list,
          endReached: false,
        ),
      );
    } catch (e) {
      emit(JobManagementErrorState(
        AppException(e.toString()),
      ));
    }
  }

  Future<void> _onJobsFeedRefresh(
    JobsFeedRefreshEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    add(JobsFeedStartEvent());
  }

  Future<void> _onJobsFeedLoadMore(
    JobsFeedLoadMoreEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    if (state is JobsFeedLoadingMoreState || _lastDoc == null) return;
    emit(JobsFeedLoadingMoreState());
    try {
      final next = await _jobsRepo.getNextPage(
        lastDoc: _lastDoc!,
        pageSize: 10,
      );
      if (next.isEmpty) {
        emit(JobsFeedLoadMoreSuccessState(
          moreJobs: [],
          endReached: true,
        ));
        return;
      }
      _lastDoc = await _docOf(lastId: next.last.id);
      emit(
        JobsFeedLoadMoreSuccessState(
          // posts: [...state.posts, ...next],
          moreJobs: next,
          endReached: next.length < 10,
        ),
      );
    } catch (err) {
      emit(
        JobManagementErrorState(
          AppException(err.toString()),
        ),
      );
    }
  }

  void _onJobsFeedStart(
    JobsFeedStartEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    emit(JobManagementLoadingState());
    try {
      final firstPage = await _jobsRepo.getFirstPage(pageSize: 10);
      _lastDoc =
          await _docOf(lastId: firstPage.isEmpty ? null : firstPage.last.id);
      // Listen to new posts since newest in list (or now if empty)
      final since =
          firstPage.isEmpty ? DateTime.now() : firstPage.first.createdAt;
      _subNew?.cancel();
      _subNew = _jobsRepo.listenNewJobs(since).listen((newOnTop) {
        if (newOnTop.isNotEmpty) {
          add(
            JobsFeedNewJobsArrivedEvent(
              newJobs: newOnTop,
              oldJobs: firstPage,
            ),
          );
        }
      });
      // print("Subscribed to new posts");
      emit(LoadJobsSuccessState(
        jobs: firstPage,
        endReached: firstPage.length < 10,
      ));
    } catch (err) {
      emit(
        JobManagementErrorState(
          AppException(err.toString()),
        ),
      );
    }
  }

  void _onCreateJob(
    CreateJobEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    emit(JobManagementLoadingState());
    try {
      _jobsRepo.addJob(event.job);
      AppMethods.sendNewJobPostNotification(
        event.job.title,
        event.job.description,
        _auth.currentUser!.uid,
      );
      emit(CreateJobSuccessState());
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
    DeleteJobEvent event,
    Emitter<JobManagementState> emit,
  ) async {
    emit(JobManagementLoadingState());
    try {
      _jobsRepo.deleteJob(event.jobId);
      emit(DeleteJobSuccessState());
      add(JobsFeedStartEvent());
    } catch (e) {
      emit(
        JobManagementErrorState(
          AppException(e.toString()),
        ),
      );
    }
  }

  void _onVerifyJob(
    VerifyJobEvent event,
    Emitter<JobManagementState> emit,
  ) async {}

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

  Future<DocumentSnapshot?> _docOf({String? lastId}) async {
    if (lastId == null) return null;
    return FirebaseFirestore.instance
        .collection(FirebaseCollections.jobs)
        .doc(lastId)
        .get();
  }
}
