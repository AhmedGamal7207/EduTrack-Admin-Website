import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherSubjectGradeService {
  final CollectionReference _ref = FirebaseFirestore.instance.collection(
    'teacher_subject_grade',
  );

  /// Add a new teacher-subject-grade relation
  Future<void> addRelation({
    required String documentId, // format: teacherId_subjectId_gradeId
    required bool isMajor,
    required DocumentReference teacherRef,
    required DocumentReference subjectRef,
    required DocumentReference gradeRef,
  }) async {
    try {
      await _ref.doc(documentId).set({
        'isMajor': isMajor,
        'teacherRef': teacherRef,
        'subjectRef': subjectRef,
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

  /// Get relations by grade
  Future<List<Map<String, dynamic>>> getRelationsByGrade(
    DocumentReference gradeRef,
  ) async {
    try {
      QuerySnapshot snapshot =
          await _ref.where('gradeRef', isEqualTo: gradeRef).get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get relations by subject and grade
  Future<List<Map<String, dynamic>>> getRelationsBySubjectAndGrade(
    DocumentReference subjectRef,
    DocumentReference gradeRef,
  ) async {
    try {
      QuerySnapshot snapshot =
          await _ref
              .where('subjectRef', isEqualTo: subjectRef)
              .where('gradeRef', isEqualTo: gradeRef)
              .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get teachers for a specific subject and grade
  Future<List<DocumentReference>> getTeachersForSubjectAndGrade(
    DocumentReference subjectRef,
    DocumentReference gradeRef,
  ) async {
    try {
      QuerySnapshot snapshot =
          await _ref
              .where('subjectRef', isEqualTo: subjectRef)
              .where('gradeRef', isEqualTo: gradeRef)
              .get();

      List<DocumentReference> teacherRefs = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        teacherRefs.add(data['teacherRef'] as DocumentReference);
      }

      return teacherRefs;
    } catch (e) {
      rethrow;
    }
  }
}
