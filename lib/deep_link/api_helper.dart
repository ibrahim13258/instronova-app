 import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiHelper {
  ApiHelper._privateConstructor();
  static final ApiHelper instance = ApiHelper._privateConstructor();

  final String baseUrl = "https://api.yourapp.com";

  /// GET request
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl$endpoint"),
        headers: headers,
      );
      return _processResponse(response);
    } catch (e) {
      debugPrint("GET request error: $e");
      return {'error': e.toString()};
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      debugPrint("POST request error: $e");
      return {'error': e.toString()};
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, String>? headers, Map<String, dynamic>? body}) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl$endpoint"),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      debugPrint("PUT request error: $e");
      return {'error': e.toString()};
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl$endpoint"),
        headers: headers,
      );
      return _processResponse(response);
    } catch (e) {
      debugPrint("DELETE request error: $e");
      return {'error': e.toString()};
    }
  }

  /// Process HTTP response
  Map<String, dynamic> _processResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'error': data['message'] ?? 'Unknown error'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Invalid response format'};
    }
  }
}
