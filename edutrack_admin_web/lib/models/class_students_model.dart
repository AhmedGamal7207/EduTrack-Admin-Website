// models/attendance_warning_model.dart
class ClassStudentsTableModel {
  final String name;
  final String id;
  final String concentration;
  final int absences;
  final String attendance;

  const ClassStudentsTableModel({
    required this.name,
    required this.id,
    required this.concentration,
    required this.absences,
    required this.attendance,
  });
}
