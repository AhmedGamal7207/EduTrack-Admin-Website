import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherGradeService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _ref = FirebaseFirestore.instance.collection(
    'teacher_grade',
  );

  /// Add a teacher-grade relation
  Future<void> addRelation({
    required String documentId, // format: teacherId_gradeId
    required DocumentReference teacherRef,
    required DocumentReference gradeRef,
  }) async {
    try {
      await _ref.doc(documentId).set({
        'teacherRef': teacherRef,
        'gradeRef': gradeRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get relation by ID
  Future<Map<String, dynamic>?> getRelationById(String documentId) async {
    try {
      DocumentSnapshot doc = await _ref.doc(documentId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update relation
  Future<void> updateRelation({
    required String documentId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _ref.doc(documentId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete relation
  Future<void> deleteRelation(String documentId) async {
    try {
      await _ref.doc(documentId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all relations
  Future<List<Map<String, dynamic>>> getAllRelations() async {
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
