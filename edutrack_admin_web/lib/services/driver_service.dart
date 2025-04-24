import 'package:cloud_firestore/cloud_firestore.dart';

class DriverService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _driverRef = FirebaseFirestore.instance.collection(
    'drivers',
  );

  /// Add a new driver
  Future<void> addDriver({
    required String driverId,
    required String driverName,
    required int salary,
    required String busNumber,
    required String area,
    required String driverPhone,
    required Timestamp dateOfBirth,
    required String driverEmail,
    required String driverPassword,
    required String driverMail,
    required String coverPhoto,
  }) async {
    try {
      await _driverRef.doc(driverId).set({
        'driverName': driverName,
        'salary': salary,
        'busNumber': busNumber,
        'area': area,
        'driverPhone': driverPhone,
        'dateOfBirth': dateOfBirth,
        'driverEmail': driverEmail,
        'driverPassword': driverPassword,
        'driverMail': driverMail,
        'coverPhoto': coverPhoto,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get driver by ID
  Future<Map<String, dynamic>?> getDriverById(String driverId) async {
    try {
      DocumentSnapshot doc = await _driverRef.doc(driverId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update driver
  Future<void> updateDriver({
    required String driverId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _driverRef.doc(driverId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete driver
  Future<void> deleteDriver(String driverId) async {
    try {
      await _driverRef.doc(driverId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all drivers
  Future<List<Map<String, dynamic>>> getAllDrivers() async {
    try {
      QuerySnapshot snapshot = await _driverRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
