import 'package:cloud_firestore/cloud_firestore.dart';

class ConcentrationReportService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _reportRef = FirebaseFirestore.instance.collection(
    'concentrationReports',
  );

  /// Add a new concentration report
  Future<void> addConcentrationReport({
    required String reportId,
    required int concentration,
    required String day,
    required Timestamp date,
    required DocumentReference teacherRef,
    required DocumentReference subjectRef,
    required DocumentReference gradeRef,
    DocumentReference? studentRef,
    DocumentReference? parentRef,
  }) async {
    try {
      final data = {
        'concentration': concentration,
        'day': day,
        'date': date,
        'teacherRef': teacherRef,
        'subjectRef': subjectRef,
        'gradeRef': gradeRef,
      };
      if (studentRef != null) data['studentRef'] = studentRef;
      if (parentRef != null) data['parentRef'] = parentRef;

      await _reportRef.doc(reportId).set(data);
    } catch (e) {
      rethrow;
    }
  }

  /// Get report by ID
  Future<Map<String, dynamic>?> getConcentrationReportById(
    String reportId,
  ) async {
    try {
      DocumentSnapshot doc = await _reportRef.doc(reportId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update report
  Future<void> updateConcentrationReport({
    required String reportId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _reportRef.doc(reportId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete report
  Future<void> deleteConcentrationReport(String reportId) async {
    try {
      await _reportRef.doc(reportId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all reports
  Future<List<Map<String, dynamic>>> getAllConcentrationReports() async {
    try {
      QuerySnapshot snapshot = await _reportRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
