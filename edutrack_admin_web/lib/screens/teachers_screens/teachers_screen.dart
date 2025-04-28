import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/models/all_teachers_model.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/teachers_screens/add_teacher_screen.dart';
import 'package:edutrack_admin_web/screens/teachers_screens/teacher_screen.dart';
import 'package:edutrack_admin_web/services/teacher_service.dart';
import 'package:edutrack_admin_web/services/relations/teacher_subject_grade_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/search_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  TextEditingController searchController = TextEditingController();
  List<AllTeachersTableModel> teachers = [];
  List<AllTeachersTableModel> filteredTeachers = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTeachers();
    searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredTeachers =
          teachers.where((teacher) {
            return teacher.name.toLowerCase().contains(query) ||
                teacher.majorSubject.toLowerCase().contains(query) ||
                teacher.teacherPhone.toLowerCase().contains(query);
          }).toList();
    });
  }

  Future<void> fetchTeachers() async {
    try {
      final teacherDocs = await TeacherService().getAllTeachers();
      final relations = await TeacherSubjectGradeService().getAllRelations();

      List<AllTeachersTableModel> result = [];

      for (var data in teacherDocs) {
        final teacherId = data['teacherId'] ?? '';
        final phone = data['teacherPhone'] ?? '';

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

        result.add(
          AllTeachersTableModel(
            name: data['teacherName'] ?? '',
            salary: data['salary'] ?? 0,
            majorSubject: majorName,
            secondSubject: secondName,
            teacherPhone: phone,
            teacherMail: teacherId,
            coverPhoto: data['coverPhoto'] ?? '',
          ),
        );
      }

      setState(() {
        teachers = result;
        filteredTeachers = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load teachers.";
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
              HeaderWidget(headerTitle: "Teachers"),
              const SizedBox(height: Constants.internalSpacing),
              WhiteContainer(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ReusableSearchField(controller: searchController),
                    ),
                    const Spacer(),
                    CustomButton(
                      text: "Add New Teacher",
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HomeScreen(
                                  subScreen: const AddTeacherScreen(),
                                  selectedIndex: 3,
                                ),
                          ),
                        );
                        if (result == true) fetchTeachers();
                      },
                      hasIcon: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Constants.internalSpacing),
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
                        : filteredTeachers.isEmpty
                        ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("No teachers found."),
                        )
                        : FlexibleSmartTable<AllTeachersTableModel>(
                          height: 500,
                          title: null,
                          columnNames: [
                            "Name",
                            "Salary",
                            "Major Subject",
                            "Second Subject",
                            "Contact Teacher",
                          ],
                          data: filteredTeachers,
                          onRowTap: (row) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HomeScreen(
                                      subScreen: TeacherScreen(
                                        name: row.name,
                                        phone: row.teacherPhone,
                                      ),
                                      selectedIndex: 3,
                                    ),
                              ),
                            );
                          },
                          getValue: (row, column) {
                            switch (column) {
                              case "Name":
                                return "${row.name};${row.coverPhoto}";
                              case "Salary":
                                return row.salary.toString();
                              case "Major Subject":
                                return row.majorSubject;
                              case "Second Subject":
                                return row.secondSubject;
                              case "Contact Teacher":
                                return "${row.teacherPhone}|${row.teacherMail}";
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
