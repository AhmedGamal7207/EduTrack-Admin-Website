import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/all_students_data.dart';
import 'package:edutrack_admin_web/models/all_students_model.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/students_screens/add_student_screen.dart';
import 'package:edutrack_admin_web/screens/students_screens/student_screen.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/search_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => HomeScreen(
                                subScreen: AddStudentScreen(),
                                selectedIndex: 2,
                              ),
                        ),
                      );
                    },
                    hasIcon: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: EdgeInsets.all(0),
              child: FlexibleSmartTable<AllStudentsTableModel>(
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
                data: AllStudentsData.allStudents,
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
    );
  }
}
