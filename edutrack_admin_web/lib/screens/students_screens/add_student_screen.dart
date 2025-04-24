import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/combo_box_upload.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(headerTitle: "Add New Student"),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Student Details", style: Constants.subHeadingStyle),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Student Photo
                      /*ReusablePhotoUpload(
                        headline: "Photo",
                        imagePath:
                            "assets/images/Person.png", // Replace with actual path
                        onChoose: () {},
                        onRemove: () {},
                      ),*/
                      const SizedBox(width: 40),

                      // Form Fields in Two-Per-Row Layout
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "First Name",
                                    hintText: "Tony",
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Last Name",
                                    hintText: "Stark",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Date of Birth",
                                    hintText: "17/3/2007",
                                    inputType: TextInputType.datetime,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Adress",
                                    hintText: "7 Del Perro Heights",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Grade",
                                    hintText: "12",
                                    inputType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableComboBox<String>(
                                    headline: "Class",
                                    items: const [
                                      "12/1 - Paris",
                                      "12/2 - Cairo",
                                    ],
                                    selectedItem: "12/1 - Paris",
                                    itemLabel: (item) => item,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "National ID",
                                    hintText: "30312190300111",
                                    inputType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Student ID",
                                    hintText: "123456789",
                                    inputType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Student Email",
                                    hintText: "Tony3000@school.com",
                                    inputType: TextInputType.emailAddress,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Student Password",
                                    hintText: "ynzmj26",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Parent Details", style: Constants.subHeadingStyle),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ReusableTextField(
                              headline: "First Name",
                              hintText: "Howard",
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ReusableTextField(
                              headline: "Last Name",
                              hintText: "Stark",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ReusableTextField(
                              headline: "Email",
                              hintText: "Howard@shield.com",
                              inputType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: ReusableTextField(
                              headline: "Phone Number",
                              hintText: "04071970",
                              inputType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: "Save Student",
                      onTap: () {},
                      hasIcon: false,
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
