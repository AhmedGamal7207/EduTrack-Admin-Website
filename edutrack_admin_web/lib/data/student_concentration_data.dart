import 'package:edutrack_admin_web/models/student_concentration_model.dart';

class StudentConcentrationData {
  static final List<StudentConcentrationTableModel> studentConcentration =
      const [
        StudentConcentrationTableModel(
          date: '17/3/2025',
          day: 'Monday',
          attendance: "Attended",
          concentration: "98%",
        ),
        StudentConcentrationTableModel(
          date: '18/3/2025',
          day: 'Tuesday',
          attendance: "Attended",
          concentration: "92%",
        ),
        StudentConcentrationTableModel(
          date: '19/3/2025',
          day: 'Wednesday',
          attendance: "Absent",
          concentration: "0%",
        ),
        StudentConcentrationTableModel(
          date: '20/3/2025',
          day: 'Thursday',
          attendance: "Attended",
          concentration: "89%",
        ),
        StudentConcentrationTableModel(
          date: '23/3/2025',
          day: 'Sunday',
          attendance: "Absent",
          concentration: "0%",
        ),
        StudentConcentrationTableModel(
          date: '24/3/2025',
          day: 'Monday',
          attendance: "Absent",
          concentration: "0%",
        ),
      ];
}
