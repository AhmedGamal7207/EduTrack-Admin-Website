import 'package:edutrack_admin_web/models/att_warnings_model.dart';

class AttendanceWarningsData {
  static final List<AttendanceWarningsTableModel> warnings = const [
    AttendanceWarningsTableModel(
      name: 'Savannah Nguyen',
      id: '123456789',
      grade: 'Grade 1',
      studentClass: 'Class 1',
      absences: 10,
    ),
    AttendanceWarningsTableModel(
      name: 'Eleanor Pena',
      id: '123456789',
      grade: 'Grade 5',
      studentClass: 'Class 2',
      absences: 7,
    ),
    AttendanceWarningsTableModel(
      name: 'Floyd Miles',
      id: '123456789',
      grade: 'Grade 12',
      studentClass: 'Class 1',
      absences: 15,
    ),
    AttendanceWarningsTableModel(
      name: 'Darrell Steward',
      id: '123456789',
      grade: 'Grade 10',
      studentClass: 'Class 3',
      absences: 9,
    ),
  ];
}
