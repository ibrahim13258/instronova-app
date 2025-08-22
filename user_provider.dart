import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Configuration file (create a separate config.dart file)
class AppConfig {
  static const String baseUrl = "http://YOUR_IP:5000/api/v1/user";
}

class UserProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;
  final SharedPreferences _prefs;

  UserProvider(this._prefs) {
    _loadToken(); // Auto load token when provider is initialized
  }

  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null;

  /// 🔹 Load token from SharedPreferences
  Future<void> _loadToken() async {
    _token = _prefs.getString('auth_token');
    if (_token != null) {
      try {
        await getUserProfile(); // Load user profile if token exists
      } catch (e) {
        // Token might be expired, clear it
        await _clearToken();
      }
    }
    notifyListeners();
  }

  /// 🔹 Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    _token = token;
    await _prefs.setString('auth_token', token);
    notifyListeners();
  }

  /// 🔹 Clear token from memory and SharedPreferences
  Future<void> _clearToken() async {
    _token = null;
    _user = null;
    await _prefs.remove('auth_token');
    notifyListeners();
  }

  /// 🔹 Logout user
  Future<void> logout() async {
    await _clearToken();
  }

  /// 🔹 Set authentication token
  Future<void> setAuthToken(String token) async {
    await _saveToken(token);
  }

  /// 🔹 Handle API errors
  String _parseError(dynamic error) {
    try {
      if (error is String) {
        final errorData = jsonDecode(error);
        if (errorData is Map && errorData.containsKey('message')) {
          return errorData['message'];
        }
      }
      return "An error occurred. Please try again.";
    } catch (e) {
      return "An error occurred. Please try again.";
    }
  }

  /// 🔹 Get User Profile from Backend
  Future<void> getUserProfile() async {
    if (_token == null) throw Exception("Not authenticated");

    try {
      final response = await http.get(
        Uri.parse("${AppConfig.baseUrl}/profile"),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        _user = jsonDecode(response.body);
        notifyListeners();
      } else if (response.statusCode == 401) {
        // Token expired
        await logout();
        throw Exception("Session expired. Please login again.");
      } else {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Complete Profile (Bio, Gender, Profile Pic)
  Future<void> completeProfile({
    required String bio,
    required String? gender,
    File? profileImage,
  }) async {
    if (_token == null) throw Exception("Not authenticated");

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConfig.baseUrl}/complete-profile"),
      );

      request.headers['Authorization'] = 'Bearer $_token';
      request.fields['bio'] = bio;
      request.fields['gender'] = gender ?? '';

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          profileImage.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        await getUserProfile(); // refresh profile
      } else if (response.statusCode == 401) {
        await logout();
        throw Exception("Session expired. Please login again.");
      } else {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Update Profile (For future use)
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_token == null) throw Exception("Not authenticated");

    try {
      final response = await http.put(
        Uri.parse("${AppConfig.baseUrl}/update"),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200) {
        await getUserProfile();
      } else if (response.statusCode == 401) {
        await logout();
        throw Exception("Session expired. Please login again.");
      } else {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Follow User
  Future<void> followUser(String userId) async {
    if (_token == null) throw Exception("Not authenticated");

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/follow/$userId"),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          await logout();
          throw Exception("Session expired. Please login again.");
        } else {
          throw Exception(_parseError(response.body));
        }
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Unfollow User
  Future<void> unfollowUser(String userId) async {
    if (_token == null) throw Exception("Not authenticated");

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/unfollow/$userId"),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          await logout();
          throw Exception("Session expired. Please login again.");
        } else {
          throw Exception(_parseError(response.body));
        }
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }
}
