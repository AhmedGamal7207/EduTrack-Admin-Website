import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack_admin_web/services/authentication_service.dart';

class DriverService {
  final CollectionReference _driverRef = FirebaseFirestore.instance.collection(
    'drivers',
  );

  /// Generate auto-incremented driver ID
  Future<String> generateDriverId() async {
    try {
      final snapshot = await _driverRef.get();
      if (snapshot.docs.isEmpty) {
        return 'driver1';
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
      return "driver${(maxId + 1).toString()}";
    } catch (e) {
      rethrow;
    }
  }

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
        'driverId': driverId,
      });
    } catch (e) {
      rethrow;
    }
    signUp(driverMail, driverPassword);
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
