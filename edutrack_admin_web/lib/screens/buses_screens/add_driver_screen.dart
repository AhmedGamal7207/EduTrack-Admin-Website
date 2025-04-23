import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.pagePadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidget(headerTitle: "Add New Bus Driver"),
            const SizedBox(height: Constants.internalSpacing),
            WhiteContainer(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Bus Driver Details", style: Constants.subHeadingStyle),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Teacher Photo
                      ReusablePhotoUpload(
                        headline: "Photo",
                        imagePath:
                            "assets/images/Person.png", // Replace with actual path
                        onChoose: () {},
                        onRemove: () {},
                      ),
                      const SizedBox(width: 40),

                      // Form Fields
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
                                    headline: "Salary",
                                    hintText: "173",
                                    inputType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Bus Number",
                                    hintText: "1",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Driver Email",
                                    hintText: "Tony3000@school.com",
                                    inputType: TextInputType.emailAddress,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Driver Password",
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
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: "Save Bus Driver",
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
