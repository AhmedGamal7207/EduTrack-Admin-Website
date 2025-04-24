import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/schedule_screens/class_schedule_page.dart';
import 'package:edutrack_admin_web/widgets/cards/clickable_card_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/cards/info_card_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class ScheduleClassesScreen extends StatelessWidget {
  final String gradeNumber;
  const ScheduleClassesScreen({super.key, required this.gradeNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(headerTitle: "Schedule - Grade $gradeNumber Classes"),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  InfoCard(
                    cardTitle: "Grade $gradeNumber",
                    cardSubtitle: "Classes",
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Wrap(
                      spacing: 50, // Horizontal space between cards
                      runSpacing: 20, // Vertical space between rows
                      alignment: WrapAlignment.center, // Center the whole row
                      children: List.generate(
                        8,
                        (index) => ClickableCard(
                          cardTitle: "Class $gradeNumber / ${index + 1}",
                          buttonText: "Edit Schedule",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HomeScreen(
                                      subScreen: ClassSchedulePage(
                                        gradeNumber: gradeNumber,
                                        classNumber: "${index + 1}",
                                      ),
                                      selectedIndex: 5,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
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
