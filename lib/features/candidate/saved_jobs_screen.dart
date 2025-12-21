import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../data/models/job.model.dart';
import '../../data/repositories/auth_repo.dart';
import '../../logic/blocs/job_management/job_management_bloc.dart';
import '../../logic/blocs/job_management/job_management_event.dart';
import '../../logic/blocs/job_management/job_management_state.dart';
import '../../utils/custom_snackbar.dart';
import '../widgets/job_item.dart';

class SavedJobsScreen extends StatefulWidget {
  final bool isAdminView;
  const SavedJobsScreen({
    super.key,
    required this.isAdminView,
  });

  @override
  State<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    // Initial data fetch
    context
        .read<JobManagementBloc>()
        .add(LoadSavedJobsEvent(AuthRepository().currentUser!.uid));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appColors = AppColors(context);
    final authRepo = AuthRepository();

    return Padding(
      padding: EdgeInsets.only(
        bottom: mediaQuery.padding.bottom,
      ),
      child: Scaffold(
        backgroundColor:
            appColors.background, // A dark background is great for gym apps
        body: BlocConsumer<JobManagementBloc, JobManagementState>(
          listener: (context, state) {
            if (state is LoadSavedJobsSuccessState) {
              jobs = state.jobs;
            }
            if (state is JobManagementErrorState) {
              CustomSnackbar.error(
                context: context,
                text: state.e.message,
              );
            }
          },
          builder: (context, state) {
            // Initial loading state
            if (state is LoadSavedJobsLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: appColors.primary,
                ),
              );
            }

            // Empty state after loading
            if (jobs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.explore_off_outlined,
                        color: Colors.white38, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      "No updates yet. Check back later!",
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "The jobs feed is empty right now.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white60,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Error state
            if (state is JobManagementErrorState && jobs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load feed',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.e.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white60),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Main content list
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<JobManagementBloc>()
                  .add(LoadSavedJobsEvent(authRepo.currentUser!.uid)),
              // backgroundColor: AppColors.surfaceVariant,
              color: appColors.primary,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ), // Padding for FAB
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return JobItem(
                    job: job,
                    currentUserId: authRepo.currentUser!.uid,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Simple time formatter (replace with the 'timeago' package for more features)
// String timeago(DateTime dt) {
//   final diff = DateTime.now().difference(dt);
//   if (diff.inSeconds < 60) return 'just now';
//   if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
//   if (diff.inHours < 24) return '${diff.inHours}h ago';
//   if (diff.inDays < 7) return '${diff.inDays}d ago';
//   return DateFormat("dd MMM yyyy").format(dt);
//   // return '${(diff.inDays / 7).floor()}w ago';
// }
