import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/services/cloudinary_service.dart';
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
  final nationalIdController = TextEditingController();
  final studentIdController = TextEditingController();
  final passwordController = TextEditingController();

  final parentEmailController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final parentfirstNameController = TextEditingController();
  final parentlastNameController = TextEditingController();
  String? selectedGrade;
  String? selectedClass;

  Uint8List? imageBytes;
  String? fileName;
  String? imageUrl;
  String? errorMessage;
  bool isSaving = false;

  String? studentId;

  List<String> filteredclasses = [];
  @override
  void initState() {
    super.initState();
    firstNameController.addListener(autoGenerateEmailAndPassword);
    lastNameController.addListener(autoGenerateEmailAndPassword);
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
      final teacherName =
          "${firstNameController.text.trim()} ${lastNameController.text.trim()}";
      final dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
      final dobTimestamp = Timestamp.fromDate(dob);
      final firstName = firstNameController.text;
      final lastName = lastNameController.text;
      final address = addressController.text;
      final email = mailController.text.trim();
      final nationalId = nationalIdController.text.trim();
      final password = passwordController.text.trim();

      final parentEmail = parentEmailController.text.trim();
      final parentPhone = parentPhoneController.text.trim();
      final parentFirstName = parentfirstNameController.text;
      final parentLastName = parentlastNameController.text;

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

      await StudentService().addStudent(
        studentId: studentId,
        studentName: "$firstName $lastName",
        numberOfAbsences: 0, // Assuming new students have 0 absences
        busNumber: '', // You need to set this if you have it
        studentMail: email,
        studentPassword: password,
        address: address,
        dateOfBirth: Timestamp.fromDate(
          DateTime.parse(dob),
        ), // Make sure `dob` is in 'yyyy-MM-dd' format
        nationalId: nationalId,
        coverPhoto: '', // You need to set this if you have it
        comingToday: false, // Set based on your logic
        parentRef: parentRef, // You should already have this reference
        classRef: classRef, // You should already have this reference
        gradeRef: gradeRef, // You should already have this reference
        driverRef: driverRef, // You should already have this reference
      );
      String gradeId = selectedGrade!.split(" ")[1];

      final gradeRef = FirebaseFirestore.instance
          .collection('grades')
          .doc(gradeId);

      final teacherRef = FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId);

      final majorSubjectRef = FirebaseFirestore.instance
          .collection('subjects')
          .doc(selectedMajor);

      await TeacherGradeService().addRelation(
        documentId: "${teacherId}_$gradeId",
        gradeRef: gradeRef,
        teacherRef: teacherRef,
      );

      await TeacherSubjectGradeService().addRelation(
        documentId: "${teacherId}_${selectedMajor}_$gradeId",
        isMajor: true,
        teacherRef: teacherRef,
        subjectRef: majorSubjectRef,
        gradeRef: gradeRef,
      );

      if (selectedSecond != null &&
          selectedSecond != "" &&
          selectedSecond != "-") {
        final secondSubjectRef = FirebaseFirestore.instance
            .collection('subjects')
            .doc(selectedSecond);
        await TeacherSubjectGradeService().addRelation(
          documentId: "${teacherId}_${selectedSecond}_$gradeId",
          isMajor: false,
          teacherRef: teacherRef,
          subjectRef: secondSubjectRef,
          gradeRef: gradeRef,
        );
      }

      if (selectedGrade2 != null &&
          selectedGrade2 != "" &&
          selectedGrade2 != "-") {
        String gradeId2 = selectedGrade2!.split(" ")[1];
        final gradeRef2 = FirebaseFirestore.instance
            .collection('grades')
            .doc(gradeId2);

        final majorSubjectRef2 = FirebaseFirestore.instance
            .collection('subjects')
            .doc(selectedMajor2);

        await TeacherGradeService().addRelation(
          documentId: "${teacherId}_$gradeId2",
          gradeRef: gradeRef2,
          teacherRef: teacherRef,
        );

        await TeacherSubjectGradeService().addRelation(
          documentId: "${teacherId}_${selectedMajor2}_$gradeId2",
          isMajor: true,
          teacherRef: teacherRef,
          subjectRef: majorSubjectRef2,
          gradeRef: gradeRef2,
        );

        if (selectedSecond2 != null &&
            selectedSecond2 != "" &&
            selectedSecond2 != "-") {
          final secondSubjectRef2 = FirebaseFirestore.instance
              .collection('subjects')
              .doc(selectedSecond2);
          await TeacherSubjectGradeService().addRelation(
            documentId: "${teacherId}_${selectedSecond2}_$gradeId2",
            isMajor: false,
            teacherRef: teacherRef,
            subjectRef: secondSubjectRef2,
            gradeRef: gradeRef2,
          );
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teacher added successfully.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  HomeScreen(subScreen: TeachersScreen(), selectedIndex: 3),
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
