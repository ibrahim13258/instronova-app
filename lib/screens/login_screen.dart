import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgot_password_screen.dart';

// State management class
class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;
  bool _autoLogin = false;
  String _loginMethod = 'email'; // 'email', 'phone', 'social'
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  int _failedAttempts = 0;
  bool _showCaptcha = false;
  String _captchaText = '';
  DateTime? _lastOtpRequestTime;
  int _otpRequestCount = 0;
  List<SavedAccount> _savedAccounts = [];
  String? _selectedAccountEmail;
  
  // Analytics events
  static const String LOGIN_ATTEMPT = 'login_attempt';
  static const String LOGIN_SUCCESS = 'login_success';
  static const String LOGIN_FAILED = 'login_failed';
  
  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  bool get obscurePassword => _obscurePassword;
  bool get autoLogin => _autoLogin;
  String get loginMethod => _loginMethod;
  String? get emailError => _emailError;
  String? get phoneError => _phoneError;
  String? get passwordError => _passwordError;
  int get failedAttempts => _failedAttempts;
  bool get showCaptcha => _showCaptcha;
  String get captchaText => _captchaText;
  List<SavedAccount> get savedAccounts => _savedAccounts;
  String? get selectedAccountEmail => _selectedAccountEmail;
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final SharedPreferences _prefs;
  
  LoginProvider(this._prefs);
  
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }
  
  void toggleAutoLogin() {
    _autoLogin = !_autoLogin;
    notifyListeners();
  }
  
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }
  
  void setLoginMethod(String method) {
    _loginMethod = method;
    notifyListeners();
  }
  
  void setEmailError(String? error) {
    _emailError = error;
    notifyListeners();
  }
  
  void setPhoneError(String? error) {
    _phoneError = error;
    notifyListeners();
  }
  
  void setPasswordError(String? error) {
    _passwordError = error;
    notifyListeners();
  }
  
  void incrementFailedAttempts() {
    _failedAttempts++;
    if (_failedAttempts >= 3) {
      _showCaptcha = true;
      _generateCaptcha();
    }
    notifyListeners();
  }
  
  void resetFailedAttempts() {
    _failedAttempts = 0;
    _showCaptcha = false;
    notifyListeners();
  }
  
  void _generateCaptcha() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    _captchaText = String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
    notifyListeners();
  }
  
  bool validateCaptcha(String input) {
    return input == _captchaText;
  }
  
  bool canRequestOtp() {
    if (_lastOtpRequestTime == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(_lastOtpRequestTime!);
    
    // Limit to 3 requests per minute
    if (_otpRequestCount >= 3 && difference.inSeconds < 60) {
      return false;
    }
    
    // Reset counter after 1 minute
    if (difference.inMinutes >= 1) {
      _otpRequestCount = 0;
    }
    
    return true;
  }
  
  void recordOtpRequest() {
    _lastOtpRequestTime = DateTime.now();
    _otpRequestCount++;
    notifyListeners();
  }
  
  Future<void> loadSavedAccounts() async {
    try {
      final accountsJson = _prefs.getStringList('saved_accounts') ?? [];
      _savedAccounts = accountsJson.map((json) => SavedAccount.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved accounts: $e');
    }
  }
  
  Future<void> saveAccount(String email, String password) async {
    try {
      // Encrypt and save password
      await _secureStorage.write(key: 'account_$email', value: password);
      
      // Update accounts list
      if (!_savedAccounts.any((account) => account.email == email)) {
        _savedAccounts.add(SavedAccount(email: email));
        await _prefs.setStringList('saved_accounts', 
            _savedAccounts.map((account) => account.toJson()).toList());
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving account: $e');
    }
  }
  
  Future<String?> getPasswordForAccount(String email) async {
    try {
      return await _secureStorage.read(key: 'account_$email');
    } catch (e) {
      debugPrint('Error retrieving password: $e');
      return null;
    }
  }
  
  Future<void> removeAccount(String email) async {
    try {
      await _secureStorage.delete(key: 'account_$email');
      _savedAccounts.removeWhere((account) => account.email == email);
      await _prefs.setStringList('saved_accounts', 
          _savedAccounts.map((account) => account.toJson()).toList());
      
      if (_selectedAccountEmail == email) {
        _selectedAccountEmail = null;
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing account: $e');
    }
  }
  
  void selectAccount(String email) {
    _selectedAccountEmail = email;
    notifyListeners();
  }
  
  void trackAnalyticsEvent(String event, {String method = '', bool success = false, int attemptCount = 0}) {
    // Integrate with your analytics service (Firebase, Mixpanel, etc.)
    debugPrint('Analytics: $event - Method: $method, Success: $success, Attempts: $attemptCount');
  }
}

class SavedAccount {
  final String email;
  final DateTime lastLogin;
  
  SavedAccount({required this.email, DateTime? lastLogin}) 
      : lastLogin = lastLogin ?? DateTime.now();
  
  factory SavedAccount.fromJson(String json) {
    final parts = json.split('|');
    return SavedAccount(
      email: parts[0],
      lastLogin: DateTime.tryParse(parts[1]) ?? DateTime.now(),
    );
  }
  
  String toJson() {
    return '$email|${lastLogin.toIso8601String()}';
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedAccount &&
          runtimeType == other.runtimeType &&
          email == other.email;
  
  @override
  int get hashCode => email.hashCode;
}

class LoginScreen extends StatefulWidget {
  final Map<String, dynamic>? deepLinkArgs;
  
  const LoginScreen({Key? key, this.deepLinkArgs}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  StreamSubscription? _deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _checkBiometricAvailability();
    _initializeProvider();
    _handleDeepLinking();
  }

  Future<void> _initializeProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = Provider.of<LoginProvider>(context, listen: false);
    
    await provider.loadSavedAccounts();
    _loadSavedCredentials();
  }

  void _handleDeepLinking() {
    final args = widget.deepLinkArgs;
    if (args != null) {
      // Handle automatic login or redirection based on deep link
      if (args['autoLogin'] == true && args['token'] != null) {
        _handleAutoLogin(args['token']);
      } else if (args['redirectTo'] != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, args['redirectTo']);
        });
      }
    }
  }

  void _handleAutoLogin(String token) {
    // Validate token and automatically log user in
    debugPrint('Auto-login with token: $token');
    // Implement token validation and automatic login logic
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = 
          await _localAuth.getAvailableBiometrics();
      
      setState(() {
        _isBiometricAvailable = canCheckBiometrics && availableBiometrics.isNotEmpty;
      });
    } catch (e) {
      debugPrint('Error checking biometrics: $e');
    }
  }

  Future<void> _loadSavedCredentials() async {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    final selectedEmail = provider.selectedAccountEmail;
    
    if (selectedEmail != null) {
      final password = await provider.getPasswordForAccount(selectedEmail);
      if (password != null) {
        _emailController.text = selectedEmail;
        _passwordController.text = password;
        
        // Auto-login if enabled
        if (provider.autoLogin) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loginWithEmail();
          });
        }
      }
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      
      if (didAuthenticate) {
        _navigateToHome();
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric authentication failed: ${e.message}')),
      );
    }
  }

  Future<void> _loginWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    
    final provider = Provider.of<LoginProvider>(context, listen: false);
    provider.setLoading(true);
    
    // Track login attempt
    provider.trackAnalyticsEvent(
      LoginProvider.LOGIN_ATTEMPT,
      method: 'email',
      attemptCount: provider.failedAttempts + 1,
    );

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate login failure for demonstration
      final shouldFail = _passwordController.text == 'fail';
      
      if (shouldFail) {
        provider.incrementFailedAttempts();
        provider.setEmailError('Invalid credentials');
        provider.setPasswordError('Invalid credentials');
        
        // Track failed login
        provider.trackAnalyticsEvent(
          LoginProvider.LOGIN_FAILED,
          method: 'email',
          attemptCount: provider.failedAttempts,
        );
        
        throw Exception('Login failed');
      }
      
      // Save credentials if remember me is enabled
      if (provider.rememberMe) {
        await provider.saveAccount(_emailController.text, _passwordController.text);
      }
      
      provider.resetFailedAttempts();
      
      // Track successful login
      provider.trackAnalyticsEvent(
        LoginProvider.LOGIN_SUCCESS,
        method: 'email',
        success: true,
        attemptCount: provider.failedAttempts + 1,
      );
      
      _navigateToHome();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      provider.setLoading(false);
    }
  }

  Future<void> _loginWithPhone() async {
    if (!_formKey.currentState!.validate()) return;
    
    final provider = Provider.of<LoginProvider>(context, listen: false);
    
    // Check rate limiting
    if (!provider.canRequestOtp()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait before requesting another OTP')),
      );
      return;
    }
    
    provider.setLoading(true);
    
    try {
      // Simulate OTP request
      await Future.delayed(const Duration(seconds: 1));
      
      provider.recordOtpRequest();
      
      // Navigate to OTP verification screen
      Navigator.pushNamed(context, '/otp-verification', arguments: {
        'phoneNumber': _phoneController.text,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP request failed: ${e.toString()}')),
      );
    } finally {
      provider.setLoading(false);
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
    );
  }

  void _navigateToSignup() {
    Navigator.pushNamed(context, '/signup');
  }

  Widget _buildAccountSwitcher() {
    final provider = Provider.of<LoginProvider>(context);
    
    if (provider.savedAccounts.isEmpty) return const SizedBox();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: provider.selectedAccountEmail,
        decoration: const InputDecoration(
          labelText: 'Select Account',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.account_circle),
        ),
        items: provider.savedAccounts.map((account) {
          return DropdownMenuItem<String>(
            value: account.email,
            child: Text(account.email),
          );
        }).toList(),
        onChanged: (email) {
          if (email != null) {
            provider.selectAccount(email);
            _loadSavedCredentials();
          }
        },
      ),
    );
  }

  Widget _buildCaptchaField() {
    final provider = Provider.of<LoginProvider>(context);
    
    if (!provider.showCaptcha) return const SizedBox();
    
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Please enter the CAPTCHA below:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            provider.captchaText,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _captchaController,
            decoration: const InputDecoration(
              labelText: 'CAPTCHA',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the CAPTCHA';
              }
              if (!provider.validateCaptcha(value)) {
                return 'Invalid CAPTCHA';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEmailLogin() {
    final provider = Provider.of<LoginProvider>(context);
    
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          _buildAccountSwitcher(),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email or Username',
              prefixIcon: const Icon(Icons.email),
              border: const OutlineInputBorder(),
              errorText: provider.emailError,
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              provider.setEmailError(null);
              if (value == null || value.isEmpty) {
                return 'Please enter your email or username';
              }
              if (!value.contains('@') && value.length < 3) {
                return 'Please enter a valid email or username';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  provider.obscurePassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  provider.togglePasswordVisibility();
                },
              ),
              border: const OutlineInputBorder(),
              errorText: provider.passwordError,
            ),
            obscureText: provider.obscurePassword,
            validator: (value) {
              provider.setPasswordError(null);
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: provider.rememberMe,
                onChanged: (value) {
                  provider.toggleRememberMe();
                },
              ),
              const Text('Remember Me'),
              const Spacer(),
              if (provider.savedAccounts.isNotEmpty) ...[
                Checkbox(
                  value: provider.autoLogin,
                  onChanged: (value) {
                    provider.toggleAutoLogin();
                  },
                ),
                const Text('Auto Login'),
                const Spacer(),
              ],
              TextButton(
                onPressed: _navigateToForgotPassword,
                child: const Text('Forgot Password?'),
              ),
            ],
          ),
          _buildCaptchaField(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : _loginWithEmail,
              child: provider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneLogin() {
    final provider = Provider.of<LoginProvider>(context);
    
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: const Icon(Icons.phone),
              border: const OutlineInputBorder(),
              errorText: provider.phoneError,
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              provider.setPhoneError(null);
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : _loginWithPhone,
              child: provider.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Send OTP'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                icon: Icons.g_translate,
                onPressed: () => _loginWithSocial('google'),
                color: Colors.red,
              ),
              _buildSocialButton(
                icon: Icons.facebook,
                onPressed: () => _loginWithSocial('facebook'),
                color: Colors.blue,
              ),
              _buildSocialButton(
                icon: Icons.apple,
                onPressed: () => _loginWithSocial('apple'),
                color: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isBiometricAvailable) ...[
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.fingerprint),
                label: const Text('Use Biometric Login'),
                onPressed: _authenticateWithBiometrics,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 24,
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Future<void> _loginWithSocial(String provider) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    
    // Track social login attempt
    loginProvider.trackAnalyticsEvent(
      LoginProvider.LOGIN_ATTEMPT,
      method: provider,
    );
    
    // Implement social login logic
    debugPrint('Logging in with $provider');
    // This would integrate with Firebase Auth or other auth services
  }

  @override
  Widget build(BuildContext context) {
    final currentMethod = context.watch<LoginProvider>().loginMethod;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // App Logo
                FlutterLogo(size: 80),
                const SizedBox(height: 24),
                const Text(
                  'Instagram Clone',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Login Method Selector
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'email',
                      icon: Icon(Icons.email),
                      label: Text('Email'),
                    ),
                    ButtonSegment<String>(
                      value: 'phone',
                      icon: Icon(Icons.phone),
                      label: Text('Phone'),
                    ),
                    ButtonSegment<String>(
                      value: 'social',
                      icon: Icon(Icons.group),
                      label: Text('Social'),
                    ),
                  ],
                  selected: {currentMethod},
                  onSelectionChanged: (Set<String> newSelection) {
                    context.read<LoginProvider>().setLoginMethod(newSelection.first);
                    _animationController.reset();
                    _animationController.forward();
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Dynamic Login Form
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: currentMethod == 'email'
                      ? _buildEmailLogin()
                      : currentMethod == 'phone'
                          ? _buildPhoneLogin()
                          : _buildSocialLogin(),
                ),
                
                const SizedBox(height: 32),
                
                // Sign up redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: _navigateToSignup,
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    _animationController.dispose();
    _deepLinkSubscription?.cancel();
    super.dispose();
  }
}
