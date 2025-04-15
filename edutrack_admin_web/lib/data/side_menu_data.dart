import 'package:edutrack_admin_web/models/menu_models.dart';

class SideMenuData {
  final menu = <MenuModel>[
    MenuModel(icon: 'assets/icons/Dashboard.png', title: "Dashboard"),
    MenuModel(icon: 'assets/icons/Classroom.png', title: "Classes"),
    MenuModel(icon: 'assets/icons/Graduation Cap.png', title: "Students"),
    MenuModel(icon: 'assets/icons/Teachers.png', title: "Teachers"),
    MenuModel(icon: 'assets/icons/Book.png', title: "Subjects"),
    MenuModel(icon: 'assets/icons/Schedule.png', title: "Schedules"),
    MenuModel(icon: 'assets/icons/Eraser.png', title: "Inventory"),
  ];
}
