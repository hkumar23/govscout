import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:govscout/firebase_options.dart';

import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter().router,
      title: 'Gov Scout',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4169E1),
          // seedColor: const Color(0xFF1A237E),
          // seedColor: const Color(0xFF00BCD4),
          brightness: Brightness.dark,
          // brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
    );
  }
}
