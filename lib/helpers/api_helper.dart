import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  // Base URL of your API
  static const String baseUrl = 'https://api.yourapp.com';

  // Generic GET request
  static Future<Map<String, dynamic>> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url, headers: _defaultHeaders());

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'GET request failed: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  // Generic POST request
  static Future<Map<String, dynamic>> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: _defaultHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'POST request failed: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  // Default headers
  static Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer YOUR_TOKEN', // Uncomment if token needed
    };
  }

  // Optional: Handle API errors and provide friendly messages
  static String handleError(dynamic error) {
    if (error is http.ClientException) {
      return 'Network error, please check your internet connection.';
    } else if (error is FormatException) {
      return 'Invalid response format from server.';
    } else {
      return error.toString();
    }
  }
}
