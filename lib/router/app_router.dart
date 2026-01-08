import 'package:go_router/go_router.dart';
import 'package:govscout/features/job_details_screen.dart';

import '../constants/app_constants.dart';
import '../constants/app_routes.dart';
import '../data/models/job.model.dart';
import '../features/admin/admin_view.dart';
import '../features/candidate/candidate_view.dart';
import '../features/sign_in_screen.dart';
import '../features/splash_screen.dart';
import '../features/admin/add_update_job_screen.dart';

class AppRouter {
  GoRouter get router => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => SplashScreen(),
          ),
          GoRoute(
            path: AppRoutes.signIn,
            builder: (_, __) => SignInScreen(),
          ),
          GoRoute(
            path: AppRoutes.admin,
            builder: (_, __) => AdminView(),
          ),
          GoRoute(
            path: AppRoutes.candidate,
            builder: (_, __) => CandidateView(),
          ),
          GoRoute(
            path: AppRoutes.addUpdateJob,
            builder: (context, state) {
              final job = state.extra as Job?;
              return AddUpdateJobScreen(job: job);
            },
          ),
          GoRoute(
            path: AppRoutes.jobDetails,
            builder: (context, state) {
              final data = state.extra as Map<String, dynamic>;
              final job = data[AppConstants.job];
              // final isAdminView = data[AppConstants.isAdminView];

              return JobDetailsScreen(
                job: job,
                // isAdminView: isAdminView,
              );
            },
          )
        ],
      );
}
