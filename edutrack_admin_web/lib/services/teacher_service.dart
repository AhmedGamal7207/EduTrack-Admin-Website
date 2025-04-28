import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/services/authentication_service.dart';

class TeacherService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _teacherRef = FirebaseFirestore.instance.collection(
    'teachers',
  );

  Future<String> generateTeacherId() async {
    try {
      final snapshot = await _teacherRef.get();
      if (snapshot.docs.isEmpty) {
        return 'teacher1';
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
      return "teacher${(maxId + 1).toString()}";
    } catch (e) {
      rethrow;
    }
  }

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
        'teacherId': teacherId,
      });
    } catch (e) {
      rethrow;
    }
    signUp(teacherMail, teacherPassword);
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

  Future<Map<String, dynamic>?> getTeacherByRef(dynamic teacherRef) async {
    try {
      // Get reference to the document
      DocumentReference teacherRefDoc = teacherRef as DocumentReference;
      DocumentSnapshot teacherSnapshot =
          await FirebaseFirestore.instance.doc(teacherRefDoc.path).get();

      if (teacherSnapshot.exists) {
        Map<String, dynamic> teacherData =
            teacherSnapshot.data() as Map<String, dynamic>;
        return teacherData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching teacher data: $e');
      return null;
    }
  }

  DocumentReference<Map<String, dynamic>> getTeacherRef(String teacherId) {
    return FirebaseFirestore.instance.collection("teachers").doc(teacherId);
  }
}
