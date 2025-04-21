import 'package:edutrack_admin_web/screens/classes_screens/classes_screen.dart';
import 'package:edutrack_admin_web/screens/dashboard_screens/dashboard_screen.dart';
import 'package:edutrack_admin_web/screens/inventory_screens/inventory_screen.dart';
import 'package:edutrack_admin_web/screens/schedule_screens/schedule_screen.dart';
import 'package:edutrack_admin_web/screens/students_screens/students_screen.dart';
import 'package:edutrack_admin_web/screens/subjects_screens/subjects_screen.dart';
import 'package:edutrack_admin_web/screens/teachers_screens/teachers_screen.dart';
import 'package:edutrack_admin_web/util/notifiers.dart';
import 'package:edutrack_admin_web/widgets/navigation%20menu/side_menu_widget.dart';
import 'package:edutrack_admin_web/util/responsive.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  Widget? subScreen;
  int selectedIndex;
  HomeScreen({super.key, required this.selectedIndex, this.subScreen});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      widget.selectedIndex = index;
      widget.subScreen = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      drawer:
          !isDesktop
              ? SizedBox(
                width: 250,
                child: SideMenuWidget(
                  selectedIndex: widget.selectedIndex,
                  onItemTap: handleMenuTap,
                  screenWidth: MediaQuery.of(context).size.width,
                ),
              )
              : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              ValueListenableBuilder(
                valueListenable: NavController.isMenuOpen,
                builder: (context, isOpen, _) {
                  return isOpen
                      ? Expanded(
                        flex: 2,
                        child: SideMenuWidget(
                          selectedIndex: widget.selectedIndex,
                          onItemTap: handleMenuTap,
                          screenWidth: MediaQuery.of(context).size.width,
                        ),
                      )
                      : const SizedBox.shrink();
                },
              ),
            widget.subScreen != null
                ? Expanded(flex: 10, child: widget.subScreen!)
                : Expanded(flex: 10, child: screens[widget.selectedIndex]),
          ],
        ),
      ),
    );
  }
}
