import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class AddClassScreen extends StatefulWidget {
  final String gradeNumber;
  const AddClassScreen({super.key, required this.gradeNumber});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
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
                        onChoose: () {},
                        onRemove: () {},
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
                            ),
                            const SizedBox(height: 20),
                            ReusableTextField(
                              headline: "Class Name",
                              hintText: "London",
                              isRequired: false,
                            ),
                            const SizedBox(height: 20),
                            ReusableTextField(
                              headline: "Class Letter (Room Letter)",
                              hintText: "A",
                              isRequired: false,
                            ),
                            const SizedBox(height: 20),
                            ReusableTextField(
                              headline: "Room Number",
                              hintText: "12",
                              isRequired: false,
                              inputType: TextInputType.number,
                            ),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                text: "Save Class",
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
