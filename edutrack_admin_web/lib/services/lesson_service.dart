import 'package:cloud_firestore/cloud_firestore.dart';

class LessonService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _lessonRef = FirebaseFirestore.instance.collection(
    'lessons',
  );

  /// Add a new lesson
  Future<void> addLesson({
    required String lessonId,
    required String lessonName,
    required DocumentReference subjectRef,
    required DocumentReference gradeRef,
  }) async {
    try {
      await _lessonRef.doc(lessonId).set({
        'lessonName': lessonName,
        'subjectRef': subjectRef,
        'gradeRef': gradeRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get lesson by ID
  Future<Map<String, dynamic>?> getLessonById(String lessonId) async {
    try {
      DocumentSnapshot doc = await _lessonRef.doc(lessonId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update a lesson
  Future<void> updateLesson({
    required String lessonId,
    String? lessonName,
    DocumentReference? subjectRef,
    DocumentReference? gradeRef,
  }) async {
    try {
      Map<String, dynamic> data = {};
      if (lessonName != null) data['lessonName'] = lessonName;
      if (subjectRef != null) data['subjectRef'] = subjectRef;
      if (gradeRef != null) data['gradeRef'] = gradeRef;

      await _lessonRef.doc(lessonId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete lesson
  Future<void> deleteLesson(String lessonId) async {
    try {
      await _lessonRef.doc(lessonId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all lessons
  Future<List<Map<String, dynamic>>> getAllLessons() async {
    try {
      QuerySnapshot snapshot = await _lessonRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
