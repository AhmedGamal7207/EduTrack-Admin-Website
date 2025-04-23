import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';

class DriverData {
  final driverData1 = const [
    StatsModel(
      icon: 'assets/icons/driver_icons/Salary.png',
      title: 'Salary',
      value: "173",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/driver_icons/Phone.png',
      title: 'Driver Phone',
      value: "+1 123456789",
      color: Constants.orangeColor,
    ),
  ];

  final driverData2 = const [
    StatsModel(
      icon: 'assets/icons/driver_icons/School Bus.png',
      title: 'Bus Number',
      value: "1",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/driver_icons/Area.png',
      title: 'Area',
      value: "Smouha",
      color: Constants.orangeColor,
    ),
  ];

  final driverData3 = const [
    StatsModel(
      icon: 'assets/icons/driver_icons/Mail.png',
      title: 'Driver Mail',
      value: "mary789@school-driver.com",
      color: Constants.orangeColor,
    ),
    StatsModel(
      icon: 'assets/icons/driver_icons/Password.png',
      title: 'Driver Password',
      value: "mary789",
      color: Constants.orangeColor,
    ),
  ];
}
