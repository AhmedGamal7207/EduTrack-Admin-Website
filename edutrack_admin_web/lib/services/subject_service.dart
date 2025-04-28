import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _subjectRef = FirebaseFirestore.instance.collection(
    'subjects',
  );

  /// Add a new subject
  Future<void> addSubject({
    required String subjectId,
    required String subjectName,
    required int numberOfLessons,
    required String coverPhoto,
    required String lessons,
    required DocumentReference gradeRef,
  }) async {
    try {
      await _subjectRef.doc(subjectId).set({
        'subjectName': subjectName,
        'numberOfLessons': numberOfLessons,
        'coverPhoto': coverPhoto,
        'lessons': lessons.split("\n"),
        'subjectId': subjectId,
        'gradeRef': gradeRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get subject by ID
  Future<Map<String, dynamic>?> getSubjectById(String subjectId) async {
    try {
      DocumentSnapshot doc = await _subjectRef.doc(subjectId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update a subject
  Future<void> updateSubject({
    required String subjectId,
    String? subjectName,
    int? numberOfLessons,
    String? coverPhoto,
    DocumentReference? gradeRef,
  }) async {
    try {
      Map<String, dynamic> data = {};
      if (subjectName != null) data['subjectName'] = subjectName;
      if (numberOfLessons != null) data['numberOfLessons'] = numberOfLessons;
      if (coverPhoto != null) data['coverPhoto'] = coverPhoto;
      if (gradeRef != null) data['gradeRef'] = gradeRef;

      await _subjectRef.doc(subjectId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete subject
  Future<void> deleteSubject(String subjectId) async {
    try {
      await _subjectRef.doc(subjectId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all subjects
  Future<List<Map<String, dynamic>>> getAllSubjects() async {
    try {
      QuerySnapshot snapshot = await _subjectRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSubjectByRef(dynamic subjectRef) async {
    try {
      // Get reference to the document
      DocumentReference subjectRefDoc = subjectRef as DocumentReference;
      DocumentSnapshot subjectSnapshot =
          await FirebaseFirestore.instance.doc(subjectRefDoc.path).get();
      if (subjectSnapshot.exists) {
        Map<String, dynamic> subjectData =
            subjectSnapshot.data() as Map<String, dynamic>;
        return subjectData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching subject data: $e');
      return null;
    }
  }
}
