import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotSubjectService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _ref = FirebaseFirestore.instance.collection(
    'chatbot_subject',
  );

  /// Add chatbot-subject-grade relation
  Future<void> addRelation({
    required String documentId, // format: chatBotId_subjectId_gradeId
    required DocumentReference chatbotRef,
    required DocumentReference subjectRef,
    required DocumentReference gradeRef,
    required List<String> pdfs,
  }) async {
    try {
      await _ref.doc(documentId).set({
        'chatBotRef': chatbotRef,
        'subjectRef': subjectRef,
        'gradeRef': gradeRef,
        'pdfs': pdfs,
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
