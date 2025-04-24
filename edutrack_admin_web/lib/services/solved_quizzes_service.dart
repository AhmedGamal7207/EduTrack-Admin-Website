import 'package:cloud_firestore/cloud_firestore.dart';

class SolvedQuizService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _solvedQuizRef = FirebaseFirestore.instance
      .collection('solvedQuizzes');

  /// Add solved quiz
  Future<void> addSolvedQuiz({
    required String documentId, // format: quizId_studentId
    required DocumentReference quizRef,
    required DocumentReference studentRef,
    required DocumentReference parentRef,
    required int score,
    required Timestamp submissionDate,
  }) async {
    try {
      await _solvedQuizRef.doc(documentId).set({
        'quizRef': quizRef,
        'studentRef': studentRef,
        'parentRef': parentRef,
        'score': score,
        'submissionDate': submissionDate,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get solved quiz by ID
  Future<Map<String, dynamic>?> getSolvedQuizById(String documentId) async {
    try {
      DocumentSnapshot doc = await _solvedQuizRef.doc(documentId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update solved quiz
  Future<void> updateSolvedQuiz({
    required String documentId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _solvedQuizRef.doc(documentId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete solved quiz
  Future<void> deleteSolvedQuiz(String documentId) async {
    try {
      await _solvedQuizRef.doc(documentId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all solved quizzes
  Future<List<Map<String, dynamic>>> getAllSolvedQuizzes() async {
    try {
      QuerySnapshot snapshot = await _solvedQuizRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
