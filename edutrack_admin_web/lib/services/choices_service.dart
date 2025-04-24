import 'package:cloud_firestore/cloud_firestore.dart';

class ChoiceService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _choiceRef = FirebaseFirestore.instance.collection(
    'choices',
  );

  /// Add a new choice
  Future<void> addChoice({
    required String choiceId,
    required String choiceText,
    required bool isCorrect,
    required DocumentReference questionRef,
    required DocumentReference quizRef,
  }) async {
    try {
      await _choiceRef.doc(choiceId).set({
        'choiceText': choiceText,
        'isCorrect': isCorrect,
        'questionRef': questionRef,
        'quizRef': quizRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get choice by ID
  Future<Map<String, dynamic>?> getChoiceById(String choiceId) async {
    try {
      DocumentSnapshot doc = await _choiceRef.doc(choiceId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update choice
  Future<void> updateChoice({
    required String choiceId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _choiceRef.doc(choiceId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete choice
  Future<void> deleteChoice(String choiceId) async {
    try {
      await _choiceRef.doc(choiceId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all choices
  Future<List<Map<String, dynamic>>> getAllChoices() async {
    try {
      QuerySnapshot snapshot = await _choiceRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
