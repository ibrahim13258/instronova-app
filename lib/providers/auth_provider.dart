import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  final UserProvider _userProvider;
  final FlutterSecureStorage _secureStorage;
  final FirebaseMessaging _firebaseMessaging;
  
  bool _isLoading = false;
  bool _isMfaRequired = false;
  bool _isMfaVerifying = false;
  String? _mfaSessionToken;
  String? _authToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  String? _currentDeviceId;
  Timer? _statusUpdateTimer;
  Timer? _tokenRefreshTimer;
  StreamSubscription? _fcmSubscription;
  Map<String, bool> _userOnlineStatus = {};

  // Multi-factor authentication state
  String? _mfaEmail;
  DateTime? _mfaCodeExpiry;
  int _mfaResendCooldown = 0;
  Timer? _mfaCooldownTimer;

  AuthProvider({
    required ApiService apiService,
    required UserProvider userProvider,
    required FlutterSecureStorage secureStorage,
    required FirebaseMessaging firebaseMessaging,
  }) : _apiService = apiService,
       _userProvider = userProvider,
       _secureStorage = secureStorage,
       _firebaseMessaging = firebaseMessaging {
    _initializeAuth();
  }

  bool get isLoading => _isLoading;
  bool get isMfaRequired => _isMfaRequired;
  bool get isMfaVerifying => _isMfaVerifying;
  String? get authToken => _authToken;
  int get mfaResendCooldown => _mfaResendCooldown;
  bool get isAuthenticated => _authToken != null && 
                           (_tokenExpiry == null || _tokenExpiry!.isAfter(DateTime.now()));

  /// Get online status for a specific user
  bool isUserOnline(String userId) => _userOnlineStatus[userId] ?? false;

  /// Initializes provider with required dependencies
  static Future<AuthProvider> create({
    required UserProvider userProvider,
  }) async {
    final secureStorage = const FlutterSecureStorage();
    final apiService = ApiService();
    final firebaseMessaging = FirebaseMessaging.instance;
    
    // Request notification permissions
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    
    return AuthProvider(
      apiService: apiService,
      userProvider: userProvider,
      secureStorage: secureStorage,
      firebaseMessaging: firebaseMessaging,
    );
  }

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    try {
      // Generate unique device ID
      _currentDeviceId = await _secureStorage.read(key: 'device_id') ?? 
          'device_${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().hashCode}';
      await _secureStorage.write(key: 'device_id', value: _currentDeviceId!);

      await _loadAuthTokens();
      _setupFcmListeners();
    } catch (e) {
      print('Auth initialization error: $e');
    }
  }

  /// Setup FCM listeners for authentication events
  void _setupFcmListeners() {
    _fcmSubscription?.cancel();
    _fcmSubscription = _firebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handlePushNotification(message);
    });
  }

  /// Handle authentication-related push notifications
  void _handlePushNotification(RemoteMessage message) {
    final data = message.data;
    final type = data['type'];
    
    switch (type) {
      case 'new_device_login':
        _handleNewDeviceLogin(data);
        break;
      case 'suspicious_activity':
        _handleSuspiciousActivity(data);
        break;
      case 'mfa_code':
        _handleMfaCodeNotification(data);
        break;
      case 'user_status_change':
        _handleUserStatusChange(data);
        break;
    }
  }

  void _handleNewDeviceLogin(Map<String, dynamic> data) {
    // Show notification about new device login
    // This would typically be handled by a notification service
    print('New device login detected: ${data['deviceInfo']}');
  }

  void _handleSuspiciousActivity(Map<String, dynamic> data) {
    // Handle suspicious activity notification
    print('Suspicious activity: ${data['activity']}');
  }

  void _handleMfaCodeNotification(Map<String, dynamic> data) {
    // MFA code received via push notification
    final code = data['code'];
    print('MFA code received: $code');
  }

  void _handleUserStatusChange(Map<String, dynamic> data) {
    final userId = data['userId'];
    final isOnline = data['isOnline'] == true;
    _userOnlineStatus[userId] = isOnline;
    notifyListeners();
  }

  /// Start periodic status updates to backend
  void _startStatusUpdates() {
    _statusUpdateTimer?.cancel();
    _statusUpdateTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (isAuthenticated) {
        await _updateOnlineStatus(true);
      }
    });
  }

  /// Stop status updates
  void _stopStatusUpdates() {
    _statusUpdateTimer?.cancel();
    _statusUpdateTimer = null;
  }

  /// Update user's online status on backend
  Future<void> _updateOnlineStatus(bool isOnline) async {
    try {
      await _apiService.updateUserStatus(
        authToken: await getValidToken(),
        isOnline: isOnline,
        lastSeen: DateTime.now(),
      );
    } catch (e) {
      print('Failed to update online status: $e');
    }
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
          _startStatusUpdates();
          _startTokenRefreshTimer();
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

  /// Start token refresh timer
  void _startTokenRefreshTimer() {
    _tokenRefreshTimer?.cancel();
    if (_tokenExpiry != null) {
      final refreshTime = _tokenExpiry!.subtract(Duration(minutes: 5));
      final delay = refreshTime.difference(DateTime.now());
      
      if (delay.inSeconds > 0) {
        _tokenRefreshTimer = Timer(delay, () async {
          try {
            await getValidToken();
          } catch (e) {
            print('Token refresh failed: $e');
          }
        });
      }
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

      _startTokenRefreshTimer();
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
      _isMfaRequired = false;
      _mfaSessionToken = null;
      
      _stopStatusUpdates();
      _tokenRefreshTimer?.cancel();
      
      await Future.wait([
        _secureStorage.delete(key: 'auth_token'),
        _secureStorage.delete(key: 'refresh_token'),
        _secureStorage.delete(key: 'token_expiry'),
        _secureStorage.delete(key: 'mfa_session'),
      ]);
    } finally {
      notifyListeners();
    }
  }

  /// Refreshes the auth token using refresh token with rotation
  Future<String> _refreshAuthToken() async {
    if (_refreshToken == null) {
      throw Exception('No refresh token available');
    }
    
    try {
      final response = await _apiService.refreshToken(
        _refreshToken!,
        deviceId: _currentDeviceId,
      );
      
      // Rotate refresh token - use new one, invalidate old one
      await _saveAuthTokens(
        token: response['access_token'],
        refreshToken: response['refresh_token'], // New refresh token
        expiresIn: response['expires_in'] as int?,
      );
      
      return response['access_token'];
    } catch (e) {
      // If refresh fails, clear tokens and require re-authentication
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

  /// Send MFA code to user
  Future<void> sendMfaCode() async {
    if (_mfaEmail == null || _mfaSessionToken == null) {
      throw Exception('MFA session not initialized');
    }

    _setMfaVerifying(true);
    try {
      await _apiService.sendMfaCode(
        email: _mfaEmail!,
        sessionToken: _mfaSessionToken!,
        deviceId: _currentDeviceId,
      );
      
      // Set cooldown timer
      _mfaResendCooldown = 60; // 60 seconds cooldown
      _mfaCooldownTimer?.cancel();
      _mfaCooldownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_mfaResendCooldown > 0) {
          _mfaResendCooldown--;
          notifyListeners();
        } else {
          timer.cancel();
        }
      });
      
      _mfaCodeExpiry = DateTime.now().add(Duration(minutes: 10));
    } catch (e) {
      // TODO: Replace with user-friendly error handling
      throw parseError(e);
    } finally {
      _setMfaVerifying(false);
    }
  }

  /// Verify MFA code
  Future<void> verifyMfaCode(String code) async {
    if (_mfaSessionToken == null) {
      throw Exception('MFA session not initialized');
    }

    _setMfaVerifying(true);
    try {
      final response = await _apiService.verifyMfaCode(
        sessionToken: _mfaSessionToken!,
        code: code,
        deviceId: _currentDeviceId,
      );
      
      // MFA successful, save tokens and complete authentication
      await _saveAuthTokens(
        token: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresIn: response['expires_in'] as int?,
      );
      
      await _userProvider.setAuthToken(response['access_token']);
      await _userProvider.getUserProfile();
      
      // Register FCM token for push notifications
      await _registerFcmToken();
      
      _isMfaRequired = false;
      _mfaSessionToken = null;
      _startStatusUpdates();
      
    } catch (e) {
      // TODO: Replace with user-friendly error handling
      throw parseError(e);
    } finally {
      _setMfaVerifying(false);
    }
  }

  /// Register FCM token for push notifications
  Future<void> _registerFcmToken() async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        await _apiService.registerFcmToken(
          authToken: await getValidToken(),
          fcmToken: fcmToken,
          deviceId: _currentDeviceId,
        );
      }
    } catch (e) {
      print('Failed to register FCM token: $e');
    }
  }

  /// Get active sessions across devices
  Future<List<Map<String, dynamic>>> getActiveSessions() async {
    try {
      return await _apiService.getActiveSessions(
        authToken: await getValidToken(),
      );
    } catch (e) {
      // TODO: Replace with user-friendly error handling
      throw parseError(e);
    }
  }

  /// Terminate session on specific device
  Future<void> terminateSession(String sessionId) async {
    try {
      await _apiService.terminateSession(
        authToken: await getValidToken(),
        sessionId: sessionId,
      );
    } catch (e) {
      // TODO: Replace with user-friendly error handling
      throw parseError(e);
    }
  }

  /// Terminate all sessions except current
  Future<void> terminateAllOtherSessions() async {
    try {
      await _apiService.terminateAllSessions(
        authToken: await getValidToken(),
        excludeDeviceId: _currentDeviceId,
      );
    } catch (e) {
      // TODO: Replace with user-friendly error handling
      throw parseError(e);
    }
  }

  /// Subscribe to user status changes
  Future<void> subscribeToUserStatus(String userId) async {
    try {
      await _apiService.subscribeToUserStatus(
        authToken: await getValidToken(),
        targetUserId: userId,
      );
    } catch (e) {
      print('Failed to subscribe to user status: $e');
    }
  }

  /// Unsubscribe from user status changes
  Future<void> unsubscribeFromUserStatus(String userId) async {
    try {
      await _apiService.unsubscribeFromUserStatus(
        authToken: await getValidToken(),
        targetUserId: userId,
      );
    } catch (e) {
      print('Failed to unsubscribe from user status: $e');
    }
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
    } else if (errorStr.contains('mfa_required')) {
      return 'Multi-factor authentication required';
    } else if (errorStr.contains('mfa_invalid')) {
      return 'Invalid verification code';
    } else if (errorStr.contains('mfa_expired')) {
      return 'Verification code expired';
    }
    
    return 'An error occurred. Please try again';
  }

  /// Authenticates user with email and password
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await _apiService.login(
        email, 
        password,
        deviceId: _currentDeviceId,
      );
      
      // Check if MFA is required
      if (response['mfa_required'] == true) {
        _isMfaRequired = true;
        _mfaSessionToken = response['mfa_session_token'];
        _mfaEmail = email;
        await _secureStorage.write(key: 'mfa_session', value: _mfaSessionToken!);
        notifyListeners();
        return;
      }
      
      // No MFA required, proceed with normal login
      await _saveAuthTokens(
        token: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresIn: response['expires_in'] as int?,
      );
      
      await _userProvider.setAuthToken(response['access_token']);
      await _userProvider.getUserProfile();
      
      // Register FCM token for push notifications
      await _registerFcmToken();
      _startStatusUpdates();
      
    } catch (e) {
      await _clearAuthTokens();
      // TODO: Replace with user-friendly error handling
      throw parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Registers new user account
  Future<void> signup(String name, String email, String username, String password) async {
    _setLoading(true);
    try {
      final response = await _apiService.signup(
        name, 
        email, 
        username, 
        password,
        deviceId: _currentDeviceId,
      );
      
      await _saveAuthTokens(
        token: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresIn: response['expires_in'] as int?,
      );
      
      await _userProvider.setAuthToken(response['access_token']);
      await _userProvider.getUserProfile();
      
      // Register FCM token for push notifications
      await _registerFcmToken();
      _startStatusUpdates();
      
    } catch (e) {
      await _clearAuthTokens();
      // TODO: Replace with user-friendly error handling
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
      // TODO: Replace with user-friendly error handling
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
      // TODO: Replace with user-friendly error handling
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
      // TODO: Replace with user-friendly error handling
      throw parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Clears all authentication data and user state with server invalidation
  Future<void> logout({bool fromAllDevices = false}) async {
    _setLoading(true);
    try {
      if (isAuthenticated) {
        try {
          if (fromAllDevices) {
            await _apiService.logoutAllDevices(authToken: await getValidToken());
          } else {
            await _apiService.logout(
              authToken: await getValidToken(),
              deviceId: _currentDeviceId,
            );
          }
        } catch (e) {
          print('Server logout failed: $e');
          // Continue with local logout even if server call fails
        }
      }
      
      await _clearAuthTokens();
      await _userProvider.logout();
      _stopStatusUpdates();
      
    } catch (e) {
      // TODO: Replace with user-friendly error handling
      throw parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  /// Cancel MFA process and return to login
  Future<void> cancelMfa() async {
    _isMfaRequired = false;
    _mfaSessionToken = null;
    _mfaEmail = null;
    _mfaCooldownTimer?.cancel();
    _mfaResendCooldown = 0;
    await _secureStorage.delete(key: 'mfa_session');
    notifyListeners();
  }

  /// Updates loading state and notifies listeners
  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  /// Updates MFA verifying state
  void _setMfaVerifying(bool value) {
    if (_isMfaVerifying != value) {
      _isMfaVerifying = value;
      notifyListeners();
    }
  }

  /// Clean up resources
  @override
  void dispose() {
    _statusUpdateTimer?.cancel();
    _tokenRefreshTimer?.cancel();
    _mfaCooldownTimer?.cancel();
    _fcmSubscription?.cancel();
    super.dispose();
  }
}
