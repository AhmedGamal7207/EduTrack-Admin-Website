import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/long_text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class AddChatbotScreen extends StatefulWidget {
  final String gradeNumber;
  final String subject;
  const AddChatbotScreen({
    super.key,
    required this.gradeNumber,
    required this.subject,
  });

  @override
  State<AddChatbotScreen> createState() => _AddChatbotScreenState();
}

class _AddChatbotScreenState extends State<AddChatbotScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(
              headerTitle:
                  "Add Chatbot - Grade ${widget.gradeNumber} - ${widget.subject}",
            ),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Chatbot Details", style: Constants.subHeadingStyle),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Cover Photo
                      /*ReusablePhotoUpload(
                        headline: "Cover Photo",
                        imagePath: "assets/images/Chatbot.png",
                        onChoose: () {},
                        onRemove: () {},
                      ),*/
                      const SizedBox(width: 40),
                      // Subject Form Fields
                      Expanded(
                        child: Column(
                          children: [
                            ReusableTextField(
                              headline: "Chatbot Name",
                              hintText: "English",
                            ),
                            const SizedBox(height: 20),
                            ReusableLongTextField(
                              headline: "Resources(PDFs)",
                              hintText:
                                  "Lesson 1: Present Simple.pdf\nLesson 2: Past Simple.pdf\nLesson 3: Past Continuous.pdf\nLesson 4: Future Simple.pdf",
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomButton(
                                text: "Upload Files",
                                onTap: () {},
                                hasIcon: false,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: "Save Chatbot",
                                onTap: () {},
                                hasIcon: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
