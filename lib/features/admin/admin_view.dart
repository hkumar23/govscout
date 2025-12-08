import 'package:flutter/material.dart';

import '../../constants/app_language.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'admin_dashboard_screen.dart';
import 'admin_settings_screen.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AdminDashboardScreen(),
    AdminSettingsScreen(),
  ];

  final icons = [
    Icons.dashboard_rounded,
    Icons.settings,
  ];

  final labels = const [
    AppLanguage.dashboard,
    AppLanguage.settings,
  ];

  PreferredSizeWidget? _buildCustomAppBar(int index) {
    switch (index) {
      case 0:
        return AppBar(
          title: Text(AppLanguage.dashboard),
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

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Scaffold(
        appBar: _buildCustomAppBar(_currentIndex),
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          icons: icons,
          labels: labels,
          onTapped: (index) => setState(() => _currentIndex = index),
          selectedIndex: _currentIndex,
        ),
      ),
    );
  }
}
