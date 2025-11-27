import '../services/api_service.dart';

/// Thin repository layer over [ApiService] so that higher level
/// components (like providers) depend on a single abstraction.
///
/// This also makes it easier to mock in tests.
class AuthRepository {
  final ApiService _api;

  AuthRepository({ApiService? apiService}) : _api = apiService ?? ApiService();

  ApiService get rawApi => _api;

  Future<Map<String, dynamic>> login(
    String email,
    String password, {
    String? deviceId,
  }) {
    return _api.login(email, password, deviceId: deviceId);
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String username,
    String password, {
    String? deviceId,
  }) {
    return _api.signup(name, email, username, password, deviceId: deviceId);
  }

  Future<void> logout({
    required String authToken,
    String? deviceId,
  }) {
    return _api.logout(authToken, deviceId: deviceId);
  }

  Future<void> logoutAllDevices({required String authToken}) {
    return _api.logoutAllDevices(authToken: authToken);
  }

  Future<Map<String, dynamic>> refreshToken(
    String refreshToken, {
    String? deviceId,
  }) {
    return _api.refreshToken(refreshToken, deviceId: deviceId);
  }

  Future<Map<String, dynamic>> sendMfaCode({
    required String sessionToken,
    required String channel,
  }) {
    return _api.sendMfaCode(sessionToken: sessionToken, channel: channel);
  }

  Future<Map<String, dynamic>> verifyMfaCode({
    required String sessionToken,
    required String code,
    String? deviceId,
  }) {
    return _api.verifyMfaCode(
      sessionToken: sessionToken,
      code: code,
      deviceId: deviceId,
    );
  }

  Future<Map<String, dynamic>> forgotPassword(String email) {
    return _api.forgotPassword(email);
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) {
    return _api.verifyOtp(email: email, otp: otp);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String otp,
  }) {
    return _api.resetPassword(
      email: email,
      newPassword: newPassword,
      otp: otp,
    );
  }

  Future<void> registerFcmToken({
    required String authToken,
    required String fcmToken,
    String? deviceId,
  }) {
    return _api.registerFcmToken(
      authToken: authToken,
      fcmToken: fcmToken,
      deviceId: deviceId,
    );
  }

  Future<List<Map<String, dynamic>>> getActiveSessions({
    required String authToken,
  }) {
    return _api.getActiveSessions(authToken: authToken);
  }

  Future<void> terminateSession({
    required String authToken,
    required String sessionId,
  }) {
    return _api.terminateSession(authToken: authToken, sessionId: sessionId);
  }

  Future<void> terminateAllSessions({required String authToken}) {
    return _api.terminateAllSessions(authToken: authToken);
  }

  Future<void> subscribeToUserStatus({
    required String authToken,
  }) {
    return _api.subscribeToUserStatus(authToken: authToken);
  }

  Future<void> unsubscribeFromUserStatus({
    required String authToken,
  }) {
    return _api.unsubscribeFromUserStatus(authToken: authToken);
  }

  Future<void> updateUserStatus({
    required String authToken,
    required bool isOnline,
    required DateTime lastSeen,
  }) {
    return _api.updateUserStatus(
      authToken: authToken,
      isOnline: isOnline,
      lastSeen: lastSeen,
    );
  }
}
