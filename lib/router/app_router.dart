import 'package:go_router/go_router.dart';

import '../features/splash_screen.dart';

class AppRouter {
  GoRouter get router => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => SplashScreen(),
          ),
        ],
      );
}
