import 'package:cloud_firestore/cloud_firestore.dart';

class ParentService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _parentRef = FirebaseFirestore.instance.collection(
    'parents',
  );

  Future<String> generateParentId() async {
    try {
      final snapshot = await _parentRef.get();
      if (snapshot.docs.isEmpty) {
        return 'parent1';
      }
      // Extract numeric parts from IDs
      final numericIds =
          snapshot.docs
              .map(
                (doc) =>
                    int.tryParse(doc.id.replaceAll(RegExp(r'\D'), '')) ?? 0,
              )
              .toList();

      // Find the maximum and increment
      final maxId =
          numericIds.isEmpty ? 0 : numericIds.reduce((a, b) => a > b ? a : b);
      return "parent${(maxId + 1).toString()}";
    } catch (e) {
      rethrow;
    }
  }

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
        'parentId': parentId,
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

  DocumentReference<Map<String, dynamic>> getParentRef(String parentId) {
    return FirebaseFirestore.instance.collection("parents").doc(parentId);
  }

  Future<Map<String, dynamic>?> getParentByRef(dynamic parentRef) async {
    try {
      // Get reference to the document
      DocumentReference parentRefDoc = parentRef as DocumentReference;
      DocumentSnapshot parentSnapshot =
          await FirebaseFirestore.instance.doc(parentRefDoc.path).get();

      if (parentSnapshot.exists) {
        Map<String, dynamic> parentData =
            parentSnapshot.data() as Map<String, dynamic>;
        return parentData;
      } else {
        print("Parent data is null");
        return null;
      }
    } catch (e) {
      print('Error fetching parent data: $e');
      return null;
    }
  }
}
