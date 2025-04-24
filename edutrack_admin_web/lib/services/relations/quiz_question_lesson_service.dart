import 'package:cloud_firestore/cloud_firestore.dart';

class QuizQuestionLessonService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _ref = FirebaseFirestore.instance.collection(
    'quiz_question_lesson',
  );

  /// Add relation between quiz, question, and lesson
  Future<void> addRelation({
    required String documentId, // format: quizId_questionId_lessonId
    required DocumentReference quizRef,
    required DocumentReference questionRef,
    required DocumentReference lessonRef,
  }) async {
    try {
      await _ref.doc(documentId).set({
        'quizRef': quizRef,
        'questionRef': questionRef,
        'lessonRef': lessonRef,
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
