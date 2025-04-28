import 'package:cloud_firestore/cloud_firestore.dart';

class StudentService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _studentRef = FirebaseFirestore.instance.collection(
    'students',
  );

  Future<String> generateStudentId() async {
    try {
      final snapshot = await _studentRef.get();
      if (snapshot.docs.isEmpty) {
        return 'student1';
      }

      // Extract numeric parts from IDs
      final numericIds =
          snapshot.docs
              .map(
                (doc) =>
                    int.tryParse(doc.id.replaceAll(RegExp(r'\D'), '')) ?? 0,
              )
              .toList();

      // Find the maximum and increment
      final maxId =
          numericIds.isEmpty ? 0 : numericIds.reduce((a, b) => a > b ? a : b);
      return "student${(maxId + 1).toString()}";
    } catch (e) {
      rethrow;
    }
  }

  /// Add a new student
  Future<void> addStudent({
    required String studentId,
    required String studentName,
    required int numberOfAbsences,
    required String busNumber,
    required String studentMail,
    required String studentPassword,
    required String address,
    required Timestamp dateOfBirth,
    required String nationalId,
    required String coverPhoto,
    required bool comingToday,
    required DocumentReference parentRef,
    required DocumentReference classRef,
    required DocumentReference gradeRef,
    required DocumentReference driverRef,
  }) async {
    try {
      await _studentRef.doc(studentId).set({
        'studentName': studentName,
        'numberOfAbsences': numberOfAbsences,
        'busNumber': busNumber,
        'studentMail': studentMail,
        'studentPassword': studentPassword,
        'address': address,
        'dateOfBirth': dateOfBirth,
        'nationalId': nationalId,
        'coverPhoto': coverPhoto,
        'comingToday': comingToday,
        'parentRef': parentRef,
        'classRef': classRef,
        'gradeRef': gradeRef,
        'driverRef': driverRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get student by ID
  Future<Map<String, dynamic>?> getStudentById(String studentId) async {
    try {
      DocumentSnapshot doc = await _studentRef.doc(studentId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update a student
  Future<void> updateStudent({
    required String studentId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _studentRef.doc(studentId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a student
  Future<void> deleteStudent(String studentId) async {
    try {
      await _studentRef.doc(studentId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all students
  Future<List<Map<String, dynamic>>> getAllStudents() async {
    try {
      QuerySnapshot snapshot = await _studentRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
