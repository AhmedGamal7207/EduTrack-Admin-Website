import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';

class TeacherData {
  final teacherData1 = const [
    StatsModel(
      icon: 'assets/icons/teacher_icons/Subjects.png',
      title: 'Subjects',
      value: "Math, Science",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/teacher_icons/Phone.png',
      title: 'Teacher Phone',
      value: "+1 123456789",
      color: Constants.orangeColor,
    ),
  ];

  final teacherData2 = const [
    StatsModel(
      icon: 'assets/icons/teacher_icons/Location.png',
      title: 'Address',
      value: "Louran",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/teacher_icons/Mail.png',
      title: 'Teacher Mail',
      value: "mary789@school-teacher.com",
      color: Constants.orangeColor,
    ),
  ];
}
