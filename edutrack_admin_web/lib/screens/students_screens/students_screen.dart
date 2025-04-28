import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/all_students_model.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/students_screens/add_student_screen.dart';
import 'package:edutrack_admin_web/screens/students_screens/student_screen.dart';
import 'package:edutrack_admin_web/services/class_service.dart';
import 'package:edutrack_admin_web/services/grade_service.dart';
import 'package:edutrack_admin_web/services/parent_service.dart';
import 'package:edutrack_admin_web/services/student_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/search_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  TextEditingController searchController = TextEditingController();
  List<AllStudentsTableModel> students = [];
  List<AllStudentsTableModel> filteredStudents = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchStudents();
    searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredStudents =
          students.where((student) {
            return student.name.toLowerCase().contains(query) ||
                student.id.toLowerCase().contains(query) ||
                student.parentPhone.toLowerCase().contains(query) ||
                student.parentMail.toLowerCase().contains(query) ||
                student.studentClass.toLowerCase().contains(query);
          }).toList();
    });
  }

  Future<void> fetchStudents() async {
    try {
      final studentDocs = await StudentService().getAllStudents();

      List<AllStudentsTableModel> result = [];

      for (var data in studentDocs) {
        final parentRef = data['parentRef'] ?? '';
        final classRef = data["classRef"] ?? '';
        final gradeRef = data["gradeRef"] ?? '';

        final parentData = await ParentService().getParentByRef(parentRef);
        final classData = await ClassService().getClassByRef(classRef);
        final gradeData = await GradeService().getGradeByRef(gradeRef);
        result.add(
          AllStudentsTableModel(
            name: data['studentName'] ?? '',
            id: data['studentId'] ?? "",
            absences: data["numberOfAbsences"] ?? "",
            busNumber: data["busNumber"] ?? "",
            studentClass:
                "${gradeData!["gradeNumber"]} / ${classData!["classNumber"]}",
            parentMail: parentData!["parentEmail"] ?? "",
            parentPhone: parentData["parentPhone"] ?? "",
            coverPhoto: data["coverPhoto"] ?? "",
          ),
        );
      }

      setState(() {
        students = result;
        filteredStudents = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load students.";
        isLoading = false;
      });
      rethrow;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeaderWidget(headerTitle: "Students"),
              const SizedBox(height: Constants.internalSpacing),
              WhiteContainer(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ReusableSearchField(controller: searchController),
                    ),
                    Spacer(),
                    CustomButton(
                      text: "Add New Student",
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HomeScreen(
                                  subScreen: const AddStudentScreen(),
                                  selectedIndex: 2,
                                ),
                          ),
                        );
                        if (result == true) fetchStudents();
                      },
                      hasIcon: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: Constants.internalSpacing),
              WhiteContainer(
                padding: EdgeInsets.all(0),
                child:
                    isLoading
                        ? Center(
                          child: Lottie.asset(
                            Constants.tableLoadingPath,
                            height: 200,
                          ),
                        )
                        : errorMessage != null
                        ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                        : filteredStudents.isEmpty
                        ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("No students found."),
                        )
                        : FlexibleSmartTable<AllStudentsTableModel>(
                          height: 500,
                          title: null,
                          columnNames: [
                            "Name",
                            "ID",
                            "Bus Number",
                            "Class",
                            "Absences",
                            "Contact Parent",
                          ],
                          data: filteredStudents,
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
                                return "${row.name};${row.coverPhoto}";
                              case "ID":
                                return row.id;
                              case "Bus Number":
                                return row.busNumber;
                              case "Class":
                                return row.studentClass;
                              case "Absences":
                                return row.absences.toString();
                              case "Contact Parent":
                                return "${row.parentPhone}|${row.parentMail}";
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
