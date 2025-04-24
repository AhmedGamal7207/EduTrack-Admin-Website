import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _attendanceRef = FirebaseFirestore.instance
      .collection('attendance');

  /// Add attendance record
  Future<void> addAttendance({
    required String attId,
    required String day,
    required Timestamp date,
    required Timestamp timestamp,
    required String status,
    required DocumentReference studentRef,
    required DocumentReference parentRef,
    required DocumentReference teacherRef,
  }) async {
    try {
      await _attendanceRef.doc(attId).set({
        'day': day,
        'date': date,
        'timestamp': timestamp,
        'status': status,
        'studentRef': studentRef,
        'parentRef': parentRef,
        'teacherRef': teacherRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get attendance by ID
  Future<Map<String, dynamic>?> getAttendanceById(String attId) async {
    try {
      DocumentSnapshot doc = await _attendanceRef.doc(attId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update attendance record
  Future<void> updateAttendance({
    required String attId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _attendanceRef.doc(attId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete attendance record
  Future<void> deleteAttendance(String attId) async {
    try {
      await _attendanceRef.doc(attId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all attendance records
  Future<List<Map<String, dynamic>>> getAllAttendance() async {
    try {
      QuerySnapshot snapshot = await _attendanceRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
