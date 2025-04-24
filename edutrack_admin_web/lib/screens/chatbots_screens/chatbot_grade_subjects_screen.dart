import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/chatbots_screens/add_chatbot_screen.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/widgets/cards/clickable_card_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/cards/info_card_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class ChatbotGradeSubjectsScreen extends StatelessWidget {
  final String gradeNumber;
  const ChatbotGradeSubjectsScreen({super.key, required this.gradeNumber});
  final List<String> subjects = const [
    "Arabic",
    "English",
    "Art",
    "Math",
    "Science",
    "Physics",
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(headerTitle: "AI Chatbots - Grade $gradeNumber"),
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
                          buttonText: "Add AI Chatbot",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HomeScreen(
                                      subScreen: AddChatbotScreen(
                                        gradeNumber: gradeNumber,
                                        subject: subjects[index],
                                      ),
                                      selectedIndex: 8,
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
