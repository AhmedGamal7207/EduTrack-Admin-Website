import 'package:cloud_firestore/cloud_firestore.dart';

class ClassService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _classRef = FirebaseFirestore.instance.collection(
    'classes',
  );

  /// Add a new class
  Future<void> addClass({
    required String classId,
    required int classNumber,
    required DocumentReference currentSubjectRef,
    required DocumentReference currentTeacherRef,
    required String className,
    required String classLetter,
    required int roomNumber,
    required String coverPhoto,
    required DocumentReference gradeRef,
  }) async {
    try {
      await _classRef.doc(classId).set({
        'classNumber': classNumber,
        'currentSubjectRef': currentSubjectRef,
        'currentTeacherRef': currentTeacherRef,
        'className': className,
        'classLetter': classLetter,
        'roomNumber': roomNumber,
        'coverPhoto': coverPhoto,
        'gradeRef': gradeRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get class by ID
  Future<Map<String, dynamic>?> getClassById(String classId) async {
    try {
      DocumentSnapshot doc = await _classRef.doc(classId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update class
  Future<void> updateClass({
    required String classId,
    int? classNumber,
    DocumentReference? currentSubjectRef,
    DocumentReference? currentTeacherRef,
    String? className,
    String? classLetter,
    int? roomNumber,
    String? coverPhoto,
    DocumentReference? gradeRef,
  }) async {
    try {
      Map<String, dynamic> data = {};
      if (classNumber != null) data['classNumber'] = classNumber;
      if (currentSubjectRef != null)
        data['currentSubjectRef'] = currentSubjectRef;
      if (currentTeacherRef != null)
        data['currentTeacherRef'] = currentTeacherRef;
      if (className != null) data['className'] = className;
      if (classLetter != null) data['classLetter'] = classLetter;
      if (roomNumber != null) data['roomNumber'] = roomNumber;
      if (coverPhoto != null) data['coverPhoto'] = coverPhoto;
      if (gradeRef != null) data['gradeRef'] = gradeRef;

      await _classRef.doc(classId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete class
  Future<void> deleteClass(String classId) async {
    try {
      await _classRef.doc(classId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all classes
  Future<List<Map<String, dynamic>>> getAllClasses() async {
    try {
      QuerySnapshot snapshot = await _classRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
