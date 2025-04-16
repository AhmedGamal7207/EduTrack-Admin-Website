// data/attendance_warning_data.dart
import 'package:edutrack_admin_web/models/table_model.dart';

class TableData {
  final List<TableModel> warnings = const [
    TableModel(
      name: 'Savannah Nguyen',
      id: '123456789',
      grade: 'Grade 1',
      studentClass: 'Class 1',
      absences: 10,
    ),
    TableModel(
      name: 'Eleanor Pena',
      id: '123456789',
      grade: 'Grade 5',
      studentClass: 'Class 2',
      absences: 7,
    ),
    TableModel(
      name: 'Floyd Miles',
      id: '123456789',
      grade: 'Grade 12',
      studentClass: 'Class 1',
      absences: 15,
    ),
    TableModel(
      name: 'Darrell Steward',
      id: '123456789',
      grade: 'Grade 10',
      studentClass: 'Class 3',
      absences: 9,
    ),
  ];
}
