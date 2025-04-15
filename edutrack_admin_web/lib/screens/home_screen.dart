import 'package:edutrack_admin_web/screens/main_screens/classes_screen.dart';
import 'package:edutrack_admin_web/screens/main_screens/dashboard_screen.dart';
import 'package:edutrack_admin_web/screens/main_screens/inventory_screen.dart';
import 'package:edutrack_admin_web/screens/main_screens/schedule_screen.dart';
import 'package:edutrack_admin_web/screens/main_screens/students_screen.dart';
import 'package:edutrack_admin_web/screens/main_screens/subjects.dart';
import 'package:edutrack_admin_web/screens/main_screens/teachers_screen.dart';
import 'package:edutrack_admin_web/widgets/side_menu_widget.dart';
import 'package:edutrack_admin_web/util/responsive.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> screens = [
    DashboardScreen(),
    ClassesScreen(),
    StudentsScreen(),
    TeachersScreen(),
    SubjectsScreen(),
    ScheduleScreen(),
    InventoryScreen(),
  ];

  void handleMenuTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: SideMenuWidget(
                  selectedIndex: selectedIndex,
                  onItemTap: handleMenuTap,
                  screenWidth: MediaQuery.of(context).size.width,
                ),
              ),
            Expanded(flex: 10, child: screens[selectedIndex]),
          ],
        ),
      ),
    );
  }
}
