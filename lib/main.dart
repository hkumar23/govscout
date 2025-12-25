import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/bloc/theme_bloc.dart';
import 'core/theme/bloc/theme_event.dart';
import 'core/theme/bloc/theme_state.dart';
import 'core/theme/theme_repository.dart';
import 'firebase_options.dart';
import 'logic/blocs/auth/auth_bloc.dart';
import 'logic/blocs/job_management/job_management_bloc.dart';
import 'router/app_router.dart';
import 'core/theme/app_theme_mode.dart';
import '../../../utils/utils_android_stub.dart'
    if (dart.library.io) '../../../utils/utils_android.dart';
import 'utils/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Enable Firebase Messaging Auto Init
  try {
    if (!kIsWeb) enableFirebaseMessagingAutoInit();
  } catch (e) {
    debugPrint("Failed to enable Firebase Messaging auto-init: $e");
  }

  // ✅ Register background message handler
  if (!kIsWeb) registerBackgroundMessageHandler();

  // ✅ Initialize your notification service
  if (!kIsWeb) {
    final notificationService = NotificationsService();
    await notificationService.init();
  }

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc()),
      BlocProvider(
        create: (context) => ThemeBloc(
          ThemeRepository(),
        ),
      ),
      BlocProvider(create: (context) => JobManagementBloc()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initApp(context),
        builder: (context, snapshot) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp.router(
                routerConfig: AppRouter().router,
                title: 'Gov Scout',
                darkTheme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color(0xFF4169E1),
                      // seedColor: const Color(0xFF1A237E),
                      // seedColor: const Color(0xFF00BCD4),
                      // brightness: Brightness.dark,
                      // brightness: Brightness.light,
                      brightness: Brightness.dark),
                  useMaterial3: true,
                ),
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: const Color(0xFF4169E1),
                    // seedColor: const Color(0xFF1A237E),
                    // seedColor: const Color(0xFF00BCD4),
                    // brightness: Brightness.dark,
                    // brightness: Brightness.light,
                    brightness: Brightness.light,
                  ),
                  useMaterial3: true,
                ),
                themeMode: state.themeMode.toFlutterMode,
              );
            },
          );
        });
  }

  Future<void> _initApp(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Load Theme BEFORE app is fully built
      BlocProvider.of<ThemeBloc>(context).add(LoadUserTheme(user.uid));
    }
  }
}
