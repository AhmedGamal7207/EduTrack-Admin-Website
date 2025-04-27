import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotService {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _chatbotRef = FirebaseFirestore.instance.collection(
    'chatbots',
  );
  Future<String> generateChatbotId() async {
    try {
      final snapshot = await _chatbotRef.get();
      if (snapshot.docs.isEmpty) {
        return 'chatbot1';
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
      return "chatbot${(maxId + 1).toString()}";
    } catch (e) {
      rethrow;
    }
  }

  /// Add a new chatbot
  Future<void> addChatbot({
    required String chatbotId,
    required String chatbotName,
    required String coverPhoto,
  }) async {
    try {
      await _chatbotRef.doc(chatbotId).set({
        'chatbotName': chatbotName,
        'coverPhoto': coverPhoto,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get chatbot by ID
  Future<Map<String, dynamic>?> getChatbotById(String chatBotId) async {
    try {
      DocumentSnapshot doc = await _chatbotRef.doc(chatBotId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Update chatbot
  Future<void> updateChatbot({
    required String chatBotId,
    Map<String, dynamic> updatedData = const {},
  }) async {
    try {
      await _chatbotRef.doc(chatBotId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete chatbot
  Future<void> deleteChatbot(String chatBotId) async {
    try {
      await _chatbotRef.doc(chatBotId).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// Get all chatbots
  Future<List<Map<String, dynamic>>> getAllChatbots() async {
    try {
      QuerySnapshot snapshot = await _chatbotRef.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
