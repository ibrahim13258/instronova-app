import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService with ChangeNotifier {
  // 👉 Backend का Base URL
  static const String _baseUrl = "http://192.168.1.5:5000/api/v1";

  final _storage = const FlutterSecureStorage();

  String? _authToken;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get authToken => _authToken;

  ApiService() {
    _loadToken();
  }

  // ------------------ Load Token from Storage ------------------
  Future<void> _loadToken() async {
    _authToken = await _storage.read(key: "authToken");
    notifyListeners();
  }

  // ------------------ Save Token ------------------
  Future<void> _saveToken(String token) async {
    _authToken = token;
    await _storage.write(key: "authToken", value: token);
    notifyListeners();
  }

  // ------------------ Clear Token (Logout) ------------------
  Future<void> logout() async {
    _authToken = null;
    await _storage.delete(key: "authToken");
    notifyListeners();
  }

  // ------------------ LOGIN ------------------
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/login"),
        body: jsonEncode({"email": email, "password": password}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data["token"]);
      } else {
        _handleError(response);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------ SIGNUP ------------------
  Future<void> signup(String name, String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/signup"),
        body: jsonEncode({
          "name": name,
          "username": username,
          "email": email, // ✅ fix added
          "password": password,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 201) {
        _handleError(response);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------ FORGOT PASSWORD (OTP) ------------------
  Future<void> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/forgot-password"),
        body: jsonEncode({"email": email}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        _handleError(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ------------------ VERIFY OTP ------------------
  Future<void> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/verify-otp"),
        body: jsonEncode({"email": email, "otp": otp}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["token"] != null) {
          await _saveToken(data["token"]); // ✅ Save new token
        }
      } else {
        _handleError(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  // ------------------ Error Handler ------------------
  void _handleError(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      throw Exception(data["message"] ?? "Request failed");
    } catch (_) {
      throw Exception("Unexpected server error [${response.statusCode}]");
    }
  }
}
