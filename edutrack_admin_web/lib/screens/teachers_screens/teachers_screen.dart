import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/data/all_teachers_data.dart';
import 'package:edutrack_admin_web/models/all_teachers_model.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/teachers_screens/add_teacher_screen.dart';
import 'package:edutrack_admin_web/screens/teachers_screens/teacher_screen.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/search_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/graphs_and_tables/flexible_table.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
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
                  Spacer(),
                  CustomButton(
                    text: "Add New Teacher",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => HomeScreen(
                                subScreen: AddTeacherScreen(),
                                selectedIndex: 3,
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
              child: FlexibleSmartTable<AllTeachersTableModel>(
                height: 500,
                title: null,
                columnNames: [
                  "Name",
                  "Salary",
                  "Major Subject",
                  "Second Subject",
                  "Contact Teacher",
                ],
                data: AllTeachersData.allTeachers,
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
                      return row.name;
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
    );
  }
}
