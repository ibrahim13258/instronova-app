import '../config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:workmanager/workmanager.dart';

/// Configuration file
class AppConfig {
  static const String baseUrl = "AppConfig.baseUrl/api/v1/user";
  static const String wsUrl = "ws://YOUR_IP:5000/ws";
  static const int maxLoginAttempts = 5;
  static const Duration loginAttemptWindow = Duration(minutes: 15);
}

/// UserProvider for Instagram-level app
class UserProvider with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  Map<String, dynamic>? _user;
  bool _isOnline = false;
  bool _mfaRequired = false;
  String? _mfaSessionId;
  int _loginAttempts = 0;
  DateTime? _lastLoginAttempt;
  WebSocket? _statusWebSocket;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final SharedPreferences _prefs;

  UserProvider._(this._prefs) {
    _loadTokens();
    _initSecurityFeatures();
  }

  /// Factory constructor to ensure async SharedPreferences init
  static Future<UserProvider> create() async {
    final prefs = await SharedPreferences.getInstance();
    return UserProvider._(prefs);
  }

  /// Getters
  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _token != null && 
      (_tokenExpiry == null || _tokenExpiry!.isAfter(DateTime.now()));
  bool get isOnline => _isOnline;
  bool get mfaRequired => _mfaRequired;
  String? get mfaSessionId => _mfaSessionId;

  /// 🔹 Initialize security features
  Future<void> _initSecurityFeatures() async {
    await _setupPushNotifications();
    _setupConnectivityMonitoring();
    _setupBackgroundTasks();
    _loadLoginAttempts();
  }

  /// 🔹 Setup push notifications for security alerts
  Future<void> _setupPushNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    
    if (fcmToken != null && isAuthenticated) {
      // Register FCM token with backend for security notifications
      await _registerFcmToken(fcmToken);
    }

    // Handle background messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle security notifications (new login, suspicious activity)
      _handleSecurityNotification(message.data);
    });
  }

  /// 🔹 Setup connectivity monitoring for online status
  void _setupConnectivityMonitoring() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none && isAuthenticated) {
        _connectWebSocket();
      } else {
        _disconnectWebSocket();
        _updateOnlineStatus(false);
      }
    });
  }

  /// 🔹 Setup background tasks for token refresh and security
  void _setupBackgroundTasks() {
    Workmanager().initialize(
      _backgroundTaskCallback,
      isInDebugMode: false,
    );
    
    // Schedule periodic token check
    Workmanager().registerPeriodicTask(
      "tokenRefresh",
      "tokenRefreshTask",
      frequency: const Duration(hours: 1),
    );
  }

  /// 🔹 Background task callback
  static Future<void> _backgroundTaskCallback() async {
    // Handle token refresh and security checks in background
  }

  /// 🔹 Load tokens and security data from SharedPreferences
  Future<void> _loadTokens() async {
    _token = _prefs.getString('auth_token');
    _refreshToken = _prefs.getString('refresh_token');
    _mfaSessionId = _prefs.getString('mfa_session_id');
    _mfaRequired = _prefs.getBool('mfa_required') ?? false;
    
    final expiryString = _prefs.getString('token_expiry');
    if (expiryString != null) {
      _tokenExpiry = DateTime.tryParse(expiryString);
    }

    if (_token != null) {
      try {
        if (isAuthenticated) {
          await getUserProfile();
          _connectWebSocket();
        } else {
          await refreshAuthToken();
        }
      } catch (_) {
        await logout();
      }
    }

    notifyListeners();
  }

  /// 🔹 Load login attempts history
  Future<void> _loadLoginAttempts() async {
    _loginAttempts = _prefs.getInt('login_attempts') ?? 0;
    final lastAttemptString = _prefs.getString('last_login_attempt');
    if (lastAttemptString != null) {
      _lastLoginAttempt = DateTime.tryParse(lastAttemptString);
    }
    
    // Reset attempts if outside the time window
    if (_lastLoginAttempt != null && 
        DateTime.now().difference(_lastLoginAttempt!) > AppConfig.loginAttemptWindow) {
      _loginAttempts = 0;
      await _prefs.setInt('login_attempts', 0);
    }
  }

  /// 🔹 Save tokens to SharedPreferences
  Future<void> _saveTokens({
    required String token,
    String? refreshToken,
    int? expiresIn,
    String? mfaSessionId,
    bool? mfaRequired,
  }) async {
    _token = token;
    _refreshToken = refreshToken;
    _mfaSessionId = mfaSessionId;
    _mfaRequired = mfaRequired ?? false;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn ?? 3600));

    await Future.wait([
      _prefs.setString('auth_token', token),
      if (refreshToken != null) _prefs.setString('refresh_token', refreshToken),
      if (mfaSessionId != null) _prefs.setString('mfa_session_id', mfaSessionId),
      _prefs.setBool('mfa_required', _mfaRequired),
      _prefs.setString('token_expiry', _tokenExpiry!.toIso8601String()),
    ]);

    notifyListeners();
  }

  /// 🔹 Clear all tokens and security data
  Future<void> _clearTokens() async {
    _token = null;
    _refreshToken = null;
    _tokenExpiry = null;
    _user = null;
    _mfaRequired = false;
    _mfaSessionId = null;
    _disconnectWebSocket();
    _updateOnlineStatus(false);

    await Future.wait([
      _prefs.remove('auth_token'),
      _prefs.remove('refresh_token'),
      _prefs.remove('token_expiry'),
      _prefs.remove('mfa_session_id'),
      _prefs.remove('mfa_required'),
    ]);

    notifyListeners();
  }

  /// 🔹 Connect WebSocket for real-time status updates
  Future<void> _connectWebSocket() async {
    if (_token == null || _statusWebSocket != null) return;

    try {
      final ws = await WebSocket.connect('${AppConfig.wsUrl}?token=$_token');
      _statusWebSocket = ws;

      ws.listen(
        (data) {
          final message = jsonDecode(data);
          _handleWebSocketMessage(message);
        },
        onDone: () {
          _statusWebSocket = null;
          _updateOnlineStatus(false);
        },
        onError: (error) {
          _statusWebSocket = null;
          _updateOnlineStatus(false);
        }
      );

      // Send initial status update
      _updateOnlineStatus(true);
    } catch (e) {
      debugPrint('WebSocket connection failed: $e');
    }
  }

  /// 🔹 Disconnect WebSocket
  void _disconnectWebSocket() {
    _statusWebSocket?.close();
    _statusWebSocket = null;
  }

  /// 🔹 Handle WebSocket messages
  void _handleWebSocketMessage(Map<String, dynamic> message) {
    final type = message['type'];
    switch (type) {
      case 'status_update':
        _handleStatusUpdate(message);
        break;
      case 'security_alert':
        _handleSecurityAlert(message);
        break;
      case 'session_revoked':
        _handleSessionRevocation(message);
        break;
    }
  }

  /// 🔹 Update online status
  void _updateOnlineStatus(bool online) {
    if (_isOnline != online) {
      _isOnline = online;
      
      // Send status update to server
      if (_statusWebSocket != null && _statusWebSocket!.readyState == WebSocket.open) {
        _statusWebSocket!.add(jsonEncode({
          'type': 'status_update',
          'isOnline': online,
          'timestamp': DateTime.now().toIso8601String(),
        }));
      }
      
      notifyListeners();
    }
  }

  /// 🔹 Handle status updates from server
  void _handleStatusUpdate(Map<String, dynamic> message) {
    // Handle other users' status updates if needed
  }

  /// 🔹 Handle security alerts
  void _handleSecurityAlert(Map<String, dynamic> message) {
    final alertType = message['alertType'];
    final details = message['details'];
    
    // Show security notification to user
    _showSecurityNotification(alertType, details);
  }

  /// 🔹 Handle session revocation
  void _handleSessionRevocation(Map<String, dynamic> message) {
    // Log user out if session was revoked
    logout();
  }

  /// 🔹 Show security notification
  void _showSecurityNotification(String alertType, dynamic details) {
    // Implement notification display logic
    debugPrint('Security alert: $alertType - $details');
  }

  /// 🔹 Handle security notifications from FCM
  void _handleSecurityNotification(Map<String, dynamic> data) {
    final type = data['type'];
    switch (type) {
      case 'new_login':
        _handleNewLoginNotification(data);
        break;
      case 'suspicious_activity':
        _handleSuspiciousActivityNotification(data);
        break;
      case 'mfa_required':
        _handleMfaRequiredNotification(data);
        break;
    }
  }

  /// 🔹 Handle new login notification
  void _handleNewLoginNotification(Map<String, dynamic> data) {
    final deviceInfo = data['device'];
    final location = data['location'];
    final timestamp = data['timestamp'];
    
    // Show alert to user about new login
    _showSecurityNotification('new_login', {
      'device': deviceInfo,
      'location': location,
      'timestamp': timestamp,
    });
  }

  /// 🔹 Handle suspicious activity notification
  void _handleSuspiciousActivityNotification(Map<String, dynamic> data) {
    final activityType = data['activityType'];
    final details = data['details'];
    
    _showSecurityNotification('suspicious_activity', {
      'type': activityType,
      'details': details,
    });
  }

  /// 🔹 Handle MFA required notification
  void _handleMfaRequiredNotification(Map<String, dynamic> data) {
    _mfaRequired = true;
    notifyListeners();
  }

  /// 🔹 Register FCM token with backend
  Future<void> _registerFcmToken(String fcmToken) async {
    try {
      await http.post(
        Uri.parse("${AppConfig.baseUrl}/register-fcm"),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );
    } catch (e) {
      debugPrint('Failed to register FCM token: $e');
    }
  }

  /// 🔹 Track login attempt
  Future<void> _trackLoginAttempt(bool success) async {
    if (!success) {
      _loginAttempts++;
      _lastLoginAttempt = DateTime.now();
      
      await Future.wait([
        _prefs.setInt('login_attempts', _loginAttempts),
        _prefs.setString('last_login_attempt', _lastLoginAttempt!.toIso8601String()),
      ]);

      // Check if we should trigger security measures
      if (_loginAttempts >= AppConfig.maxLoginAttempts) {
        _triggerRateLimiting();
        _sendSuspiciousActivityAlert();
      }
    } else {
      // Reset attempts on successful login
      _loginAttempts = 0;
      await _prefs.setInt('login_attempts', 0);
    }
  }

  /// 🔹 Trigger rate limiting
  void _triggerRateLimiting() {
    // Implement rate limiting logic
    debugPrint('Rate limiting triggered due to multiple failed login attempts');
  }

  /// 🔹 Send suspicious activity alert
  void _sendSuspiciousActivityAlert() {
    // Send alert to backend
    if (_token != null) {
      http.post(
        Uri.parse("${AppConfig.baseUrl}/security-alert"),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'multiple_failed_logins',
          'attempts': _loginAttempts,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    }
  }

  /// 🔹 Login with MFA support
  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'deviceInfo': _getDeviceInfo(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        await _trackLoginAttempt(true);
        
        if (data['mfaRequired'] == true) {
          // MFA required - save session and wait for verification
          await _saveTokens(
            token: data['tempToken'] ?? '',
            mfaSessionId: data['mfaSessionId'],
            mfaRequired: true,
          );
        } else {
          // Regular login successful
          await _saveTokens(
            token: data['access_token'],
            refreshToken: data['refresh_token'],
            expiresIn: data['expires_in'] as int?,
          );
          await getUserProfile();
          _connectWebSocket();
        }
      } else if (response.statusCode == 401) {
        await _trackLoginAttempt(false);
        throw Exception("Invalid credentials");
      } else if (response.statusCode == 429) {
        throw Exception("Too many login attempts. Please try again later.");
      } else {
        await _trackLoginAttempt(false);
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Verify MFA code
  Future<void> verifyMfa(String code) async {
    if (_mfaSessionId == null) throw Exception("No MFA session active");

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/verify-mfa"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mfaSessionId': _mfaSessionId,
          'code': code,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        await _saveTokens(
          token: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresIn: data['expires_in'] as int?,
          mfaSessionId: null,
          mfaRequired: false,
        );
        
        await getUserProfile();
        _connectWebSocket();
      } else {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Resend MFA code
  Future<void> resendMfaCode() async {
    if (_mfaSessionId == null) throw Exception("No MFA session active");

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/resend-mfa"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mfaSessionId': _mfaSessionId}),
      );

      if (response.statusCode != 200) {
        throw Exception(_parseError(response.body));
      }
    } on SocketException {
      throw Exception("No internet connection");
    } catch (e) {
      throw Exception(_parseError(e.toString()));
    }
  }

  /// 🔹 Logout user from all devices
  Future<void> logout({bool fromAllDevices = false}) async {
    if (_token != null) {
      try {
        // Notify server about logout
        await http.post(
          Uri.parse("${AppConfig.baseUrl}/logout${fromAllDevices ? '-all' : ''}"),
          headers: {'Authorization': 'Bearer $_token'},
        );
      } catch (e) {
        debugPrint('Logout API call failed: $e');
      }
    }

    await _clearTokens();
    _disconnectWebSocket();
  }

  /// 🔹 Refresh token with rotation support
  Future<void> refreshAuthToken() async {
    if (_refreshToken == null) throw Exception("No refresh token available");

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/refresh-token"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'refresh_token': _refreshToken,
          'deviceInfo': _getDeviceInfo(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveTokens(
          token: data['access_token'],
          refreshToken: data['refresh_token'], // New refresh token (rotation)
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

  /// 🔹 Get device information for security tracking
  Map<String, dynamic> _getDeviceInfo() {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'model': Platform.localHostname,
      'appVersion': '1.0.0', // Replace with actual app version
    };
  }

  /// 🔹 Update app lifecycle status
  void updateAppLifecycleState(AppLifecycleState state) {
    if (!isAuthenticated) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _updateOnlineStatus(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        _updateOnlineStatus(false);
        break;
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

  /// 🔹 Dispose resources
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _disconnectWebSocket();
    super.dispose();
  }
}
