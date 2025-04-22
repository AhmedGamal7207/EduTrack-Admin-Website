import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/line_chart_data.dart';
import 'package:edutrack_admin_web/data/stats_data.dart';
import 'package:edutrack_admin_web/data/att_warnings_data.dart';
import 'package:edutrack_admin_web/models/att_warnings_model.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/students_screens/student_screen.dart';
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

  @override
  void initState() {
    super.initState();
    simulateLoading();
  }

  void simulateLoading() async {
    setState(() {
      isLoading = true;
    });

    // Simulate a 2-second loading period
    await Future.delayed(const Duration(seconds: 4));

    setState(() {
      isLoading = false;
    });
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
        : Padding(
          padding: const EdgeInsets.all(Constants.pagePadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeaderWidget(headerTitle: "Dashboard"),
                SizedBox(height: Constants.internalSpacing),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:
                            StatsData().statsData
                                .map(
                                  (stat) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: StatCardWidget(model: stat),
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
                  child: FlexibleSmartTable<AttendanceWarningsTableModel>(
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
        );
  }
}
