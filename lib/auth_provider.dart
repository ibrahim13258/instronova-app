import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  final UserProvider _userProvider;
  final FlutterSecureStorage _secureStorage;
  
  bool _isLoading = false;
  String? _authToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  AuthProvider({
    required ApiService apiService,
    required UserProvider userProvider,
    required FlutterSecureStorage secureStorage,
  }) : _apiService = apiService,
       _userProvider = userProvider,
       _secureStorage = secureStorage {
    _loadAuthTokens(); // Auto-load tokens when provider initializes
  }

  bool get isLoading => _isLoading;
  String? get authToken => _authToken;
  bool get isAuthenticated => _authToken != null && 
                           (_tokenExpiry == null || _tokenExpiry!.isAfter(DateTime.now()));

  /// Initializes provider with required dependencies
  static Future<AuthProvider> create({
    required UserProvider userProvider,
  }) async {
    final secureStorage = const FlutterSecureStorage();
    final apiService = ApiService();
    return AuthProvider(
      apiService: apiService,
      userProvider: userProvider,
      secureStorage: secureStorage,
    );
  }

  /// Loads tokens from secure storage and validates expiry
  Future<void> _loadAuthTokens() async {
    try {
      _authToken = await _secureStorage.read(key: 'auth_token');
      _refreshToken = await _secureStorage.read(key: 'refresh_token');
      final expiryString = await _secureStorage.read(key: 'token_expiry');
      
      if (expiryString != null) {
        _tokenExpiry = DateTime.tryParse(expiryString);
      }

      if (_authToken != null && _userProvider.authToken != _authToken) {
        await _userProvider.setAuthToken(_authToken!);
        if (isAuthenticated) {
          await _userProvider.getUserProfile();
        } else {
          await getValidToken(); // Attempt to refresh if expired
        }
      }
    } catch (e) {
      await _clearAuthTokens();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  /// Saves tokens to secure storage with proper error handling
  Future<void> _saveAuthTokens({
    required String token,
    String? refreshToken,
    int? expiresIn,
  }) async {
    try {
      _authToken = token;
      _refreshToken = refreshToken;
      _tokenExpiry = DateTime.now().add(Duration(
        seconds: expiresIn ?? 3600, // Default 1 hour if not provided
      ));

      await Future.wait([
        _secureStorage.write(key: 'auth_token', value: token),
        if (refreshToken != null)
          _secureStorage.write(key: 'refresh_token', value: refreshToken),
        _secureStorage.write(
          key: 'token_expiry', 
          value: _tokenExpiry!.toIso8601String(),
        ),
      ]);
    } catch (e) {
      await _clearAuthTokens();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  /// Clears all authentication data
  Future<void> _clearAuthTokens() async {
    try {
      _authToken = null;
      _refreshToken = null;
      _tokenExpiry = null;
      
      await Future.wait([
        _secureStorage.delete(key: 'auth_token'),
        _secureStorage.delete(key: 'refresh_token'),
        _secureStorage.delete(key: 'token_expiry'),
      ]);
    } finally {
      notifyListeners();
    }
  }

  /// Refreshes the auth token using refresh token
  Future<String> _refreshAuthToken() async {
    if (_refreshToken == null) {
      throw Exception('No refresh token available');
    }
    
    try {
      final response = await _apiService.refreshToken(_refreshToken!);
      await _saveAuthTokens(
        token: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresIn: response['expires_in'] as int?,
      );
      return response['access_token'];
    } catch (e) {
      await _clearAuthTokens();
      throw Exception('Session expired. Please login again.');
    }
  }

  /// Returns valid token, refreshing if expired
  Future<String> getValidToken() async {
    if (_authToken == null) {
      throw Exception('Not authenticated');
    }
    
    if (_tokenExpiry == null || _tokenExpiry!.isBefore(DateTime.now())) {
      final newToken = await _refreshAuthToken();
      return newToken;
    }
    
    return _authToken!;
  }

  /// Parses various error types into user-friendly messages
  String parseError(dynamic error) {
    if (error is String) {
      try {
        final errorJson = jsonDecode(error);
        if (errorJson is Map) {
          return errorJson['message']?.toString() ?? 
                 errorJson['error']?.toString() ?? 
                 'An error occurred';
        }
      } catch (_) {
        return error;
      }
    }
    
    final errorStr = error.toString();
    
    if (errorStr.contains('SocketException')) {
      return 'No internet connection';
    } else if (errorStr.contains('401')) {
      return 'Session expired. Please login again';
    } else if (errorStr.contains('403')) {
      return 'Access denied';
    } else if (errorStr.contains('500')) {
      return 'Server error. Please try again later';
    } else if (errorStr.contains('timeout')) {
      return 'Request timeout. Please try again';
    }
    
    return 'An error occurred. Please try again';
  }

  /// Authenticates user with email and password
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _apiService.login(email, password);
      
      await _saveAuthTokens(
        token: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresIn: response['expires_in'] as int?,
      );
      
      await _userProvider.setAuthToken(response['access_token']);
      await _userProvider.getUserProfile();
      
    } catch (e) {
      await _clearAuthTokens();
      throw parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Registers new user account
  Future<void> signup(String name, String email, String username, String password) async {
    _setLoading(true);
    try {
      final response = await _apiService.signup(name, email, username, password);
      
      await _saveAuthTokens(
        token: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresIn: response['expires_in'] as int?,
      );
      
      await _userProvider.setAuthToken(response['access_token']);
      await _userProvider.getUserProfile();
      
    } catch (e) {
      await _clearAuthTokens();
      throw parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Initiates password reset process
  Future<void> forgotPassword(String email) async {
    _setLoading(true);
    try {
      await _apiService.forgotPassword(email);
    } catch (e) {
      throw parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Verifies OTP for password reset
  Future<void> verifyOtp(String email, String otp) async {
    _setLoading(true);
    try {
      await _apiService.verifyOtp(email, otp);
    } catch (e) {
      throw parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Resets user password with new one
  Future<void> resetPassword(String email, String otp, String newPassword) async {
    _setLoading(true);
    try {
      await _apiService.resetPassword(email, otp, newPassword);
    } catch (e) {
      throw parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Clears all authentication data and user state
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _clearAuthTokens();
      await _userProvider.logout();
    } catch (e) {
      throw parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Updates loading state and notifies listeners
  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
