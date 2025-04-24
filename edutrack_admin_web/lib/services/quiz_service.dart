import 'package:cloud_firestore/cloud_firestore.dart';

class QuizService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _quizRef = FirebaseFirestore.instance.collection(
    'quizzes',
  );

  /// Add a new quiz
  Future<void> addQuiz({
    required String quizId,
    required String quizTitle,
    required Timestamp quizDate,
    required String quizType,
    required int finalGrade,
    required int duration,
    required bool isAssignment,
    required DocumentReference gradeRef,
    required DocumentReference teacherRef,
    required DocumentReference subjectRef,
  }) async {
    try {
      await _quizRef.doc(quizId).set({
        'quizTitle': quizTitle,
        'quizDate': quizDate,
        'quizType': quizType,
        'finalGrade': finalGrade,
        'duration': duration,
        'isAssignment': isAssignment,
        'gradeRef': gradeRef,
        'teacherRef': teacherRef,
        'subjectRef': subjectRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get quiz by ID
  Future<Map<String, dynamic>?> getQuizById(String quizId) async {
    try {
      DocumentSnapshot doc = await _quizRef.doc(quizId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update a quiz
  Future<void> updateQuiz({
    required String quizId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _quizRef.doc(quizId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a quiz
  Future<void> deleteQuiz(String quizId) async {
    try {
      await _quizRef.doc(quizId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all quizzes
  Future<List<Map<String, dynamic>>> getAllQuizzes() async {
    try {
      QuerySnapshot snapshot = await _quizRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
