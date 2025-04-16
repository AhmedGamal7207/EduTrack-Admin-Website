import 'package:edutrack_admin_web/models/inventory_element.dart';
import 'package:edutrack_admin_web/models/student.dart';

class GradeClass {
  final String classNumber;
  final String gradeNumber;
  final String? className;
  final String? classLetter;
  final String? roomNumber;
  final List<Student>? studentsList;
  final int? attendingStudentsNubmer;
  final List<Student>? attendingStudentsList;
  final String? currentSubject;
  final String? currentTeacher;
  final List<InventoryElement>? inventoryList;

  GradeClass({
    required this.classNumber,
    required this.gradeNumber,
    this.className,
    this.classLetter,
    this.roomNumber,
    this.studentsList,
    this.attendingStudentsNubmer,
    this.attendingStudentsList,
    this.currentSubject,
    this.currentTeacher,
    this.inventoryList,
  });
}
