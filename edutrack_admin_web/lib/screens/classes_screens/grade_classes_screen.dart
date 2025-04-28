import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/screens/classes_screens/add_class_screen.dart';
import 'package:edutrack_admin_web/screens/classes_screens/class_screen.dart';
import 'package:edutrack_admin_web/screens/home_screen.dart';
import 'package:edutrack_admin_web/services/class_service.dart';
import 'package:edutrack_admin_web/widgets/cards/clickable_card_widget.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/cards/info_card_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:flutter/material.dart';

class GradeClassesScreen extends StatefulWidget {
  final String gradeNumber;
  const GradeClassesScreen({super.key, required this.gradeNumber});

  @override
  State<GradeClassesScreen> createState() => _GradeClassesScreenState();
}

class _GradeClassesScreenState extends State<GradeClassesScreen> {
  List<Map<String, dynamic>> classes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final allClasses = await ClassService().getAllClasses();
      final filtered =
          allClasses.where((classInstance) {
            final ref = classInstance['gradeRef'] as DocumentReference;
            return ref.id == widget.gradeNumber;
          }).toList();

      setState(() {
        classes = filtered;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load classes: ${e.toString()}';
        isLoading = false;
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
              HeaderWidget(headerTitle: "Grade ${widget.gradeNumber} Classes"),
              const SizedBox(height: Constants.internalSpacing),
              WhiteContainer(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Center(
                      child: InfoCard(
                        cardTitle: "Grade ${widget.gradeNumber}",
                        cardSubtitle: "Classes",
                      ),
                    ),
                    SizedBox(height: 20),
                    if (isLoading)
                      const CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!, style: TextStyle(color: Colors.red))
                    else if (classes.isEmpty)
                      const Text("No classes found.")
                    else
                      Center(
                        child: Wrap(
                          spacing: 50, // Horizontal space between cards
                          runSpacing: 20, // Vertical space between rows
                          alignment:
                              WrapAlignment.center, // Center the whole row
                          children:
                              classes.map((classInstance) {
                                final classNumber =
                                    classInstance['classNumber'] ?? '-';
                                return ClickableCard(
                                  cardTitle:
                                      "${widget.gradeNumber} / $classNumber",
                                  buttonText: "Show Class Info",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => HomeScreen(
                                              subScreen: ClassScreen(
                                                gradeNumber: widget.gradeNumber,
                                                classNumber: classNumber,
                                              ),
                                              selectedIndex: 1,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: "Add New Class",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => HomeScreen(
                                  subScreen: AddClassScreen(
                                    gradeNumber: widget.gradeNumber,
                                  ),
                                  selectedIndex: 1,
                                ),
                          ),
                        );
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
