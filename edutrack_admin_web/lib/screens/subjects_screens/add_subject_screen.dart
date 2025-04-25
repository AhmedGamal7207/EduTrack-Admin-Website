import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/services/cloudinary_service.dart';
import 'package:edutrack_admin_web/services/subject_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/long_text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddSubjectScreen extends StatefulWidget {
  final String gradeNumber;
  const AddSubjectScreen({super.key, required this.gradeNumber});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final subjectNameController = TextEditingController();
  final numberOfLessonsController = TextEditingController();
  final lessonsController = TextEditingController();
  String? errorMessage;
  bool isSaving = false;

  Uint8List? imageBytes;
  String? fileName;
  String? imageUrl;

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

  Future<void> saveSubject() async {
    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      final subjectName = subjectNameController.text.trim();
      final lessons = lessonsController.text.trim();
      final numberOfLessons =
          int.tryParse(numberOfLessonsController.text.trim()) ?? 0;
      final gradeRef = FirebaseFirestore.instance
          .collection('grades')
          .doc(widget.gradeNumber);

      // Generate subjectId
      final subjectId = "${widget.gradeNumber}$subjectName"
          .toLowerCase()
          .replaceAll(" ", "_");
      if (numberOfLessons.toInt() != lessons.split("\n").length) {
        setState(() {
          errorMessage =
              "Number of Lessons should be equal to the actual lessons names you provide.";
        });
        return;
      }
      if (imageBytes != null && fileName != null) {
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          imageBytes!,
          subjectId,
          folder: "subjects",
        );
      } else {
        final defaultBytes = await rootBundle.load('assets/images/Subject.png');
        final defaultData = defaultBytes.buffer.asUint8List();
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          defaultData,
          subjectId,
          folder: "subjects",
        );
      }

      await SubjectService().addSubject(
        subjectId: subjectId,
        subjectName: subjectName,
        numberOfLessons: numberOfLessons,
        lessons: lessons,
        coverPhoto: imageUrl ?? '',
        gradeRef: gradeRef,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Subject added successfully.")),
      );
      Navigator.pop(context);
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
              headerTitle: "Add New Subject - Grade ${widget.gradeNumber}",
            ),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Subject Details", style: Constants.subHeadingStyle),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusablePhotoUpload(
                        headline: "Cover Photo",
                        imagePath: "assets/images/Subject.png",
                        onImageSelected: onPhotoSelected,
                        onImageRemoved: onPhotoRemoved,
                        initialImageBytes: imageBytes,
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Column(
                          children: [
                            ReusableTextField(
                              headline: "Subject Name",
                              hintText: "English",
                              controller: subjectNameController,
                            ),
                            const SizedBox(height: 20),
                            ReusableTextField(
                              headline: "Number of Lessons",
                              hintText: "4",
                              inputType: TextInputType.number,
                              controller: numberOfLessonsController,
                            ),
                            const SizedBox(height: 20),
                            ReusableLongTextField(
                              headline: "Lessons",
                              hintText: "Lesson 1: ...",
                              controller: lessonsController,
                            ),
                            const SizedBox(height: 30),
                            if (errorMessage != null)
                              Text(
                                errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: isSaving ? "Saving..." : "Save Subject",
                                onTap: isSaving ? null : saveSubject,
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
