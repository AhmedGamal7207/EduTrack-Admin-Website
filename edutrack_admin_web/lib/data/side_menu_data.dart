import 'package:edutrack_admin_web/models/menu_model.dart';

class SideMenuData {
  final menu = <MenuModel>[
    MenuModel(
      icon: 'assets/icons/menu_icons/Dashboard.png',
      title: "Dashboard",
    ),
    MenuModel(icon: 'assets/icons/menu_icons/Classroom.png', title: "Classes"),
    MenuModel(
      icon: 'assets/icons/menu_icons/Graduation Cap.png',
      title: "Students",
    ),
    MenuModel(icon: 'assets/icons/menu_icons/Teachers.png', title: "Teachers"),
    MenuModel(icon: 'assets/icons/menu_icons/Book.png', title: "Subjects"),
    MenuModel(icon: 'assets/icons/menu_icons/Schedule.png', title: "Schedules"),
    MenuModel(icon: 'assets/icons/menu_icons/Eraser.png', title: "Inventory"),
    MenuModel(icon: 'assets/icons/menu_icons/School Bus.png', title: "Buses"),
    MenuModel(
      icon: 'assets/icons/menu_icons/Artificial Intelligence.png',
      title: "AI Chatbots",
    ),
  ];
}
