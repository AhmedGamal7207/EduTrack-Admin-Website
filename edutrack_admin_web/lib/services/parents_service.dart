import 'package:cloud_firestore/cloud_firestore.dart';

class ParentService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _parentRef = FirebaseFirestore.instance.collection(
    'parents',
  );

  /// Add a new parent
  Future<void> addParent({
    required String parentId,
    required String parentName,
    required String parentPhone,
    required String parentEmail,
    required String parentMail,
    required String parentPassword,
  }) async {
    try {
      await _parentRef.doc(parentId).set({
        'parentName': parentName,
        'parentPhone': parentPhone,
        'parentEmail': parentEmail,
        'parentMail': parentMail,
        'parentPassword': parentPassword,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get parent by ID
  Future<Map<String, dynamic>?> getParentById(String parentId) async {
    try {
      DocumentSnapshot doc = await _parentRef.doc(parentId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update parent
  Future<void> updateParent({
    required String parentId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _parentRef.doc(parentId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete parent
  Future<void> deleteParent(String parentId) async {
    try {
      await _parentRef.doc(parentId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all parents
  Future<List<Map<String, dynamic>>> getAllParents() async {
    try {
      QuerySnapshot snapshot = await _parentRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
