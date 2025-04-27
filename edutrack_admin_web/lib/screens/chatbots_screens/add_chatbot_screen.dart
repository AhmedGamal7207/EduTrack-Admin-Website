import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/chatbots_screens/chatbots_screen.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/services/chatbot_service.dart';
import 'package:edutrack_admin_web/services/cloudinary_service.dart';
import 'package:edutrack_admin_web/services/relations/chatbot_subject_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/long_text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final nameController = TextEditingController();
  Uint8List? imageBytes;
  String? fileName;
  String? imageUrl;
  String? errorMessage;
  bool isSaving = false;
  String? chatbotId;

  void onPhotoSelected(Uint8List fileBytes, String name) {
    setState(() {
      imageBytes = fileBytes;
      fileName = name;
    });
  }

  void onPhotoRemoved() {
    setState(() {
      imageBytes = null;
      fileName = null;
      imageUrl = null;
    });
  }

  Future<void> saveChatbot() async {
    setState(() {
      isSaving = true;
      errorMessage = null;
    });
    chatbotId = await ChatbotService().generateChatbotId();

    try {
      final chatbotName = nameController.text;

      if (imageBytes != null && fileName != null) {
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          imageBytes!,
          chatbotId!,
          folder: "chatbots",
        );
      } else {
        final defaultBytes = await rootBundle.load('assets/images/Chatbot.png');
        final defaultData = defaultBytes.buffer.asUint8List();
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          defaultData,
          chatbotId!,
          folder: "chatbots",
        );
      }

      await ChatbotService().addChatbot(
        chatbotId: chatbotId!,
        chatbotName: chatbotName,
        coverPhoto: imageUrl ?? '',
      );
      String gradeId = widget.gradeNumber;

      final gradeRef = FirebaseFirestore.instance
          .collection('grades')
          .doc(gradeId);

      final chatbotRef = FirebaseFirestore.instance
          .collection('chatbots')
          .doc(chatbotId);

      String subjectId = "${widget.gradeNumber}${widget.subject.toLowerCase()}";
      final subjectRef = FirebaseFirestore.instance
          .collection('subjects')
          .doc(subjectId);

      await ChatbotSubjectService().addRelation(
        documentId: "${chatbotId}_${subjectId}_$gradeId",
        gradeRef: gradeRef,
        chatbotRef: chatbotRef,
        subjectRef: subjectRef,
        pdfs: List.empty(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chatbot added successfully.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  HomeScreen(subScreen: ChatbotsScreen(), selectedIndex: 8),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

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
                      ReusablePhotoUpload(
                        headline: "Photo",
                        imagePath: "assets/images/Chatbot.png",
                        onImageSelected: onPhotoSelected,
                        onImageRemoved: onPhotoRemoved,
                        initialImageBytes: imageBytes,
                      ),
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
                                text: isSaving ? "Saving..." : "Save Chatbot",
                                onTap: isSaving ? null : saveChatbot,
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
