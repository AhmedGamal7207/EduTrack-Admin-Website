import 'package:edutrack_admin_web/widgets/dashboardWidgets.dart';
import 'package:edutrack_admin_web/widgets/sideMenuWidget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(flex: 2, child: SizedBox(child: SideMenuWidget())),
            Expanded(flex: 10, child: DashboardWidget()),
          ],
        ),
      ),
    );
  }
}
