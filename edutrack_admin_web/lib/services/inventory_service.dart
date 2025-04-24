import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _inventoryRef = FirebaseFirestore.instance
      .collection('inventory');

  /// Add inventory item
  Future<void> addInventory({
    required String inventoryId,
    required String elementName,
    required String elementStatus,
    required DocumentReference classRef,
  }) async {
    try {
      await _inventoryRef.doc(inventoryId).set({
        'elementName': elementName,
        'elementStatus': elementStatus,
        'classRef': classRef,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get inventory item by ID
  Future<Map<String, dynamic>?> getInventoryById(String inventoryId) async {
    try {
      DocumentSnapshot doc = await _inventoryRef.doc(inventoryId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update inventory item
  Future<void> updateInventory({
    required String inventoryId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _inventoryRef.doc(inventoryId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete inventory item
  Future<void> deleteInventory(String inventoryId) async {
    try {
      await _inventoryRef.doc(inventoryId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all inventory items
  Future<List<Map<String, dynamic>>> getAllInventory() async {
    try {
      QuerySnapshot snapshot = await _inventoryRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
