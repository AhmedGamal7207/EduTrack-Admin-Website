import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';

class StatsData {
  final statsData = const [
    StatsModel(
      icon: 'assets/icons/dashboard_icons/Student Male.png',
      title: 'Students',
      value: "173",
      color: Constants.primaryColor,
    ),
    StatsModel(
      icon: 'assets/icons/dashboard_icons/Businessman.png',
      title: 'Teachers',
      value: "26",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/menu_icons/Classroom.png',
      title: 'Classes',
      value: "10",
      color: Constants.yellowColor,
    ),
    StatsModel(
      icon: 'assets/icons/dashboard_icons/Traditional School Bus.png',
      title: 'Busses',
      value: "7",
      color: Constants.blueColor,
    ),
  ];
}
