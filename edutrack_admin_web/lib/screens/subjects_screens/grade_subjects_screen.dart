import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/screens/subjects_screens/add_subject_screen.dart';
import 'package:edutrack_admin_web/services/subject_service.dart';
import 'package:edutrack_admin_web/widgets/cards/clickable_card_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/confirmation_dialog_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/cards/info_card_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class GradeSubjectsScreen extends StatefulWidget {
  final String gradeNumber;
  const GradeSubjectsScreen({super.key, required this.gradeNumber});

  @override
  State<GradeSubjectsScreen> createState() => _GradeSubjectsScreenState();
}

class _GradeSubjectsScreenState extends State<GradeSubjectsScreen> {
  List<Map<String, dynamic>> subjects = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
  }

  Future<void> fetchSubjects() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final allSubjects = await SubjectService().getAllSubjects();
      final filtered =
          allSubjects.where((subj) {
            final ref = subj['gradeRef'] as DocumentReference;
            return ref.id == widget.gradeNumber;
          }).toList();

      setState(() {
        subjects = filtered;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load subjects: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> deleteSubject(String subjectId) async {
    try {
      await SubjectService().deleteSubject(subjectId);
      fetchSubjects();
    } catch (e) {
      setState(() {
        errorMessage = 'Error deleting subject: ${e.toString()}';
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
              HeaderWidget(headerTitle: "Grade ${widget.gradeNumber} Subjects"),
              const SizedBox(height: Constants.internalSpacing),
              WhiteContainer(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Center(
                      child: InfoCard(
                        cardTitle: "Grade ${widget.gradeNumber}",
                        cardSubtitle: "Subjects",
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!, style: TextStyle(color: Colors.red))
                    else if (subjects.isEmpty)
                      const Text("No subjects found.")
                    else
                      Center(
                        child: Wrap(
                          spacing: 50,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children:
                              subjects.map((subject) {
                                final name = subject['subjectName'] ?? '-';
                                final id = subject['subjectId'] ?? '';
                                return ClickableCard(
                                  cardTitle: name,
                                  buttonText: "Delete Subject",
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => ConfirmationDialog(
                                            title: "Delete Subject?",
                                            message:
                                                "Are you sure you want to delete $name?",
                                            onConfirm: () => deleteSubject(id),
                                          ),
                                    );
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Add New Subject",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HomeScreen(
                                  subScreen: AddSubjectScreen(
                                    gradeNumber: widget.gradeNumber,
                                  ),
                                  selectedIndex: 4,
                                ),
                          ),
                        ).then((_) => fetchSubjects());
                      },
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
