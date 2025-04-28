import 'package:edutrack_admin_web/data/line_chart_data.dart';
import 'package:edutrack_admin_web/data/student_concentration_data.dart';
import 'package:edutrack_admin_web/data/student_performance_data.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';
import 'package:edutrack_admin_web/models/student_concentration_model.dart';
import 'package:edutrack_admin_web/models/student_performance_model.dart';
import 'package:edutrack_admin_web/services/parent_service.dart';
import 'package:edutrack_admin_web/services/student_service.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/line_chart_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';
import 'package:lottie/lottie.dart';

class StudentScreen extends StatefulWidget {
  final String name;
  final String id;
  const StudentScreen({super.key, required this.name, required this.id});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  bool isLoading = true;
  List<List<StatsModel>> groupedStats = [];
  String? photoLink;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    try {
      final doc = await StudentService().getStudentById(widget.id);

      final parentRef = doc!['parentRef'] ?? '';
      // final classRef = doc["classRef"] ?? '';
      // final gradeRef = doc["gradeRef"] ?? '';

      final parentData = await ParentService().getParentByRef(parentRef);
      // final classData = await ClassService().getClassByRef(classRef);
      // final gradeData = await GradeService().getGradeByRef(gradeRef);

      if (doc.isNotEmpty) {
        setState(() {
          photoLink = doc['coverPhoto'].toString();
          groupedStats = [
            [
              StatsModel(
                icon: 'assets/icons/student_icons/Parent.png',
                title: 'Parent Name',
                value: parentData!['parentName'],
                color: Constants.orangeColor,
              ),
              StatsModel(
                icon: 'assets/icons/student_icons/Phone.png',
                title: 'Parent Phone',
                value: parentData['parentPhone'] ?? '-',
                color: Constants.orangeColor,
              ),
            ],
            [
              StatsModel(
                icon: 'assets/icons/student_icons/Mail.png',
                title: 'Student Mail',
                value: doc['studentMail'] ?? '-',
                color: Constants.orangeColor,
              ),
              StatsModel(
                icon: 'assets/icons/student_icons/Password.png',
                title: 'Student Password',
                value: doc['studentPassword'] ?? '-',
                color: Constants.orangeColor,
              ),
            ],
          ];
          isLoading = false;
        });
      } else {
        setState(() {
          print("Found empty data, or couldn't find student");
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(headerTitle: "Student Information"),
              SizedBox(height: Constants.internalSpacing),
              WhiteContainer(
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Stack(
                          clipBehavior:
                              Clip.none, // Important to allow overflow
                          children: [
                            // Teal container with rectangles
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Constants.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 175,
                                    top: 70,
                                    child: Image.asset(
                                      'assets/images/Red Rectangle.png',
                                    ),
                                  ),
                                  Positioned(
                                    right: 40,
                                    top: 32,
                                    child: Image.asset(
                                      'assets/images/Yellow Rectangle.png',
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Avatar with white border - moved up and placed outside
                            Positioned(
                              top: 90,
                              left: 30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                      isLoading
                                          ? Lottie.asset(
                                            Constants.photoLoadingPath,
                                            height: 100,
                                          )
                                          : CircleAvatar(
                                            radius: 58,
                                            backgroundImage: NetworkImage(
                                              photoLink ?? '',
                                            ),
                                          ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.name, style: Constants.mainHeadingStyle),
                          Text("Student", style: Constants.smallerLightTitle),
                          const SizedBox(height: 20),
                          Column(
                            children:
                                groupedStats
                                    .map(
                                      (pair) => Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children:
                                            pair
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
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Personal Info Card
              const SizedBox(height: Constants.internalSpacing),

              // Table & Graphs Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Attendance Table
                  Expanded(
                    flex: 2,
                    child: WhiteContainer(
                      child: FlexibleSmartTable<StudentConcentrationTableModel>(
                        title: null,
                        height: 350,
                        columnNames: [
                          "Date",
                          "Day",
                          "Attendance",
                          "Concentration",
                        ],
                        data: StudentConcentrationData.studentConcentration,
                        getValue: (row, column) {
                          switch (column) {
                            case "Date":
                              return row.date;
                            case "Day":
                              return row.day;
                            case "Attendance":
                              return row.attendance;
                            case "Concentration":
                              return row.concentration;
                            default:
                              return "";
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Concentration Graph
                  Expanded(
                    flex: 2,
                    child: LineChartCard(
                      graphTitle: "Student Concentration",
                      showDateRow: true,
                      data:
                          ConcentrationLineData(), // Replace with real data model
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Constants.internalSpacing),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grades Table
                  Expanded(
                    flex: 2,
                    child: WhiteContainer(
                      child: FlexibleSmartTable<StudentPerformanceTableModel>(
                        title: null,
                        height: 350,
                        columnNames: [
                          "Date",
                          "Quiz",
                          "Final Grade",
                          "Student Grade",
                        ],
                        data: StudentPerformanceData.studentPerformance,
                        getValue: (row, column) {
                          switch (column) {
                            case "Date":
                              return row.date;
                            case "Quiz":
                              return row.quiz;
                            case "Final Grade":
                              return row.finalGrade;
                            case "Student Grade":
                              return row.studentGrade;
                            default:
                              return "";
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Performance Graph
                  Expanded(
                    flex: 2,
                    child: LineChartCard(
                      graphTitle: "Student Performance",
                      showDateRow: true,
                      data:
                          AttendanceLineData(), // Replace with real data model
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
