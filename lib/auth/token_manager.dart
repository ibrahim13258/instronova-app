import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Handles persistence of auth tokens and MFA session in secure storage.
/// In‑memory state (current token, expiry, flags) is owned by AuthProvider;
/// this class is only responsible for reading/writing from storage.
class TokenManager {
  final FlutterSecureStorage secureStorage;

  const TokenManager({required this.secureStorage});

  /// Save tokens to secure storage. Does NOT manage in‑memory state.
  Future<void> saveTokens({
    required String token,
    String? refreshToken,
    DateTime? expiry,
  }) async {
    await Future.wait([
      secureStorage.write(key: 'auth_token', value: token),
      if (refreshToken != null)
        secureStorage.write(key: 'refresh_token', value: refreshToken),
      if (expiry != null)
        secureStorage.write(
          key: 'token_expiry',
          value: expiry.toIso8601String(),
        ),
    ]);
  }

  /// Clear all persisted auth‑related data (tokens + MFA session).
  Future<void> clearTokensAndMfa() async {
    await Future.wait([
      secureStorage.delete(key: 'auth_token'),
      secureStorage.delete(key: 'refresh_token'),
      secureStorage.delete(key: 'token_expiry'),
      secureStorage.delete(key: 'mfa_session'),
    ]);
  }

  /// Load tokens from storage. Returns a map which may contain:
  ///   authToken, refreshToken, tokenExpiry (DateTime?)
  Future<Map<String, dynamic>> loadTokens() async {
    final authToken = await secureStorage.read(key: 'auth_token');
    final refreshToken = await secureStorage.read(key: 'refresh_token');
    final expiryString = await secureStorage.read(key: 'token_expiry');

    DateTime? expiry;
    if (expiryString != null) {
      expiry = DateTime.tryParse(expiryString);
    }

    return <String, dynamic>{
      'authToken': authToken,
      'refreshToken': refreshToken,
      'tokenExpiry': expiry,
    };
  }

  /// Persist MFA session token if needed.
  Future<void> saveMfaSession(String? sessionToken) async {
    if (sessionToken == null) {
      await secureStorage.delete(key: 'mfa_session');
    } else {
      await secureStorage.write(key: 'mfa_session', value: sessionToken);
    }
  }

  Future<String?> loadMfaSession() async {
    return secureStorage.read(key: 'mfa_session');
  }
}
