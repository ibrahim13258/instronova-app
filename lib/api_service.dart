import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService with ChangeNotifier {
  // 👉 यहाँ अपने backend का URL डालो
  static const String _baseUrl = "http://192.168.1.5:5000/api/v1"; 
  // ↑ अगर तुम localhost पर चला रहे हो तो "localhost" की जगह अपना PC का IP डालना होगा
  //   ताकि मोबाइल डिवाइस पर भी API call हो सके।

  String? _authToken;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get authToken => _authToken;

  // ------------------ LOGIN ------------------
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/login"),
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data["token"];
      } else {
        throw Exception(jsonDecode(response.body)["message"] ?? "Login failed");
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ------------------ SIGNUP ------------------
  Future<void> signup(String name, String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/auth/signup"),
        body: jsonEncode({
          "name": name,
          "username": username,
          "password": password,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 201) {
        throw Exception(jsonDecode(response.body)["message"] ?? "Signup failed");
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
        throw Exception(jsonDecode(response.body)["message"] ?? "Failed to send OTP");
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

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)["message"] ?? "Invalid OTP");
      }
    } catch (e) {
      rethrow;
    }
  }
}
