import 'package:edutrack_admin_web/models/class_students_model.dart';

class ClassStudentsData {
  static final List<ClassStudentsTableModel> classStudents = const [
    ClassStudentsTableModel(
      name: 'Savannah Nguyen',
      id: '123456789',
      concentration: '82%',
      absences: 3,
      attendance: 'Attended',
    ),
    ClassStudentsTableModel(
      name: 'Eleanor Pena',
      id: '123456789',
      concentration: '68%',
      absences: 7,
      attendance: 'Attended',
    ),
    ClassStudentsTableModel(
      name: 'Floyd Miles',
      id: '123456789',
      concentration: '34%',
      absences: 10,
      attendance: 'Absent',
    ),
    ClassStudentsTableModel(
      name: 'Darrell Steward',
      id: '123456789',
      concentration: '91%',
      absences: 5,
      attendance: 'Attended',
    ),
  ];
}
