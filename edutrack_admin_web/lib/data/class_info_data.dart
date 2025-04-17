import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';

class ClassInfoData {
  final classInfoData = const [
    StatsModel(
      icon: 'assets/icons/class_icons/Star.png',
      title: 'Class Number',
      value: "1/1",
      color: Constants.primaryColor,
    ),
    StatsModel(
      icon: 'assets/icons/class_icons/Student Desk.png',
      title: 'Attendning Students',
      value: "19",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/class_icons/Book.png',
      title: 'Current Subject',
      value: "Math",
      color: Constants.yellowColor,
    ),
    StatsModel(
      icon: 'assets/icons/class_icons/Teacher.png',
      title: 'Current Teacher',
      value: "Mr. Amr",
      color: Constants.blueColor,
    ),
  ];
}
