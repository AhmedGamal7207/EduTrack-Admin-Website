import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/services/class_service.dart';
import 'package:edutrack_admin_web/services/cloudinary_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddClassScreen extends StatefulWidget {
  final String gradeNumber;
  const AddClassScreen({super.key, required this.gradeNumber});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final classNumberController = TextEditingController();
  final classNameController = TextEditingController();
  final classLetterController = TextEditingController();
  final roomNumberController = TextEditingController();

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

  Future<void> saveClass() async {
    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      final classNumber = classNumberController.text.trim();
      final className = classNameController.text;
      final classLetter = classLetterController.text.trim();
      final roomNumber = roomNumberController.text.trim();

      final gradeRef = FirebaseFirestore.instance
          .collection('grades')
          .doc(widget.gradeNumber);
      // Generate subjectId
      final classId = "${widget.gradeNumber}class$classNumber";

      if (imageBytes != null && fileName != null) {
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          imageBytes!,
          classId,
          folder: "classes",
        );
      } else {
        final defaultBytes = await rootBundle.load(
          'assets/images/Classroom.png',
        );
        final defaultData = defaultBytes.buffer.asUint8List();
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          defaultData,
          classId,
          folder: "classes",
        );
      }

      await ClassService().addClass(
        classId: classId,
        classNumber: classNumber,
        classLetter: classLetter,
        className: className,
        roomNumber: roomNumber,
        currentSubjectRef: null,
        currentTeacherRef: null,
        coverPhoto: imageUrl ?? '',
        gradeRef: gradeRef,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Class added successfully.")),
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
              headerTitle: "Add New Class - Grade ${widget.gradeNumber}",
            ),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Class Details", style: Constants.subHeadingStyle),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover Photo Upload
                      ReusablePhotoUpload(
                        headline: "Cover Photo",
                        imagePath:
                            "assets/images/Classroom.png", // Update this path
                        onImageSelected: onPhotoSelected,
                        onImageRemoved: onPhotoRemoved,
                        initialImageBytes: imageBytes,
                      ),
                      const SizedBox(width: 40),

                      // Form Fields
                      Expanded(
                        child: Column(
                          children: [
                            ReusableTextField(
                              headline: "Class Number",
                              hintText: "2",
                              inputType: TextInputType.number,
                              controller: classNumberController,
                            ),
                            const SizedBox(height: 20),
                            ReusableTextField(
                              headline: "Class Name",
                              hintText: "London",
                              isRequired: false,
                              controller: classNameController,
                            ),
                            const SizedBox(height: 20),
                            ReusableTextField(
                              headline: "Class Letter (Room Letter)",
                              hintText: "A",
                              isRequired: false,
                              controller: classLetterController,
                            ),
                            const SizedBox(height: 20),
                            ReusableTextField(
                              headline: "Room Number",
                              hintText: "12",
                              isRequired: false,
                              inputType: TextInputType.number,
                              controller: roomNumberController,
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: isSaving ? "Saving..." : "Save Class",
                                onTap: isSaving ? null : saveClass,
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

/*String? selectedGrade;
List<String> gradeOptions = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4'];

ReusableComboBox<String>(
              headline: 'Select Grade',
              items: gradeOptions,
              selectedItem: selectedGrade,
              itemLabel: (grade) => grade,
              onChanged: (value) {
                setState(() {
                  selectedGrade = value;
                });
              },
            )*/
