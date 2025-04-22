import 'package:edutrack_admin_web/data/line_chart_data.dart';
import 'package:edutrack_admin_web/data/student_concentration_data.dart';
import 'package:edutrack_admin_web/data/teacher_data.dart';
import 'package:edutrack_admin_web/models/student_concentration_model.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/line_chart_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';

class TeacherScreen extends StatelessWidget {
  final String name;
  final String phone;
  const TeacherScreen({super.key, required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(headerTitle: "Teacher Information"),
            SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none, // Important to allow overflow
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
                                    'assets/images/Red Semi Circle.png',
                                  ),
                                ),
                                Positioned(
                                  right: 40,
                                  top: 32,
                                  child: Image.asset(
                                    'assets/images/Yellow Semi Circle.png',
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
                                    CircleAvatar(
                                      radius: 58,
                                      backgroundImage: AssetImage(
                                        "assets/images/Teacher Person.png",
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
                        Text(name, style: Constants.mainHeadingStyle),
                        Text("Teacher", style: Constants.smallerLightTitle),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    TeacherData().teacherData1
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children:
                                    TeacherData().teacherData2
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
          ],
        ),
      ),
    );
  }
}
