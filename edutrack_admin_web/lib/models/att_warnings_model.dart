// models/attendance_warning_model.dart
class AttendanceWarningsTableModel {
  final String name;
  final String id;
  final String grade;
  final String studentClass;
  final int absences;

  const AttendanceWarningsTableModel({
    required this.name,
    required this.id,
    required this.grade,
    required this.studentClass,
    required this.absences,
  });
}
