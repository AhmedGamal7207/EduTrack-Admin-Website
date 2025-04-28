import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/line_chart_data.dart';
import 'package:edutrack_admin_web/data/student_concentration_data.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';
import 'package:edutrack_admin_web/models/student_concentration_model.dart';
import 'package:edutrack_admin_web/services/relations/teacher_subject_grade_service.dart';
import 'package:edutrack_admin_web/services/teacher_service.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/line_chart_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TeacherScreen extends StatefulWidget {
  final String name;
  final String phone;
  const TeacherScreen({super.key, required this.name, required this.phone});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  bool isLoading = true;
  List<List<StatsModel>> groupedStats = [];
  String? photoLink;

  @override
  void initState() {
    super.initState();
    fetchTeacherData();
  }

  Future<void> fetchTeacherData() async {
    try {
      final teachers = await TeacherService().getAllTeachers();
      final doc = teachers.firstWhere(
        (teacher) => teacher['teacherPhone'] == widget.phone,
        orElse: () => {},
      );
      final teacherId = doc["teacherId"];
      final relations = await TeacherSubjectGradeService().getAllRelations();

      final majorRel = relations.firstWhere(
        (rel) =>
            rel['teacherRef'].path.contains(teacherId) &&
            rel['isMajor'] == true,
        orElse: () => {},
      );

      final secondRel = relations.firstWhere(
        (rel) =>
            rel['teacherRef'].path.contains(teacherId) &&
            rel['isMajor'] == false,
        orElse: () => {},
      );

      String majorName = '-';
      String secondName = '-';

      if (majorRel.isNotEmpty) {
        final subjectDoc =
            await (majorRel['subjectRef'] as DocumentReference).get();
        majorName = subjectDoc['subjectName'] ?? '-';
      }

      if (secondRel.isNotEmpty) {
        final subjectDoc =
            await (secondRel['subjectRef'] as DocumentReference).get();
        secondName = subjectDoc['subjectName'] ?? '-';
      }

      if (doc.isNotEmpty) {
        setState(() {
          photoLink = doc['coverPhoto'].toString();
          groupedStats = [
            [
              StatsModel(
                icon: 'assets/icons/teacher_icons/Subjects.png',
                title: 'Subjects',
                value: "$majorName, $secondName",
                color: Constants.orangeColor,
              ),
              StatsModel(
                icon: 'assets/icons/teacher_icons/Phone.png',
                title: 'Teacher Phone',
                value: doc['teacherPhone'] ?? '-',
                color: Constants.orangeColor,
              ),
            ],
            [
              StatsModel(
                icon: 'assets/icons/teacher_icons/Mail.png',
                title: 'Teacher Mail',
                value: doc['teacherMail'] ?? '-',
                color: Constants.orangeColor,
              ),
              StatsModel(
                icon: 'assets/icons/teacher_icons/Password.png',
                title: 'Teacher Password',
                value: doc['teacherPassword'] ?? '-',
                color: Constants.orangeColor,
              ),
            ],
          ];
          isLoading = false;
        });
      } else {
        setState(() {
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
              HeaderWidget(headerTitle: "Teacher Information"),
              const SizedBox(height: Constants.internalSpacing),
              WhiteContainer(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
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
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.name, style: Constants.mainHeadingStyle),
                          Text("Teacher", style: Constants.smallerLightTitle),
                          const SizedBox(height: 20),
                          isLoading
                              ? Lottie.asset(
                                Constants.statsLoadingPath,
                                height: 200,
                              )
                              : Column(
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
      ),
    );
  }
}
