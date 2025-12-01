import 'package:flutter/material.dart';
import 'package:govscout/widgets/custom_bottom_nav_bar.dart';

import '../../constants/app_language.dart';
import '../settings_screen.dart';
import 'jobs_feed_screen.dart';
import 'saved_jobs_screen.dart';

class CandidateView extends StatefulWidget {
  const CandidateView({super.key});

  @override
  State<CandidateView> createState() => _CandidateViewState();
}

class _CandidateViewState extends State<CandidateView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    JobsFeedScreen(),
    SavedJobsScreen(),
    SettingsScreen(),
  ];

  final icons = [
    Icons.work_outline,
    Icons.bookmark_border,
    Icons.settings,
  ];

  final labels = const [
    AppLanguage.jobs,
    AppLanguage.savedJobs,
    AppLanguage.settings,
  ];

  PreferredSizeWidget? _buildCustomAppBar(int index) {
    switch (index) {
      case 0:
        return AppBar(
          title: Text(AppLanguage.jobs),
          scrolledUnderElevation: 0,
          centerTitle: true,
        );
      case 1:
        return AppBar(
          title: Text(AppLanguage.savedJobs),
          scrolledUnderElevation: 0,
          centerTitle: true,
        );
      default:
        return AppBar(
          title: Text(AppLanguage.settings),
          centerTitle: true,
          scrolledUnderElevation: 0,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
        appBar: _buildCustomAppBar(_currentIndex),
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _currentIndex,
          onTapped: (index) => setState(() => _currentIndex = index),
          icons: icons,
          labels: labels,
        ));
  }
}
