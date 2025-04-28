import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/line_chart_data.dart';
import 'package:edutrack_admin_web/data/att_warnings_data.dart';
import 'package:edutrack_admin_web/models/att_warnings_model.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/students_screens/student_screen.dart';
import 'package:edutrack_admin_web/services/class_service.dart';
import 'package:edutrack_admin_web/services/driver_service.dart';
import 'package:edutrack_admin_web/services/student_service.dart';
import 'package:edutrack_admin_web/services/teacher_service.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/line_chart_widget.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;
  List<StatsModel> groupedStats = [];

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      final numberOfStudents = await StudentService().getStudentsCount();
      final numberOfTeachers = await TeacherService().getTeachersCount();
      final numberOfClasses = await ClassService().getClassesCount();
      final numberOfBusses = await DriverService().getUniqueBussesCount();

      setState(() {
        groupedStats = [
          StatsModel(
            icon: 'assets/icons/dashboard_icons/Student Male.png',
            title: 'Students',
            value: "$numberOfStudents",
            color: Constants.orangeColor,
          ),
          StatsModel(
            icon: 'assets/icons/dashboard_icons/Businessman.png',
            title: 'Teachers',
            value: "$numberOfTeachers",
            color: Constants.primaryColor,
          ),
          StatsModel(
            icon: 'assets/icons/dashboard_icons/Classroom.png',
            title: 'Classes',
            value: "$numberOfClasses",
            color: Constants.yellowColor,
          ),
          StatsModel(
            icon: 'assets/icons/dashboard_icons/Traditional School Bus.png',
            title: 'Busses',
            value: "$numberOfBusses",
            color: Constants.blueColor,
          ),
        ];
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
          child: Lottie.asset(
            'assets/lotties/student_loading.json',
            width: 450,
            height: 450,
          ),
        )
        : Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(Constants.pagePadding),
            child: SingleChildScrollView(
              child:
                  isLoading
                      ? Center(
                        child: Lottie.asset(
                          'assets/lotties/student_loading.json',
                          width: 450,
                          height: 450,
                        ),
                      )
                      : Column(
                        children: [
                          HeaderWidget(headerTitle: "Dashboard"),
                          SizedBox(height: Constants.internalSpacing),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children:
                                      groupedStats
                                          .map(
                                            (stat) => Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                    ),
                                                child: StatCardWidget(
                                                  model: stat,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Constants.internalSpacing),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: WhiteContainer(
                                  child: LineChartCard(
                                    graphTitle: "Students Attendance",
                                    data: AttendanceLineData(),
                                    showDateRow: true,
                                  ),
                                ),
                              ),
                              SizedBox(width: Constants.internalSpacing),
                              Expanded(
                                child: WhiteContainer(
                                  child: LineChartCard(
                                    graphTitle: "Students Concentration",
                                    data: ConcentrationLineData(),
                                    showDateRow: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Constants.internalSpacing),
                          WhiteContainer(
                            child: FlexibleSmartTable<
                              AttendanceWarningsTableModel
                            >(
                              title: "Attendance Warnings",
                              columnNames: [
                                "Name",
                                "ID",
                                "Grade",
                                "Class",
                                "Number of Absences",
                              ],
                              data: AttendanceWarningsData.warnings,
                              onRowTap: (row) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => HomeScreen(
                                          subScreen: StudentScreen(
                                            name: row.name,
                                            id: row.id,
                                          ),
                                          selectedIndex: 2,
                                        ),
                                  ),
                                );
                              },
                              getValue: (row, column) {
                                switch (column) {
                                  case "Name":
                                    return row.name;
                                  case "ID":
                                    return row.id;
                                  case "Grade":
                                    return row.grade;
                                  case "Class":
                                    return row.studentClass;
                                  case "Number of Absences":
                                    return row.absences.toString();
                                  default:
                                    return "";
                                }
                              },
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        );
  }
}
