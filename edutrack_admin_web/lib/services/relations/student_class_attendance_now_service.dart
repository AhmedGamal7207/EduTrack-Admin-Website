import 'package:cloud_firestore/cloud_firestore.dart';

class StudentClassAttendanceNowService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _ref = FirebaseFirestore.instance.collection(
    'student_class_attendance_now',
  );

  /// Add a student-class attendance now record
  Future<void> addRecord({
    required String documentId, // format: studentId_classId
    required DocumentReference studentRef,
    required DocumentReference classRef,
  }) async {
    try {
      await _ref.doc(documentId).set({
        'studentRef': studentRef,
        'classRef': classRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get record by ID
  Future<Map<String, dynamic>?> getRecordById(String documentId) async {
    try {
      DocumentSnapshot doc = await _ref.doc(documentId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update record
  Future<void> updateRecord({
    required String documentId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _ref.doc(documentId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete record
  Future<void> deleteRecord(String documentId) async {
    try {
      await _ref.doc(documentId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all records
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    try {
      QuerySnapshot snapshot = await _ref.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
