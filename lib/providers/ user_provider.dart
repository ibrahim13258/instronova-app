import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Configuration file (replace with your backend IP)
class AppConfig {
  static const String baseUrl = "http://YOUR_IP:5000/api/v1/user";
}

/// UserProvider for Instagram-level app
class UserProvider with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  Map<String, dynamic>? _user;

  final SharedPreferences _prefs;

  UserProvider._(this._prefs) {
    _loadTokens();
  }

  /// Factory constructor to ensure async SharedPreferences init
  static Future<UserProvider> create() async {
    final prefs = await SharedPreferences.getInstance();
    return UserProvider._(prefs);
  }

  /// Getters
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated =>
      _token != null && (_tokenExpiry == null || _tokenExpiry!.isAfter(DateTime.now()));

  /// 🔹 Load tokens from SharedPreferences
  Future<void> _loadTokens() async {
    _token = _prefs.getString('auth_token');
    _refreshToken = _prefs.getString('refresh_token');
    final expiryString = _prefs.getString('token_expiry');
    if (expiryString != null) {
      _tokenExpiry = DateTime.tryParse(expiryString);
    }

    if (_token != null) {
      try {
        if (isAuthenticated) {
          await getUserProfile();
        } else {
          await refreshAuthToken();
        }
      } catch (_) {
        await logout();
      }
    }

    notifyListeners();
  }

  /// 🔹 Save tokens to SharedPreferences
  Future<void> _saveTokens({
    required String token,
    String? refreshToken,
    int? expiresIn,
  }) async {
    _token = token;
    _refreshToken = refreshToken;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn ?? 3600));

    await Future.wait([
      _prefs.setString('auth_token', token),
      if (refreshToken != null) _prefs.setString('refresh_token', refreshToken),
      _prefs.setString('token_expiry', _tokenExpiry!.toIso8601String()),
    ]);

    notifyListeners();
  }

  /// 🔹 Clear all tokens
  Future<void> _clearTokens() async {
    _token = null;
    _refreshToken = null;
    _tokenExpiry = null;
    _user = null;

    await Future.wait([
      _prefs.remove('auth_token'),
      _prefs.remove('refresh_token'),
      _prefs.remove('token_expiry'),
    ]);

    notifyListeners();
  }

  /// 🔹 Logout user
  Future<void> logout() async {
    await _clearTokens();
  }

  /// 🔹 Set auth token manually
  Future<void> setAuthToken(String token, {String? refreshToken, int? expiresIn}) async {
    await _saveTokens(token: token, refreshToken: refreshToken, expiresIn: expiresIn);
  }

  /// 🔹 Refresh token using backend (assumes backend provides refresh endpoint)
  Future<void> refreshAuthToken() async {
    if (_refreshToken == null) throw Exception("No refresh token available");

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/refresh-token"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveTokens(
          token: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresIn: data['expires_in'] as int?,
        );
      } else {
        await logout();
        throw Exception("Session expired. Please login again.");
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception("Failed to refresh token");
    }
  }

  /// 🔹 Parse backend errors
  String _parseError(dynamic error) {
    try {
      if (error is String) {
        final data = jsonDecode(error);
        if (data is Map && data.containsKey('message')) return data['message'];
      }
      return "An error occurred. Please try again.";
    } catch (_) {
      return "An error occurred. Please try again.";
    }
  }

  /// 🔹 Get user profile
  Future<void> getUserProfile() async {
    if (_token == null) throw Exception("Not authenticated");

    try {
      final response = await http.get(
        Uri.parse("${AppConfig.baseUrl}/profile"),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        _user = jsonDecode(response.body);
        notifyListeners();
      } else if (response.statusCode == 401) {
        await refreshAuthToken();
        await getUserProfile();
      } else {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Complete profile (bio, gender, profile pic)
  Future<void> completeProfile({
    required String bio,
    String? gender,
    File? profileImage,
  }) async {
    if (_token == null) throw Exception("Not authenticated");

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConfig.baseUrl}/complete-profile"),
      );

      request.headers['Authorization'] = 'Bearer $_token';
      request.fields['bio'] = bio;
      request.fields['gender'] = gender ?? '';

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath('profileImage', profileImage.path));
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        await getUserProfile();
      } else if (response.statusCode == 401) {
        await refreshAuthToken();
        await completeProfile(bio: bio, gender: gender, profileImage: profileImage);
      } else {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Update profile
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
        await refreshAuthToken();
        await updateProfile(updates);
      } else {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Follow user
  Future<void> followUser(String userId) async {
    await _performAction("/follow/$userId");
  }

  /// 🔹 Unfollow user
  Future<void> unfollowUser(String userId) async {
    await _performAction("/unfollow/$userId");
  }

  /// 🔹 Helper for follow/unfollow
  Future<void> _performAction(String endpoint) async {
    if (_token == null) throw Exception("Not authenticated");

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}$endpoint"),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          await refreshAuthToken();
          await _performAction(endpoint);
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
