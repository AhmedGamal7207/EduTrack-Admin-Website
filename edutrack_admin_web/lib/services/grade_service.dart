import 'package:cloud_firestore/cloud_firestore.dart';

class GradeService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _gradesRef = FirebaseFirestore.instance.collection(
    'grades',
  );

  /// Add a new grade
  Future<void> addGrade({
    required String gradeId,
    required int gradeNumber,
  }) async {
    try {
      await _gradesRef.doc(gradeId).set({'gradeNumber': gradeNumber});
    } catch (e) {
      rethrow;
    }
  }

  /// Get a grade by ID
  Future<Map<String, dynamic>?> getGradeById(String gradeId) async {
    try {
      DocumentSnapshot doc = await _gradesRef.doc(gradeId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update a grade
  Future<void> updateGrade({
    required String gradeId,
    required int gradeNumber,
  }) async {
    try {
      await _gradesRef.doc(gradeId).update({'gradeNumber': gradeNumber});
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a grade
  Future<void> deleteGrade(String gradeId) async {
    try {
      await _gradesRef.doc(gradeId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all grades
  Future<List<Map<String, dynamic>>> getAllGrades() async {
    try {
      QuerySnapshot snapshot = await _gradesRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  DocumentReference<Map<String, dynamic>> getGradeRef(String gradeId) {
    return FirebaseFirestore.instance.collection("grades").doc(gradeId);
  }

  Future<Map<String, dynamic>?> getGradeByRef(dynamic gradeRef) async {
    try {
      // Get reference to the document
      DocumentReference gradeRefDoc = gradeRef as DocumentReference;
      DocumentSnapshot gradeSnapshot =
          await FirebaseFirestore.instance.doc(gradeRefDoc.path).get();

      if (gradeSnapshot.exists) {
        Map<String, dynamic> gradeData =
            gradeSnapshot.data() as Map<String, dynamic>;
        return gradeData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching grade data: $e');
      return null;
    }
  }
}
