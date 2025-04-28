import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/class_students_data.dart';
import 'package:edutrack_admin_web/models/class_students_model.dart';
import 'package:edutrack_admin_web/models/stats_model.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/students_screens/student_screen.dart';
import 'package:edutrack_admin_web/services/class_service.dart';
import 'package:edutrack_admin_web/services/subject_service.dart';
import 'package:edutrack_admin_web/services/teacher_service.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/table_with_date.dart';
import 'package:edutrack_admin_web/widgets/inventory/inventory_element_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/cards/stats_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ClassScreen extends StatefulWidget {
  final String gradeNumber;
  final String classNumber;
  const ClassScreen({
    super.key,
    required this.gradeNumber,
    required this.classNumber,
  });

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  bool isLoading = true;
  List<StatsModel> groupedStats = [];
  String? photoLink;

  @override
  void initState() {
    super.initState();
    fetchClassData();
  }

  Future<void> fetchClassData() async {
    try {
      final classes = await ClassService().getAllClasses();
      final doc = classes.firstWhere(
        (classInstance) =>
            classInstance['classId'] ==
            "${widget.gradeNumber}class${widget.classNumber}",
        orElse: () => {},
      );
      Map<String, dynamic>? currentSubjectData =
          doc["currentSubjectRef"] == null
              ? null
              : await SubjectService().getSubjectByRef(
                doc["currentSubjectRef"],
              );
      Map<String, dynamic>? currentTeacherData =
          doc["currentTeacherRef"] == null
              ? null
              : await TeacherService().getTeacherByRef(
                doc["currentTeacherRef"],
              );
      if (doc.isNotEmpty) {
        setState(() {
          photoLink = doc['coverPhoto'].toString();
          groupedStats = [
            StatsModel(
              icon: 'assets/icons/class_icons/Star.png',
              title: 'Class Number',
              value: "${widget.gradeNumber}/${widget.classNumber}",
              color: Constants.orangeColor,
            ),
            StatsModel(
              icon: 'assets/icons/class_icons/Student Desk.png',
              title: 'Attending Students',
              value: "0", //TODO HEREEEEEEEEEEEEEEE
              color: Constants.primaryColor,
            ),
            StatsModel(
              icon: 'assets/icons/class_icons/Book.png',
              title: 'Current Subject',
              value:
                  currentSubjectData != null
                      ? currentSubjectData["subjectName"]
                      : '-',
              color: Constants.yellowColor,
            ),
            StatsModel(
              icon: 'assets/icons/class_icons/Teacher.png',
              title: 'Current Teacher',
              value:
                  currentTeacherData != null
                      ? currentTeacherData["teacherName"]
                      : '-',
              color: Constants.blueColor,
            ),
          ];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
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
          child:
              isLoading
                  ? Lottie.asset(Constants.statsLoadingPath, height: 200)
                  : Column(
                    children: [
                      HeaderWidget(
                        headerTitle:
                            "Class ${widget.gradeNumber}/${widget.classNumber}",
                      ),
                      SizedBox(height: Constants.internalSpacing),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:
                                  groupedStats
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
                      WhiteContainer(
                        child: TableWithDate<ClassStudentsTableModel>(
                          title: "Class Students",
                          columnNames: [
                            "Name",
                            "ID",
                            "Concentration",
                            "Number of Absences",
                            "Day Attendance",
                          ],
                          data: ClassStudentsData.classStudents,
                          showDateFilter: true,
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
                              case "Concentration":
                                return row.concentration;
                              case "Day Attendance":
                                return row.attendance;
                              case "Number of Absences":
                                return row.absences.toString();
                              default:
                                return "";
                            }
                          },
                        ),
                      ),
                      SizedBox(height: Constants.internalSpacing),
                      WhiteContainer(
                        child: Column(
                          children: [
                            Text(
                              "Inventory Management",
                              style: Constants.poppinsFont(
                                Constants.weightBold,
                                20,
                                Constants.primaryColor,
                              ),
                            ),
                            SizedBox(height: Constants.internalSpacing),
                            Row(
                              children: [
                                Spacer(),
                                InventoryElement(
                                  inventoryTitle: "Marker",
                                  inventoryStatus: "Available",
                                ),
                                Spacer(),
                                InventoryElement(
                                  inventoryTitle: "Eraser",
                                  inventoryStatus: "In Use",
                                ),
                                Spacer(),
                                InventoryElement(
                                  inventoryTitle: "First Aid Kit",
                                  inventoryStatus: "Missing",
                                ),
                                Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
