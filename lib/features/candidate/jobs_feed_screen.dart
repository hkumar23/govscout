import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../data/models/job.model.dart';
import '../../data/repositories/auth_repo.dart';
import '../../logic/blocs/job_management/job_management_bloc.dart';
import '../../logic/blocs/job_management/job_management_event.dart';
import '../../logic/blocs/job_management/job_management_state.dart';
import '../../utils/custom_snackbar.dart';
import '../widgets/job_item.dart';

class JobsFeedScreen extends StatefulWidget {
  final bool isAdminView;
  const JobsFeedScreen({
    super.key,
    required this.isAdminView,
  });

  @override
  State<JobsFeedScreen> createState() => _JobsFeedScreenState();
}

class _JobsFeedScreenState extends State<JobsFeedScreen> {
  final _scrollController = ScrollController();
  // No local list needed, we will get it directly from the BLoC state
  // for a cleaner, single source of truth.
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    // Initial data fetch
    context.read<JobManagementBloc>().add(JobsFeedStartEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // A common check to prevent multiple load calls
    final state = context.read<JobManagementBloc>().state;
    if (state is JobsFeedLoadingMoreState) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<JobManagementBloc>().add(JobsFeedLoadMoreEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
            if (state is LoadJobsSuccessState) {
              jobs = state.jobs;
            }
            if (state is JobsFeedLoadMoreSuccessState) {
              context.read<JobManagementBloc>().add(
                    JobsFeedNewJobsArrivedEvent(
                      newJobs: state.moreJobs,
                      oldJobs: jobs,
                    ),
                  );
            }
            if (state is JobManagementErrorState) {
              // The builder will handle showing the error inline,
              // but a snackbar is still good for transient errors.
              CustomSnackbar.error(
                context: context,
                text: state.e.message,
              );
            }
          },
          builder: (context, state) {
            // Initial loading state
            if (state is JobManagementLoadingState) {
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
              onRefresh: () async =>
                  context.read<JobManagementBloc>().add(JobsFeedRefreshEvent()),
              // backgroundColor: AppColors.surfaceVariant,
              color: appColors.primary,
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ), // Padding for FAB
                    itemCount: jobs.length +
                        (state is JobsFeedLoadingMoreState ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show a loading indicator at the bottom
                      if (index >= jobs.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: appColors.primary,
                            ),
                          ),
                        );
                      }

                      final job = jobs[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: index == jobs.length - 1 ? 64 : 0),
                        child: JobItem(
                          job: job,
                          currentUserId: authRepo.currentUser!.uid,
                        ),
                      );
                    },
                  ),
                  if (widget.isAdminView && !kIsWeb)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, right: 16),
                        child: FloatingActionButton.extended(
                          label: Text(
                            'Create Post',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 26,
                          ),
                          onPressed: kIsWeb
                              ? null
                              : () {
                                  GoRouter.of(context).push(
                                    AppRoutes.addUpdateJob,
                                  );
                                },
                          backgroundColor:
                              appColors.primary, // Use your app's primary color
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Simple time formatter (replace with the 'timeago' package for more features)
String timeago(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return DateFormat("dd MMM yyyy").format(dt);
  // return '${(diff.inDays / 7).floor()}w ago';
}
