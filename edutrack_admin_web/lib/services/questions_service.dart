import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _questionRef = FirebaseFirestore.instance
      .collection('questions');

  /// Add a new question
  Future<void> addQuestion({
    required String questionId,
    required String questionText,
    required String questionType,
    required String correctAnswer,
    required int points,
    required DocumentReference quizRef,
  }) async {
    try {
      await _questionRef.doc(questionId).set({
        'questionText': questionText,
        'questionType': questionType,
        'correctAnswer': correctAnswer,
        'points': points,
        'quizRef': quizRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get question by ID
  Future<Map<String, dynamic>?> getQuestionById(String questionId) async {
    try {
      DocumentSnapshot doc = await _questionRef.doc(questionId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update question
  Future<void> updateQuestion({
    required String questionId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _questionRef.doc(questionId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete question
  Future<void> deleteQuestion(String questionId) async {
    try {
      await _questionRef.doc(questionId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all questions
  Future<List<Map<String, dynamic>>> getAllQuestions() async {
    try {
      QuerySnapshot snapshot = await _questionRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
