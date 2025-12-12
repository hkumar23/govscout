import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_routes.dart';
import 'add_update_job_screen.dart';
import 'widgets/action_dashboard_tile.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: const EdgeInsets.all(16),
        alignment: Alignment.topCenter,
        child: Wrap(
          spacing: 25,
          runSpacing: 25,
          // alignment: WrapAlignment.center,
          // crossAxisAlignment: WrapCrossAlignment.center,
          // runAlignment: WrapAlignment.center,
          // direction: Axis.horizontal,
          children: [
            ActionDashboardTile(
              icon: Icons.person_rounded,
              title: "Manage Users",
              onTap: () {},
            ),
            ActionDashboardTile(
              icon: Icons.work_rounded,
              title: "Manage Jobs",
              onTap: () {},
            ),
            ActionDashboardTile(
              icon: Icons.add_rounded,
              title: "Add New Job",
              onTap: () {
                GoRouter.of(context).push(AppRoutes.addUpdateJob);
              },
            )
          ],
        ),
      ),
    );
  }
}
