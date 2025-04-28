import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/students_screens/students_screen.dart';
import 'package:edutrack_admin_web/services/class_service.dart';
import 'package:edutrack_admin_web/services/cloudinary_service.dart';
import 'package:edutrack_admin_web/services/driver_service.dart';
import 'package:edutrack_admin_web/services/grade_service.dart';
import 'package:edutrack_admin_web/services/parent_service.dart';
import 'package:edutrack_admin_web/services/student_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/combo_box_upload.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final mailController = TextEditingController();
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();

  final parentEmailController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final parentFirstNameController = TextEditingController();
  final parentLastNameController = TextEditingController();
  final parentMailController = TextEditingController();
  final parentPasswordController = TextEditingController();

  String? selectedGrade;
  String? selectedClass;
  String? selectedBusNumber;

  Uint8List? imageBytes;
  String? fileName;
  String? imageUrl;
  String? errorMessage;
  bool isSaving = false;

  String? studentId;
  String? parentId;

  List<String> filteredclasses = [];
  List<String> bussesNumbers = [];
  @override
  void initState() {
    super.initState();
    firstNameController.addListener(autoGenerateEmailAndPassword);
    lastNameController.addListener(autoGenerateEmailAndPassword);

    parentFirstNameController.addListener(autoGenerateEmailAndPasswordParent);
    parentLastNameController.addListener(autoGenerateEmailAndPasswordParent);

    loadBussesData();
  }

  void loadBussesData() async {
    List<String> loadedBusses =
        await DriverService().getBusNumberAreaDriverNameList();
    setState(() {
      bussesNumbers = loadedBusses;
    });
  }

  void autoGenerateEmailAndPassword() async {
    studentId = await StudentService().generateStudentId();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) return;

    studentId ??= await StudentService().generateStudentId();
    final email =
        "$firstName$lastName-$studentId@${Constants.schoolName}-student.com"
            .toLowerCase();
    final password = "${firstName.toLowerCase()}${DateTime.now().year}";

    setState(() {
      mailController.text = email;
      passwordController.text = password;
      studentIdController.text = studentId!;
    });
  }

  void autoGenerateEmailAndPasswordParent() async {
    parentId = await ParentService().generateParentId();
    final firstName = parentFirstNameController.text.trim();
    final lastName = parentLastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) return;

    parentId ??= await ParentService().generateParentId();
    final email =
        "$firstName$lastName-$parentId@${Constants.schoolName}-parent.com"
            .toLowerCase();
    final password = "${firstName.toLowerCase()}${DateTime.now().year}";

    setState(() {
      parentMailController.text = email;
      parentPasswordController.text = password;
    });
  }

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

  Future<void> saveStudent() async {
    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      final dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
      final dobTimestamp = Timestamp.fromDate(dob);
      final firstName = firstNameController.text;
      final lastName = lastNameController.text;
      final address = addressController.text;
      final email = mailController.text.trim();
      final password = passwordController.text.trim();

      final parentEmail = parentEmailController.text.trim();
      final parentPhone = parentPhoneController.text.trim();
      final parentFirstName = parentFirstNameController.text;
      final parentLastName = parentLastNameController.text;
      final parentMail = parentMailController.text.trim();
      final parentPassword = parentPasswordController.text.trim();

      String busNumber = selectedBusNumber!.split("-")[0].trim();

      if (imageBytes != null && fileName != null) {
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          imageBytes!,
          studentId!,
          folder: "students",
        );
      } else {
        final defaultBytes = await rootBundle.load('assets/images/Person.png');
        final defaultData = defaultBytes.buffer.asUint8List();
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          defaultData,
          studentId!,
          folder: "students",
        );
      }
      String gradeId = selectedGrade!.split(" ")[1];
      String classNumber = selectedClass!.split("class")[1].trim();
      String classId = "${gradeId}class$classNumber";
      String? driverId = await DriverService().getDriverIdByBusNumber(
        busNumber,
      );

      final gradeRef = GradeService().getGradeRef(gradeId);

      await ParentService().addParent(
        parentEmail: parentEmail,
        parentMail: parentMail,
        parentName: "$parentFirstName $parentLastName",
        parentPassword: parentPassword,
        parentPhone: parentPhone,
        parentId: parentId!,
      );

      await StudentService().addStudent(
        studentId: studentId!,
        studentName: "$firstName $lastName",
        numberOfAbsences: 0, // Assuming new students have 0 absences
        busNumber: busNumber,
        studentMail: email,
        studentPassword: password,
        address: address,
        dateOfBirth: dobTimestamp,
        coverPhoto: imageUrl!,
        comingToday: false,
        parentRef: ParentService().getParentRef(parentId!),
        classRef: ClassService().getClassRef(classId),
        gradeRef: gradeRef,
        driverRef: DriverService().getDriverRef(driverId!),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student added successfully.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  HomeScreen(subScreen: StudentsScreen(), selectedIndex: 2),
        ),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Error: ${e.toString()}";
        print(e);
      });
      rethrow;
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
      child: Align(
        alignment: Alignment.topLeft,
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
                        ReusablePhotoUpload(
                          headline: "Photo",
                          imagePath:
                              "assets/images/Person.png", // Replace with actual path
                          onImageSelected: onPhotoSelected,
                          onImageRemoved: onPhotoRemoved,
                          initialImageBytes: imageBytes,
                        ),
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
                                      headline: "Address",
                                      hintText: "7 Del Perro Heights",
                                      controller: addressController,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ReusableComboBox<String>(
                                      headline: "Grade",
                                      items: const [
                                        "Grade 1",
                                        "Grade 2",
                                        "Grade 3",
                                        "Grade 4",
                                        "Grade 5",
                                        "Grade 6",
                                        "Grade 7",
                                        "Grade 8",
                                        "Grade 9",
                                        "Grade 10",
                                        "Grade 11",
                                        "Grade 12",
                                      ],
                                      selectedItem: selectedGrade,
                                      itemLabel: (item) => item,
                                      onChanged: (value) async {
                                        filteredclasses = [];
                                        selectedGrade = value;
                                        filteredclasses = await ClassService()
                                            .getClassIdsByGradeNumber(
                                              selectedGrade!.split(" ")[1],
                                            );
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ReusableComboBox<String>(
                                      headline: "Class",
                                      items: filteredclasses,
                                      selectedItem: selectedClass,
                                      itemLabel: (item) => item,
                                      onChanged: (value) {
                                        setState(() => selectedClass = value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ReusableComboBox<String>(
                                      headline: "Bus Data",
                                      items: bussesNumbers,
                                      selectedItem: selectedBusNumber,
                                      itemLabel: (item) => item,
                                      onChanged: (value) {
                                        setState(
                                          () => selectedBusNumber = value,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ReusableTextField(
                                      headline: "Student ID",
                                      hintText: "123456789",
                                      inputType: TextInputType.number,
                                      controller: studentIdController,
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
                                      controller: mailController,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ReusableTextField(
                                      headline: "Student Password",
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
                                controller: parentFirstNameController,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ReusableTextField(
                                headline: "Last Name",
                                hintText: "Stark",
                                controller: parentLastNameController,
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
                                controller: parentEmailController,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ReusableTextField(
                                headline: "Phone Number",
                                hintText: "04071970",
                                inputType: TextInputType.phone,
                                controller: parentPhoneController,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ReusableTextField(
                                headline: "Parent Mail",
                                hintText: "Howard@edutrack-parent.com",
                                inputType: TextInputType.emailAddress,
                                controller: parentMailController,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ReusableTextField(
                                headline: "Password",
                                hintText: "howard2025",
                                inputType: TextInputType.text,
                                controller: parentPasswordController,
                              ),
                            ),
                          ],
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
                        text:
                            isSaving ? "Saving..." : "Save Student and Parent",
                        onTap: isSaving ? null : saveStudent,
                        hasIcon: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
