import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/subjects_screens/add_subject_screen.dart';
import 'package:edutrack_admin_web/widgets/cards/clickable_card_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/confirmation_dialog_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/cards/info_card_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class GradeSubjectsScreen extends StatelessWidget {
  final String gradeNumber;
  const GradeSubjectsScreen({super.key, required this.gradeNumber});

  @override
  Widget build(BuildContext context) {
    List<String> subjects = [
      "Arabic",
      "English",
      "Art",
      "Math",
      "Science",
      "Physics",
    ];
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(headerTitle: "Grade $gradeNumber Subjects"),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  InfoCard(
                    cardTitle: "Grade $gradeNumber",
                    cardSubtitle: "Subjects",
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Wrap(
                      spacing: 50, // Horizontal space between cards
                      runSpacing: 20, // Vertical space between rows
                      alignment: WrapAlignment.center, // Center the whole row
                      children: List.generate(
                        6,
                        (index) => ClickableCard(
                          cardTitle: subjects[index],
                          buttonText: "Delete Subject",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationDialog(
                                  title: "Delete Subject?",
                                  message:
                                      "Are you sure you want to delete ${subjects[index]}?",
                                  onConfirm: () {
                                    // Delete logic here
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: "Add New Subject",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => HomeScreen(
                                subScreen: AddSubjectScreen(
                                  gradeNumber: gradeNumber,
                                ),
                                selectedIndex: 4,
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
