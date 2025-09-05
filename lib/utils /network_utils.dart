import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  // Base API URL
  static const String baseUrl = 'https://api.yourapp.com/';

  // Default headers
  static Map<String, String> defaultHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Check internet connectivity
  static Future<bool> hasConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // GET request
  static Future<Map<String, dynamic>> getRequest(String endpoint, {String? token}) async {
    if (!await hasConnection()) {
      throw Exception('No internet connection');
    }

    final response = await http.get(
      Uri.parse(baseUrl + endpoint),
      headers: defaultHeaders(token: token),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('GET request failed with status: ${response.statusCode}');
    }
  }

  // POST request
  static Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body, {String? token}) async {
    if (!await hasConnection()) {
      throw Exception('No internet connection');
    }

    final response = await http.post(
      Uri.parse(baseUrl + endpoint),
      headers: defaultHeaders(token: token),
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('POST request failed with status: ${response.statusCode}');
    }
  }

  // PUT request
  static Future<Map<String, dynamic>> putRequest(String endpoint, Map<String, dynamic> body, {String? token}) async {
    if (!await hasConnection()) {
      throw Exception('No internet connection');
    }

    final response = await http.put(
      Uri.parse(baseUrl + endpoint),
      headers: defaultHeaders(token: token),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('PUT request failed with status: ${response.statusCode}');
    }
  }

  // DELETE request
  static Future<Map<String, dynamic>> deleteRequest(String endpoint, {String? token}) async {
    if (!await hasConnection()) {
      throw Exception('No internet connection');
    }

    final response = await http.delete(
      Uri.parse(baseUrl + endpoint),
      headers: defaultHeaders(token: token),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('DELETE request failed with status: ${response.statusCode}');
    }
  }
}
