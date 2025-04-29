import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/constants/constants.dart';
import 'package:edutrack_admin_web/widgets/buttons/custom_button_widget.dart';
import 'package:edutrack_admin_web/widgets/headers/header_widget.dart';
import 'package:edutrack_admin_web/widgets/white_container_widget.dart';
import 'package:edutrack_admin_web/services/schedule_service.dart';
import 'package:edutrack_admin_web/services/subject_service.dart';
import 'package:edutrack_admin_web/services/teacher_service.dart';
import 'package:edutrack_admin_web/services/class_service.dart';
import 'package:lottie/lottie.dart';

class ClassSchedulePage extends StatefulWidget {
  final String gradeNumber;
  final String classNumber;

  const ClassSchedulePage({
    super.key,
    required this.gradeNumber,
    required this.classNumber,
  });

  @override
  State<ClassSchedulePage> createState() => _ClassSchedulePageState();
}

class _ClassSchedulePageState extends State<ClassSchedulePage> {
  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu'];
  final int maxSessions = 7; // Maximum number of sessions per day

  // Services
  final ScheduleService _scheduleService = ScheduleService();
  final SubjectService _subjectService = SubjectService();
  final TeacherService _teacherService = TeacherService();
  final ClassService _classService = ClassService();

  // Data
  late String classId;
  late DocumentReference classRef;
  List<Map<String, dynamic>> subjects = [];
  List<Map<String, dynamic>> teachers = [];
  Map<String, List<String>> subjectTeachersMap = {};

  // Schedule data structure
  // [row][column]['subject'] = subjectId and [row][column]['teacher'] = teacherId
  late List<List<Map<String, String>>> scheduleData;

  bool isLoading = true;
  bool isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    classId = "${widget.gradeNumber}class${widget.classNumber}";
    classRef = _classService.getClassRef(classId);

    // Initialize empty schedule data
    scheduleData = List.generate(
      maxSessions, // rows for periods
      (_) => List.generate(
        days.length, // days (Sun-Thu)
        (_) => {'subject': '', 'teacher': '', 'slotId': ''},
      ),
    );

