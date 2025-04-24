import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _teacherRef = FirebaseFirestore.instance.collection(
    'teachers',
  );

  /// Add a new teacher
  Future<void> addTeacher({
    required String teacherId,
    required String teacherName,
    required int salary,
    required String teacherEmail,
    required String teacherPhone,
    required Timestamp dateOfBirth,
    required String teacherMail,
    required String teacherPassword,
    required String coverPhoto,
  }) async {
    try {
      await _teacherRef.doc(teacherId).set({
        'teacherName': teacherName,
        'salary': salary,
        'teacherEmail': teacherEmail,
        'teacherPhone': teacherPhone,
        'dateOfBirth': dateOfBirth,
        'teacherMail': teacherMail,
        'teacherPassword': teacherPassword,
        'coverPhoto': coverPhoto,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get teacher by ID
  Future<Map<String, dynamic>?> getTeacherById(String teacherId) async {
    try {
      DocumentSnapshot doc = await _teacherRef.doc(teacherId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update teacher
  Future<void> updateTeacher({
    required String teacherId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _teacherRef.doc(teacherId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete teacher
  Future<void> deleteTeacher(String teacherId) async {
    try {
      await _teacherRef.doc(teacherId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all teachers
  Future<List<Map<String, dynamic>>> getAllTeachers() async {
    try {
      QuerySnapshot snapshot = await _teacherRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
