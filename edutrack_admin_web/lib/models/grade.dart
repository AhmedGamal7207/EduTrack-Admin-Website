import 'package:edutrack_admin_web/models/grade_class.dart';

class Grade {
  final String gradeNumber;
  List<GradeClass>? classesList;
  final int numberOfClasses;

  Grade({
    required this.gradeNumber,
    required this.numberOfClasses,
    this.classesList,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
    gradeNumber: json['gradeNumber'],
    numberOfClasses: json['numberOfClasses'],
    classesList: json['classesList'] ? json['classesList'] : null,
  );
}
