import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CloudinaryService {
  // Replace these with your actual Cloudinary credentials
  static const String cloudName = 'dkq7pumqj';
  static const String apiKey = '546648957676668';
  static const String apiSecret = 'oF87Ru3Yzpy1fopXFTmELlgeeJY';
  static const String uploadPreset =
      'edutrack_preset'; // Optional if using unsigned uploads

  // Upload image to Cloudinary with folder parameter
  Future<String?> uploadImage(
    Uint8List imageBytes,
    String fileName, {
    String? folder,
  }) async {
    try {
      // Base URL for Cloudinary uploads
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      // Convert image bytes to base64
      final base64Image = base64Encode(imageBytes);

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add necessary parameters
      request.fields['upload_preset'] = uploadPreset;
      request.fields['file'] = 'data:image/jpeg;base64,$base64Image';

      // Add folder parameter if specified
      if (folder != null && folder.isNotEmpty) {
        request.fields['folder'] = folder;
      }

      // Send the request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        // Return the secure URL of the uploaded image
        return jsonData['secure_url'];
      } else {
        print('Failed to upload image: ${jsonData['error']['message']}');
        return null;
      }
    } catch (e) {
      print('Exception during image upload: $e');
      return null;
    }
  }

  // Upload PDF to Cloudinary with folder parameter
  Future<String?> uploadPdf(
    Uint8List pdfBytes,
    String fileName, {
    String? folder,
  }) async {
    try {
      // Base URL for Cloudinary uploads - using 'raw' for PDF files
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/raw/upload',
      );

      // Convert PDF bytes to base64
      final base64Pdf = base64Encode(pdfBytes);

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add necessary parameters
      request.fields['upload_preset'] = uploadPreset;
      request.fields['file'] = 'data:application/pdf;base64,$base64Pdf';

      // Add public_id for better file management
      String publicID = fileName.substring(0, fileName.length - 4);
      request.fields['public_id'] = publicID
          .replaceAll(' ', '_')
          .replaceAll('.', '_');

      // Add folder parameter if specified
      if (folder != null && folder.isNotEmpty) {
        request.fields['folder'] = folder;
      }

      // Send the request
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        // Return the secure URL of the uploaded PDF
        return jsonData['secure_url'];
      } else {
        print('Failed to upload PDF: ${jsonData['error']['message']}');
        return null;
      }
    } catch (e) {
      print('Exception during PDF upload: $e');
      return null;
    }
  }
}
