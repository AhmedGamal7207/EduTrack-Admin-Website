import 'package:edutrack_admin_web/screens/schedule_screens/grade_schedule_page.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/widgets/cards/clickable_card_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(headerTitle: "Schedule"),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Wrap(
                  spacing: 50, // Horizontal space between cards
                  runSpacing: 20, // Vertical space between rows
                  alignment: WrapAlignment.center, // Center the whole row
                  children: List.generate(
                    12,
                    (index) => ClickableCard(
                      cardTitle: "Grade ${index + 1}",
                      buttonText: "Edit Schedule",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HomeScreen(
                                  subScreen: GradeSchedulePage(
                                    gradeNumber: "${index + 1}",
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
            ),
          ],
        ),
      ),
    );
  }
}