    _loadData();
  }

  // Load all necessary data
  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 1. Load subjects for this grade
      await _loadSubjects();

      // 2. Load teachers
      await _loadTeachers();

      // 3. Map subjects to their teachers
      await _mapSubjectTeachers();

      // 4. Load existing schedule data if any
      await _loadScheduleData();
    } catch (e) {
      print('Error loading data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    }

    setState(() {
      isLoading = false;
    });
  }

  // Load subjects for this grade
  Future<void> _loadSubjects() async {
    try {
      List<Map<String, dynamic>> allSubjects =
          await _subjectService.getAllSubjects();

      for (var subject in allSubjects) {
        if (subject.containsKey('gradeRef')) {
          DocumentSnapshot gradeSnapshot = await subject['gradeRef'].get();
          if (gradeSnapshot.exists) {
            Map<String, dynamic> gradeData =
                gradeSnapshot.data() as Map<String, dynamic>;
            if (gradeData['gradeNumber'] == widget.gradeNumber) {
              subjects.add(subject);
            }
          }
        }
      }
    } catch (e) {
      print('Error loading subjects: $e');
      rethrow;
    }
  }

  // Load all teachers
  Future<void> _loadTeachers() async {
    try {
      List<Map<String, dynamic>> allTeachers =
          await _teacherService.getAllTeachers();
      teachers = allTeachers;
    } catch (e) {
      print('Error loading teachers: $e');
      rethrow;
    }
  }

  // Map subjects to their teachers (this would typically be based on some relationship in your data)
  // For now, we'll assume all teachers can teach all subjects
  Future<void> _mapSubjectTeachers() async {
    try {
      // This is a placeholder implementation
      // In a real app, you would have a way to determine which teachers teach which subjects

      for (var subject in subjects) {
        String subjectId = subject['subjectId'];
        List<String> teacherIds = [];

        // For now, add all teachers to each subject
        // In a real implementation, you would filter teachers based on which ones teach this subject
        for (var teacher in teachers) {
          teacherIds.add(teacher['teacherId']);
        }

        subjectTeachersMap[subjectId] = teacherIds;
      }
    } catch (e) {
      print('Error mapping subjects to teachers: $e');
      rethrow;
    }
  }

  // Load existing schedule data
  Future<void> _loadScheduleData() async {
    try {
      for (
        int sessionNumber = 0;
        sessionNumber < maxSessions;
        sessionNumber++
      ) {
        for (int dayIndex = 0; dayIndex < days.length; dayIndex++) {
          String day = days[dayIndex];
          String slotId = '${classId}_${day}_${sessionNumber + 1}';

          Map<String, dynamic>? slotData = await _scheduleService
              .getScheduleById(slotId);

          if (slotData != null) {
            // Get subject and teacher data from references
            DocumentReference subjectRef = slotData['subjectRef'];
            DocumentReference teacherRef = slotData['teacherRef'];

            Map<String, dynamic>? subjectData = await _subjectService
                .getSubjectByRef(subjectRef);
            Map<String, dynamic>? teacherData = await _teacherService
                .getTeacherByRef(teacherRef);

            if (subjectData != null && teacherData != null) {
              setState(() {
                scheduleData[sessionNumber][dayIndex] = {
                  'subject': subjectData['subjectId'],
                  'teacher': teacherData['teacherId'],
                  'slotId': slotId,
                };
              });
            }
          } else {
            // Slot doesn't exist, but set the slotId for future save
            setState(() {
              scheduleData[sessionNumber][dayIndex]['slotId'] = slotId;
            });
          }
        }
      }
    } catch (e) {
      print('Error loading schedule data: $e');
      rethrow;
    }
  }

  // Save schedule to Firebase
  Future<void> _saveSchedule() async {
    setState(() {
      isSaving = true;
    });

    try {
      for (
        int sessionNumber = 0;
        sessionNumber < maxSessions;
        sessionNumber++
      ) {
        for (int dayIndex = 0; dayIndex < days.length; dayIndex++) {
          Map<String, String> cellData = scheduleData[sessionNumber][dayIndex];
          String slotId =
              cellData['slotId'] ??
              '${classId}_${days[dayIndex]}_${sessionNumber + 1}';
          String subjectId = cellData['subject'] ?? '';
          String teacherId = cellData['teacher'] ?? '';

          // Skip if no subject or teacher is selected
          if (subjectId.isEmpty || teacherId.isEmpty) {
            // If there was previously a schedule here, delete it
            if (cellData['slotId']?.isNotEmpty == true) {
              await _scheduleService.deleteSchedule(slotId);
            }
            continue;
          }

          DocumentReference subjectRef = FirebaseFirestore.instance
              .collection('subjects')
              .doc(subjectId);
          DocumentReference teacherRef = _teacherService.getTeacherRef(
            teacherId,
          );
          DocumentReference gradeRef = FirebaseFirestore.instance
              .collection('grades')
              .doc('grade${widget.gradeNumber}');

          Map<String, dynamic>? existingSlot = await _scheduleService
              .getScheduleById(slotId);

          if (existingSlot != null) {
            // Update existing slot
            await _scheduleService.updateSchedule(
              slotId: slotId,
              updatedData: {'subjectRef': subjectRef, 'teacherRef': teacherRef},
            );
          } else {
            // Create new slot
            await _scheduleService.addSchedule(
              slotId: slotId,
              day: days[dayIndex],
              sessionNumber: sessionNumber + 1,
              subjectRef: subjectRef,
              gradeRef: gradeRef,
              teacherRef: teacherRef,
              classRef: classRef,
            );
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule saved successfully')),
      );

      setState(() {
        _hasChanges = false;
      });
    } catch (e) {
      print('Error saving schedule: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving schedule: $e')));
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  // Get subject name by ID
  /*String _getSubjectName(String subjectId) {
    for (var subject in subjects) {
      if (subject['subjectId'] == subjectId) {
        return subject['subjectName'];
      }
    }
    return '';
  }*/

  // Get teacher name by ID
  String _getTeacherName(String teacherId) {
    for (var teacher in teachers) {
      if (teacher['teacherId'] == teacherId) {
        return teacher['teacherName'];
      }
    }
    return '';
  }

  // Get available teachers for a subject
  List<String> _getTeachersForSubject(String subjectId) {
    return subjectTeachersMap[subjectId] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? Center(
                child: Lottie.asset(
                  'assets/lotties/student_loading.json',
                  width: 450,
                  height: 450,
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(Constants.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      headerTitle:
                          'Class ${widget.classNumber}/${widget.gradeNumber} Schedule',
                    ),
                    const SizedBox(height: Constants.internalSpacing),
                    Expanded(
                      child: WhiteContainer(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildScheduleTable(),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: CustomButton(
                                  text:
                                      isSaving ? "Saving..." : "Save Schedule",
                                  onTap: isSaving ? null : _saveSchedule,
                                  hasIcon: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildScheduleTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {0: FixedColumnWidth(100)},
      children: [
        // Header Row
        TableRow(
          decoration: const BoxDecoration(color: Constants.scheduleHeaderBg),
          children: [
            const SizedBox(),
            ...days.map(
              (day) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(day, style: Constants.subHeadingStyle),
                ),
              ),
            ),
          ],
        ),

        // Data Rows
        for (int row = 0; row < maxSessions; row++)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text('S${row + 1}', style: Constants.subHeadingStyle),
                ),
              ),
              ...List.generate(days.length, (col) {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      _buildSubjectDropdown(row, col),
                      const SizedBox(height: 6),
                      _buildTeacherDropdown(row, col),
                    ],
                  ),
                );
              }),
            ],
          ),
      ],
    );
  }

  Widget _buildSubjectDropdown(int row, int col) {
    String currentSubjectId = scheduleData[row][col]['subject'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal.shade100),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: currentSubjectId.isEmpty ? null : currentSubjectId,
          hint: const Text('Subject', style: TextStyle(fontSize: 13)),
          items: [
            // Empty option for clearing selection
            const DropdownMenuItem<String>(
              value: '',
              child: Text('None', style: TextStyle(fontSize: 13)),
            ),
            // Subject options
            ...subjects.map(
              (subject) => DropdownMenuItem<String>(
                value: subject['subjectId'],
                child: Text(
                  subject['subjectName'],
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              scheduleData[row][col]['subject'] = value ?? '';
              // Clear teacher if subject changes
              scheduleData[row][col]['teacher'] = '';
              _hasChanges = true;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTeacherDropdown(int row, int col) {
    String currentSubjectId = scheduleData[row][col]['subject'] ?? '';
    String currentTeacherId = scheduleData[row][col]['teacher'] ?? '';
    List<String> availableTeacherIds =
        currentSubjectId.isEmpty
            ? []
            : _getTeachersForSubject(currentSubjectId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.teal.shade100),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: currentTeacherId.isEmpty ? null : currentTeacherId,
          hint: const Text('Teacher', style: TextStyle(fontSize: 13)),
          items:
              currentSubjectId.isEmpty
                  ? []
                  : [
                    // Empty option for clearing selection
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('None', style: TextStyle(fontSize: 13)),
                    ),
                    // Teacher options for this subject
                    ...availableTeacherIds.map(
                      (teacherId) => DropdownMenuItem<String>(
                        value: teacherId,
                        child: Text(
                          _getTeacherName(teacherId),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
          onChanged:
              currentSubjectId.isEmpty
                  ? null
                  : (value) {
                    setState(() {
                      scheduleData[row][col]['teacher'] = value ?? '';
                      _hasChanges = true;
                    });
                  },
        ),
      ),
    );
  }
}
