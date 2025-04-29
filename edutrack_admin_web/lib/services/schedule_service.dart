import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleService {
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

  /// Get all schedule slots for a specific class
  Future<List<Map<String, dynamic>>> getSchedulesByClassId(
    String classId,
  ) async {
    try {
      DocumentReference classRef = FirebaseFirestore.instance
          .collection('classes')
          .doc(classId);

      QuerySnapshot snapshot =
          await _scheduleRef.where('classRef', isEqualTo: classRef).get();

      return snapshot.docs
          .map(
            (doc) => {...doc.data() as Map<String, dynamic>, 'slotId': doc.id},
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get schedule slots for a specific class on a specific day
  Future<List<Map<String, dynamic>>> getSchedulesByClassAndDay(
    String classId,
    String day,
  ) async {
    try {
      DocumentReference classRef = FirebaseFirestore.instance
          .collection('classes')
          .doc(classId);

      QuerySnapshot snapshot =
          await _scheduleRef
              .where('classRef', isEqualTo: classRef)
              .where('day', isEqualTo: day)
              .orderBy('sessionNumber')
              .get();

      return snapshot.docs
          .map(
            (doc) => {...doc.data() as Map<String, dynamic>, 'slotId': doc.id},
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get schedule slots for a specific teacher
  Future<List<Map<String, dynamic>>> getSchedulesByTeacher(
    DocumentReference teacherRef,
  ) async {
    try {
      QuerySnapshot snapshot =
          await _scheduleRef.where('teacherRef', isEqualTo: teacherRef).get();

      return snapshot.docs
          .map(
            (doc) => {...doc.data() as Map<String, dynamic>, 'slotId': doc.id},
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if a teacher is available at a specific time slot
  Future<bool> isTeacherAvailable(
    DocumentReference teacherRef,
    String day,
    int sessionNumber,
    String currentSlotId,
  ) async {
    try {
      QuerySnapshot snapshot =
          await _scheduleRef
              .where('teacherRef', isEqualTo: teacherRef)
              .where('day', isEqualTo: day)
              .where('sessionNumber', isEqualTo: sessionNumber)
              .get();

      // If the only result is the current slot being edited, teacher is available
      if (snapshot.docs.length == 1 &&
          snapshot.docs.first.id == currentSlotId) {
        return true;
      }

      // Teacher is available if no other slots are found at this time
      return snapshot.docs.isEmpty;
    } catch (e) {
      rethrow;
    }
  }
}
