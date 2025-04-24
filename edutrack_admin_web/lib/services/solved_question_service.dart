import 'package:cloud_firestore/cloud_firestore.dart';

class SolvedQuestionService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _solvedQuestionRef = FirebaseFirestore.instance
      .collection('solvedQuestions');

  /// Add solved question
  Future<void> addSolvedQuestion({
    required String documentId, // format: quizId_questionId_studentId
    required DocumentReference quizRef,
    required DocumentReference questionRef,
    required DocumentReference studentRef,
    required DocumentReference parentRef,
    required String questionAnswer,
    required bool isCorrect,
  }) async {
    try {
      await _solvedQuestionRef.doc(documentId).set({
        'quizRef': quizRef,
        'questionRef': questionRef,
        'studentRef': studentRef,
        'parentRef': parentRef,
        'questionAnswer': questionAnswer,
        'isCorrect': isCorrect,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get solved question by ID
  Future<Map<String, dynamic>?> getSolvedQuestionById(String documentId) async {
    try {
      DocumentSnapshot doc = await _solvedQuestionRef.doc(documentId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update solved question
  Future<void> updateSolvedQuestion({
    required String documentId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _solvedQuestionRef.doc(documentId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete solved question
  Future<void> deleteSolvedQuestion(String documentId) async {
    try {
      await _solvedQuestionRef.doc(documentId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all solved questions
  Future<List<Map<String, dynamic>>> getAllSolvedQuestions() async {
    try {
      QuerySnapshot snapshot = await _solvedQuestionRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
