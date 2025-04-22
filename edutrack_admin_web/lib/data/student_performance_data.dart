import 'package:edutrack_admin_web/models/student_performance_model.dart';

class StudentPerformanceData {
  static final List<StudentPerformanceTableModel> studentPerformance = const [
    StudentPerformanceTableModel(
      date: '17/3/2025',
      quiz: 'Math',
      finalGrade: '20',
      studentGrade: '98%',
    ),
    StudentPerformanceTableModel(
      date: '18/3/2025',
      quiz: 'Arabic',
      finalGrade: '40',
      studentGrade: '92%',
    ),
    StudentPerformanceTableModel(
      date: '3/4/2025',
      quiz: 'Math',
      finalGrade: '20',
      studentGrade: '0%',
    ),
    StudentPerformanceTableModel(
      date: '21/4/2025',
      quiz: 'Physics',
      finalGrade: '30',
      studentGrade: '89%',
    ),
    StudentPerformanceTableModel(
      date: '25/4/2025',
      quiz: 'English',
      finalGrade: '20',
      studentGrade: '0%',
    ),
    StudentPerformanceTableModel(
      date: '1/5/2025',
      quiz: 'Chemistry',
      finalGrade: '20',
      studentGrade: '0%',
    ),
  ];
}
