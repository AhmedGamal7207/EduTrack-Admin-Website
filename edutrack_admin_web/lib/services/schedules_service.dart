import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _scheduleRef = FirebaseFirestore.instance
      .collection('schedules');

  /// Add a new schedule slot
  Future<void> addSchedule({
    required String slotId,
    required String day,
    required int sessionNumber,
    required DocumentReference subjectRef,
    required DocumentReference gradeRef,
    required DocumentReference teacherRef,
    required DocumentReference classRef,
  }) async {
    try {
      await _scheduleRef.doc(slotId).set({
        'day': day,
        'sessionNumber': sessionNumber,
        'subjectRef': subjectRef,
        'gradeRef': gradeRef,
        'teacherRef': teacherRef,
        'classRef': classRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get schedule slot by ID
  Future<Map<String, dynamic>?> getScheduleById(String slotId) async {
    try {
      DocumentSnapshot doc = await _scheduleRef.doc(slotId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update schedule slot
  Future<void> updateSchedule({
    required String slotId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _scheduleRef.doc(slotId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete schedule slot
  Future<void> deleteSchedule(String slotId) async {
    try {
      await _scheduleRef.doc(slotId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all schedule slots
  Future<List<Map<String, dynamic>>> getAllSchedules() async {
    try {
      QuerySnapshot snapshot = await _scheduleRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
