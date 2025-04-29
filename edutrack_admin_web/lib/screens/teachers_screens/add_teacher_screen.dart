import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/teachers_screens/teachers_screen.dart';
import 'package:edutrack_admin_web/services/cloudinary_service.dart';
import 'package:edutrack_admin_web/services/relations/teacher_grade_service.dart';
import 'package:edutrack_admin_web/services/relations/teacher_subject_grade_service.dart';
import 'package:edutrack_admin_web/services/subject_service.dart';
import 'package:edutrack_admin_web/services/teacher_service.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/combo_box_upload.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/photo_upload_widget.dart';
import 'package:edutrack_admin_web/widgets/add_data_widgets/text_field_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dobController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final salaryController = TextEditingController();
  final teacherEmailController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedGrade;
  String? selectedMajor;
  String? selectedSecond;

  String? selectedGrade2;
  String? selectedMajor2;
  String? selectedSecond2;

  Uint8List? imageBytes;
  String? fileName;
  String? imageUrl;
  String? errorMessage;
  bool isSaving = false;

  String? teacherId;

  List<String> filteredSubjects = [];
  List<String> filteredSubjects2 = [];

  @override
  void initState() {
    super.initState();
    firstNameController.addListener(autoGenerateEmailAndPassword);
    lastNameController.addListener(autoGenerateEmailAndPassword);
  }

  void autoGenerateEmailAndPassword() async {
    teacherId = await TeacherService().generateTeacherId();
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) return;

    teacherId ??= await TeacherService().generateTeacherId();
    final email =
        "$firstName$lastName-$teacherId@${Constants.schoolName}-teacher.com"
            .toLowerCase();
    final password = "${firstName.toLowerCase()}${DateTime.now().year}";

    setState(() {
      emailController.text = email;
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

  Future<void> saveTeacher() async {
    setState(() {
      isSaving = true;
      errorMessage = null;
    });

    try {
      final teacherName =
          "${firstNameController.text.trim()} ${lastNameController.text.trim()}";
      final dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
      final dobTimestamp = Timestamp.fromDate(dob);
      final teacherEmail = teacherEmailController.text.trim();
      final password = passwordController.text.trim();

      if (imageBytes != null && fileName != null) {
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          imageBytes!,
          teacherId!,
          folder: "teachers",
        );
      } else {
        final defaultBytes = await rootBundle.load('assets/images/Person.png');
        final defaultData = defaultBytes.buffer.asUint8List();
        final cloudinaryService = CloudinaryService();
        imageUrl = await cloudinaryService.uploadImage(
          defaultData,
          teacherId!,
          folder: "teachers",
        );
      }

      await TeacherService().addTeacher(
        teacherId: teacherId!,
        teacherName: teacherName,
        salary: int.tryParse(salaryController.text.trim()) ?? 0,
        teacherEmail: teacherEmail,
        teacherPhone: phoneController.text.trim(),
        dateOfBirth: dobTimestamp,
        teacherMail: emailController.text.trim(),
        teacherPassword: password,
        coverPhoto: imageUrl ?? '',
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
      child: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(headerTitle: "Add New Teacher"),
              const SizedBox(height: Constants.internalSpacing),
              WhiteContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Teacher Details", style: Constants.subHeadingStyle),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusablePhotoUpload(
                          headline: "Photo",
                          imagePath: "assets/images/Person.png",
                          onImageSelected: onPhotoSelected,
                          onImageRemoved: onPhotoRemoved,
                          initialImageBytes: imageBytes,
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
                                      hintText: "Teacher@gmail.com",
                                      controller: teacherEmailController,
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
                                        List<Map<String, dynamic>>
                                        subjectsDocuments =
                                            await SubjectService()
                                                .getAllSubjects();
                                        setState(() {
                                          selectedGrade = value;
                                          filteredSubjects = [];

                                          for (Map<String, dynamic> subject
                                              in subjectsDocuments) {
                                            if (subject["subjectId"]
                                                    .toString()
                                                    .split(
                                                      subject["subjectName"]
                                                          .toString()
                                                          .toLowerCase(),
                                                    )[0] ==
                                                selectedGrade!.split(" ")[1]) {
                                              filteredSubjects.add(
                                                subject["subjectId"],
                                              );
                                            }
                                          }
                                        });
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
                                      headline: "Major Subject",
                                      items: filteredSubjects,
                                      selectedItem: selectedMajor,
                                      itemLabel: (item) => item,
                                      onChanged: (value) {
                                        setState(() => selectedMajor = value);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ReusableComboBox<String>(
                                      headline: "Second Subject",
                                      items: ["-"] + filteredSubjects,
                                      selectedItem: selectedSecond,
                                      itemLabel: (item) => item,
                                      onChanged: (value) {
                                        setState(() => selectedSecond = value);
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
                                      headline: "Second Grade (Optional)",
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
                                      selectedItem: selectedGrade2,
                                      itemLabel: (item) => item,
                                      onChanged: (value) async {
                                        List<Map<String, dynamic>>
                                        subjectsDocuments =
                                            await SubjectService()
                                                .getAllSubjects();
                                        setState(() {
                                          selectedGrade2 = value;
                                          filteredSubjects2 = [];

                                          for (Map<String, dynamic> subject
                                              in subjectsDocuments) {
                                            if (subject["subjectId"]
                                                    .toString()
                                                    .split(
                                                      subject["subjectName"]
                                                          .toString()
                                                          .toLowerCase(),
                                                    )[0] ==
                                                selectedGrade2!.split(" ")[1]) {
                                              filteredSubjects2.add(
                                                subject["subjectId"],
                                              );
                                            }
                                          }
                                        });
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
                                      headline:
                                          "Major Subject (for second grade)",
                                      items: filteredSubjects2,
                                      selectedItem: selectedMajor2,
                                      itemLabel: (item) => item,
                                      onChanged: (value) {
                                        setState(() => selectedMajor2 = value);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ReusableComboBox<String>(
                                      headline:
                                          "Second Subject (for second grade)",
                                      items: ["-"] + filteredSubjects2,
                                      selectedItem: selectedSecond2,
                                      itemLabel: (item) => item,
                                      onChanged: (value) {
                                        setState(() => selectedSecond2 = value);
                                      },
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
                                      headline: "Phone",
                                      hintText: "0123456789",
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
                                      headline: "Teacher Email",
                                      hintText: "Tony3000@school.com",
                                      inputType: TextInputType.emailAddress,
                                      controller: emailController,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: ReusableTextField(
                                      headline: "Teacher Password",
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                        text: isSaving ? "Saving..." : "Save Teacher",
                        onTap: isSaving ? null : saveTeacher,
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
