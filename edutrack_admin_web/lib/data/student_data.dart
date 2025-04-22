import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';

class StudentData {
  final studentData1 = const [
    StatsModel(
      icon: 'assets/icons/student_icons/Parent.png',
      title: 'Parent Name',
      value: "Jane Watson",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/student_icons/Phone.png',
      title: 'Parent Phone',
      value: "+1 123456789",
      color: Constants.orangeColor,
    ),
  ];

  final studentData2 = const [
    StatsModel(
      icon: 'assets/icons/student_icons/Location.png',
      title: 'Address',
      value: "Louran",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/student_icons/Mail.png',
      title: 'Student Mail',
      value: "mary789@school-student.com",
      color: Constants.orangeColor,
    ),
  ];
}
