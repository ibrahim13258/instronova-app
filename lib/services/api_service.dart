
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_endpoints.dart';

/// Centralized API service for authentication and related secure flows.
/// This is intentionally focused on auth/session/MFA/user-status so that
/// AuthProvider does not talk to http directly.
class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> _headers({String? authToken}) {
    return {
      'Content-Type': 'application/json',
      if (authToken != null && authToken.isNotEmpty) 'Authorization': 'Bearer $authToken',
    };
  }

  /// Generic helper for POST requests returning JSON.
  Future<Map<String, dynamic>> _postJson(
    String url,
    Map<String, dynamic> body, {
    String? authToken,
  }) async {
    final response = await _client.post(
      Uri.parse(url),
      headers: _headers(authToken: authToken),
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return <String, dynamic>{};
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return <String, dynamic>{'data': decoded};
    }

    throw Exception('API error ${response.statusCode}: ${response.body}');
  }

  /// Generic helper for GET requests returning JSON list/map.
  Future<dynamic> _getJson(
    String url, {
    String? authToken,
  }) async {
    final response = await _client.get(
      Uri.parse(url),
      headers: _headers(authToken: authToken),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    }

    throw Exception('API error ${response.statusCode}: ${response.body}');
  }

  /// --- Core Auth APIs ------------------------------------------------------

  Future<Map<String, dynamic>> login(
    String email,
    String password, {
    String? deviceId,
  }) async {
    return _postJson(
      ApiEndpoints.login,
      {
        'email': email,
        'password': password,
        if (deviceId != null) 'device_id': deviceId,
      },
    );
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String username,
    String password, {
    String? deviceId,
  }) async {
    return _postJson(
      ApiEndpoints.signup,
      {
        'name': name,
        'email': email,
        'username': username,
        'password': password,
        if (deviceId != null) 'device_id': deviceId,
      },
    );
  }

  Future<void> logout({
    required String authToken,
    String? deviceId,
  }) async {
    await _postJson(
      ApiEndpoints.logout,
      {
        if (deviceId != null) 'device_id': deviceId,
      },
      authToken: authToken,
    );
  }

  Future<void> logoutAllDevices({
    required String authToken,
  }) async {
    // Assumes backend supports a dedicated endpoint or interprets this flag.
    await _postJson(
      ApiEndpoints.logout,
      {
        'all_devices': true,
      },
      authToken: authToken,
    );
  }

  Future<Map<String, dynamic>> refreshToken(
    String refreshToken, {
    String? deviceId,
  }) async {
    // There is no explicit endpoint in ApiEndpoints yet, so we derive it.
    final base = ApiEndpoints.baseUrl;
    final url = '$base/auth/refresh-token';
    return _postJson(
      url,
      {
        'refresh_token': refreshToken,
        if (deviceId != null) 'device_id': deviceId,
      },
    );
  }

  /// --- Password reset / OTP / MFA -----------------------------------------

  Future<void> forgotPassword(String email) async {
    await _postJson(
      ApiEndpoints.forgotPassword,
      {
        'email': email,
      },
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    await _postJson(
      ApiEndpoints.verifyOtp,
      {
        'email': email,
        'otp': otp,
      },
    );
  }

  Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    final base = ApiEndpoints.baseUrl;
    final url = '$base/auth/reset-password';
    await _postJson(
      url,
      {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      },
    );
  }

  Future<void> sendMfaCode({
    required String email,
    required String sessionToken,
    String? deviceId,
  }) async {
    final base = ApiEndpoints.baseUrl;
    final url = '$base/auth/mfa/send-code';
    await _postJson(
      url,
      {
        'email': email,
        'mfa_session_token': sessionToken,
        if (deviceId != null) 'device_id': deviceId,
      },
    );
  }

  Future<Map<String, dynamic>> verifyMfaCode({
    required String sessionToken,
    required String code,
    String? deviceId,
  }) async {
    final base = ApiEndpoints.baseUrl;
    final url = '$base/auth/mfa/verify-code';
    return _postJson(
      url,
      {
        'mfa_session_token': sessionToken,
        'code': code,
        if (deviceId != null) 'device_id': deviceId,
      },
    );
  }

  /// --- FCM token registration ----------------------------------------------

  Future<void> registerFcmToken({
    required String authToken,
    required String fcmToken,
    String? deviceId,
  }) async {
    final base = ApiEndpoints.baseUrl;
    final url = '$base/notifications/register-fcm';
    await _postJson(
      url,
      {
        'fcm_token': fcmToken,
        if (deviceId != null) 'device_id': deviceId,
      },
      authToken: authToken,
    );
  }

  /// --- Session management across devices ----------------------------------

  Future<List<Map<String, dynamic>>> getActiveSessions({
    required String authToken,
  }) async {
    final base = ApiEndpoints.baseUrl;
    final url = '$base/auth/sessions';
    final data = await _getJson(
      url,
      authToken: authToken,
    );

    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    } else if (data is Map && data['sessions'] is List) {
      return (data['sessions'] as List).cast<Map<String, dynamic>>();
    }

    return <Map<String, dynamic>>[];
  }

  Future<void> terminateSession({
    required String authToken,
    required String sessionId,
  }) async {
    final base = ApiEndpoints.baseUrl;
    final url = '$base/auth/sessions/$sessionId/terminate';
    await _postJson(
      url,
      {},
      authToken: authToken,
    );
  }

  Future<void> terminateAllSessions({
    required String authToken,
    String? excludeDeviceId,
  }) async {
    final base = ApiEndpoints.baseUrl;
    final url = '$base/auth/sessions/terminate-all';
    await _postJson(
      url,
      {
        if (excludeDeviceId != null) 'exclude_device_id': excludeDeviceId,
      },
      authToken: authToken,
    );
  }

  /// --- Realtime-ish user status (online / last seen) ----------------------

  Future<void> subscribeToUserStatus({
    required String authToken,
    required String targetUserId,
  }) async {
    // Depending on backend, this may actually be implemented via WebSockets or FCM.
    // Here we keep it as a no-op HTTP stub so that the app compiles cleanly.
    final base = ApiEndpoints.baseUrl;
    final url = '$base/user/status/subscribe';
    await _postJson(
      url,
      {
        'user_id': targetUserId,
      },
      authToken: authToken,
    );
  }

  Future<void> unsubscribeFromUserStatus({
    required String authToken,
    required String targetUserId,
  }) async {
    final base = ApiEndpoints.baseUrl;
    final url = '$base/user/status/unsubscribe';
    await _postJson(
      url,
      {
        'user_id': targetUserId,
      },
      authToken: authToken,
    );
  }

  Future<void> updateUserStatus({
    required String authToken,
    required bool isOnline,
    required DateTime lastSeen,
  }) async {
    final base = ApiEndpoints.baseUrl;
    final url = '$base/user/status';
    await _postJson(
      url,
      {
        'is_online': isOnline,
        'last_seen': lastSeen.toUtc().toIso8601String(),
      },
      authToken: authToken,
    );
  }
}
