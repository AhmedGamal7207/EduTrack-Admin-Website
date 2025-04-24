import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/buses_screens/buses_screen.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/services/driver_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddDriverScreen extends StatefulWidget {
  const AddDriverScreen({super.key});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final driverEmailController = TextEditingController();
  final salaryController = TextEditingController();
  final busNumberController = TextEditingController();
  final phoneController = TextEditingController();
  final areaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isSaving = false;
  String? errorMessage;

  Future<void> saveDriver() async {
    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      final String fullName =
          "${firstNameController.text.trim()} ${lastNameController.text.trim()}";
      final DateTime dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
      final Timestamp dobTimestamp = Timestamp.fromDate(dob);

      await DriverService().addDriver(
        driverId: "driver_${DateTime.now().millisecondsSinceEpoch}",
        driverName: fullName,
        salary: int.tryParse(salaryController.text.trim()) ?? 0,
        busNumber: busNumberController.text.trim(),
        area: areaController.text,
        dateOfBirth: dobTimestamp,
        driverEmail: driverEmailController.text.trim(),
        driverPassword: passwordController.text.trim(),
        driverPhone: phoneController.text.trim(),
        driverMail: emailController.text.trim(),
        coverPhoto: '',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Driver added successfully.")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  HomeScreen(subScreen: BusesScreen(), selectedIndex: 7),
        ),
      );
    } on FirebaseException catch (e) {
      setState(() {
        errorMessage = "Firebase error: ${e.message}";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Unexpected error: ${e.toString()}";
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
                      ReusablePhotoUpload(
                        headline: "Photo",
                        imagePath: "assets/images/Person.png",
                        onChoose: () {},
                        onRemove: () {},
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "First Name",
                                    hintText: "Tony",
                                    controller: firstNameController,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Last Name",
                                    hintText: "Stark",
                                    controller: lastNameController,
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
                                    controller: dobController,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Email Address",
                                    hintText: "Driver@gmail.com",
                                    controller: driverEmailController,
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
                                    controller: salaryController,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Bus Number",
                                    hintText: "1",
                                    controller: busNumberController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Area",
                                    hintText: "Smouha",
                                    controller: areaController,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Driver Phone",
                                    hintText: "01111111111",
                                    inputType: TextInputType.phone,
                                    controller: phoneController,
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
                                    controller: emailController,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ReusableTextField(
                                    headline: "Driver Password",
                                    hintText: "ynzmj26",
                                    controller: passwordController,
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
                  if (errorMessage != null)
                    Text(errorMessage!, style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomButton(
                      text: isSaving ? "Saving..." : "Save Bus Driver",
                      onTap: isSaving ? null : saveDriver,
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
