// models/attendance_warning_model.dart
class AllStudentsTableModel {
  final String name;
  final String id;
  final String busNumber;
  final String studentClass;
  final int absences;
  final String parentPhone;
  final String parentMail;

  const AllStudentsTableModel({
    required this.name,
    required this.id,
    required this.busNumber,
    required this.studentClass,
    required this.absences,
    required this.parentPhone,
    required this.parentMail,
  });
}
