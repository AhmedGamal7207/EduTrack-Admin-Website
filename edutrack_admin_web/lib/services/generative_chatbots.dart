import 'dart:convert';
import 'package:http/http.dart' as http;

class GenerativeChatbots {
  final String baseUrl = 'https://edutrack2025.pythonanywhere.com';

  Future<String?> generateChatbot(
    String chatbotSubjectId,
    List<String> pdfs,
  ) async {
    try {
      // Remove the trailing slash from the URL
      final uri = Uri.parse(
        'https://edutrack2025.pythonanywhere.com/create_chatbot',
      );

      // Add timeout to the request
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'chatbot_id': chatbotSubjectId, 'pdfs': pdfs}),
          )
          .timeout(Duration(seconds: 60)); // Add a reasonable timeout

      if (response.statusCode == 200) {
        return "Successfully created chatbot with id: $chatbotSubjectId";
      } else {
        // Properly handle error responses with different formats
        try {
          final jsonData = json.decode(response.body);
          final errorMessage =
              jsonData['error'] is String
                  ? jsonData['error']
                  : jsonData['error']?['message'] ?? 'Unknown error';
          print('Failed to generate chatbot: $errorMessage');
        } catch (e) {
          print('Failed to parse error response: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      print('Exception during generating chatbot: $e');
      return null;
    }
  }

  // You might want to add a method to test connectivity
  Future<bool> testConnection() async {
    try {
      final uri = Uri.parse('https://edutrack2025.pythonanywhere.com/health');
      final response = await http.get(uri).timeout(Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  Future<String?> queryChatbot(String chatbotSubjectId, String query) async {
    try {
      final uri = Uri.parse('$baseUrl/query');

      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'chatbot_id': chatbotSubjectId, 'query': query}),
          )
          .timeout(Duration(seconds: 60)); // Longer timeout for queries

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['answer'];
      } else {
        // Handle error responses
        try {
          final jsonData = json.decode(response.body);
          final errorMessage =
              jsonData['error'] is String
                  ? jsonData['error']
                  : jsonData['error']?['message'] ?? 'Unknown error';
          print('Failed to query chatbot: $errorMessage');
        } catch (e) {
          print('Failed to parse error response: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      print('Exception during chatbot query: $e');
      return null;
    }
  }
}
