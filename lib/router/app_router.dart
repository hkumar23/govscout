import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
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
            builder: (_, __) => AddUpdateJobScreen(),
          )
        ],
      );
}
