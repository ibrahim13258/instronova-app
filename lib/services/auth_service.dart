import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Configuration
class AppConfig {
  static const String baseUrl = "http://YOUR_IP:5000/api/v1/auth";
}

/// AuthService for Instagram-level app
class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  /// Getters
  String? get accessToken => _accessToken;
  bool get isAuthenticated =>
      _accessToken != null &&
      (_tokenExpiry == null || _tokenExpiry!.isAfter(DateTime.now()));

  AuthService() {
    _loadTokens();
  }

  /// Load tokens from secure storage
  Future<void> _loadTokens() async {
    _accessToken = await _secureStorage.read(key: 'auth_token');
    _refreshToken = await _secureStorage.read(key: 'refresh_token');
    final expiryString = await _secureStorage.read(key: 'token_expiry');
    if (expiryString != null) _tokenExpiry = DateTime.tryParse(expiryString);

    if (_accessToken != null && !isAuthenticated && _refreshToken != null) {
      await refreshToken();
    }
  }

  /// Save tokens to secure storage
  Future<void> _saveTokens({
    required String token,
    String? refreshToken,
    int? expiresIn,
  }) async {
    _accessToken = token;
    _refreshToken = refreshToken ?? _refreshToken;
    _tokenExpiry =
        DateTime.now().add(Duration(seconds: expiresIn ?? 3600));

    await Future.wait([
      _secureStorage.write(key: 'auth_token', value: _accessToken),
      if (_refreshToken != null)
        _secureStorage.write(key: 'refresh_token', value: _refreshToken),
      _secureStorage.write(
          key: 'token_expiry', value: _tokenExpiry!.toIso8601String()),
    ]);
  }

  /// Clear tokens (logout)
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    await Future.wait([
      _secureStorage.delete(key: 'auth_token'),
      _secureStorage.delete(key: 'refresh_token'),
      _secureStorage.delete(key: 'token_expiry'),
    ]);
  }

  /// Login with Email & Password
  Future<void> loginWithEmail(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveTokens(
          token: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresIn: data['expires_in'] as int?,
        );
      } else {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    }
  }

  /// Login with Phone & OTP
  Future<void> loginWithPhone(String phone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/login-phone"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveTokens(
          token: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresIn: data['expires_in'] as int?,
        );
      } else {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    }
  }

  /// Refresh access token
  Future<void> refreshToken() async {
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
    }
  }

  /// Biometric authentication placeholder
  Future<bool> loginWithBiometrics() async {
    // Implement actual biometric logic using local_auth package
    // Return true if authentication successful, false otherwise
    return false;
  }

  /// Parse backend errors
  String _parseError(dynamic error) {
    try {
      final data = jsonDecode(error);
      if (data is Map && data.containsKey('message')) return data['message'];
      return "An error occurred. Please try again.";
    } catch (_) {
      return "An error occurred. Please try again.";
    }
  }
}
