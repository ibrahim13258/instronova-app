 import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _forgotPasswordEmailController = TextEditingController();
  final _otpController = TextEditingController();
  
  bool _isForgotPasswordLoading = false;
  bool _isOtpVerificationLoading = false;
  bool _isPasswordVisible = false;
  bool _otpExpired = false;
  int _otpTimer = 30;
  Timer? _timer;
  bool _canResendOtp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _forgotPasswordEmailController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authProvider = context.read<AuthProvider>();
    final userProvider = context.read<UserProvider>();

    try {
      await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      
      if (authProvider.authToken != null) {
        userProvider.setAuthToken(authProvider.authToken!);
        await userProvider.getUserProfile();
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackbar(authProvider.parseError(error.toString()));
      }
    }
  }

  void _startOtpTimer() {
    _otpExpired = false;
    _canResendOtp = false;
    _otpTimer = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_otpTimer > 0) {
        setState(() => _otpTimer--);
      } else {
        setState(() {
          _otpExpired = true;
          _canResendOtp = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    if (!_canResendOtp) return;
    
    setState(() {
      _canResendOtp = false;
      _isForgotPasswordLoading = true;
    });

    try {
      await _sendForgotPasswordOtp();
    } finally {
      if (mounted) {
        setState(() => _isForgotPasswordLoading = false);
      }
    }
  }

  final _forgotPasswordFormKey = GlobalKey<FormState>();
  Future<void> _sendForgotPasswordOtp() async {
    if (!_forgotPasswordFormKey.currentState!.validate()) return;
    
    final email = _forgotPasswordEmailController.text.trim();
    final authProvider = context.read<AuthProvider>();
    
    setState(() => _isForgotPasswordLoading = true);
    
    try {
      await authProvider.forgotPassword(email);
      if (mounted) {
        Navigator.pop(context);
        _startOtpTimer();
        _showOtpDialog(email);
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackbar(authProvider.parseError(error.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isForgotPasswordLoading = false);
      }
    }
  }

  Future<void> _verifyOtp(String email) async {
    if (_otpExpired) {
      _showErrorSnackbar('OTP has expired. Please request a new one.');
      return;
    }

    final otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length != 6) {
      _showErrorSnackbar('Please enter a valid 6-digit OTP');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    
    setState(() => _isOtpVerificationLoading = true);
    
    try {
      await authProvider.verifyOtp(email, otp);
      if (mounted) {
        Navigator.pop(context);
        _showResetPasswordDialog(email, otp);
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackbar(authProvider.parseError(error.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isOtpVerificationLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Forgot Password'),
        content: Form(
          key: _forgotPasswordFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your email to receive OTP'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _forgotPasswordEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _isForgotPasswordLoading ? null : _sendForgotPasswordOtp,
            child: _isForgotPasswordLoading
                ? const CircularProgressIndicator()
                : const Text('Send OTP'),
          ),
        ],
      ),
    );
  }

  final _otpFormKey = GlobalKey<FormState>();
  void _showOtpDialog(String email) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter OTP'),
        content: Form(
          key: _otpFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('OTP sent to $email (expires in $_otpTimer seconds)'),
              if (_otpExpired)
                Text(
                  'OTP expired!',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otpController,
                decoration: const InputDecoration(
                  labelText: '6-digit OTP',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP';
                  }
                  if (value.length != 6) {
                    return 'OTP must be 6 digits';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _canResendOtp && !_isForgotPasswordLoading
                ? _resendOtp
                : null,
            child: _isForgotPasswordLoading
                ? const CircularProgressIndicator()
                : const Text('Resend OTP'),
          ),
          TextButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _otpExpired
                ? null
                : _isOtpVerificationLoading
                    ? null
                    : () {
                        if (_otpFormKey.currentState!.validate()) {
                          _verifyOtp(email);
                        }
                      },
            child: _isOtpVerificationLoading
                ? const CircularProgressIndicator()
                : const Text('Verify'),
          ),
        ],
      ),
    );
  }

  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Weak';
    if (!RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password)) {
      return 'Medium';
    }
    return 'Strong';
  }

  void _showResetPasswordDialog(String email, String otp) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => _ResetPasswordDialog(
        email: email,
        otp: otp,
        onSuccess: () {
          if (mounted) {
            Navigator.popUntil(context, (route) => route.isFirst);
            _showSuccessSnackbar('Password reset successful! Please login');
          }
        },
        onError: _showErrorSnackbar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Text(
                    'Instanova',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cursive',
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Email/Username Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email or Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email or username';
                      }
                      if (value.contains('@')) {
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                      } else {
                        if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value)) {
                          return 'Only lowercase letters, numbers and _ allowed';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible 
                            ? Icons.visibility 
                            : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showForgotPasswordDialog,
                      child: const Text('Forgot Password?'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Signup Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetPasswordDialog extends StatefulWidget {
  final String email;
  final String otp;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const _ResetPasswordDialog({
    required this.email,
    required this.otp,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<_ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<_ResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isResettingPassword = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _passwordStrength = '';

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Weak';
    if (!RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password)) {
      return 'Medium';
    }
    return 'Strong';
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isResettingPassword = true);
    
    try {
      await context.read<AuthProvider>().resetPassword(
        widget.email,
        widget.otp,
        _newPasswordController.text,
      );
      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess();
      }
    } catch (error) {
      if (mounted) {
        widget.onError(context.read<AuthProvider>().parseError(error.toString()));
      }
    } finally {
      if (mounted) {
        setState(() => _isResettingPassword = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _newPasswordController,
              obscureText: !_isNewPasswordVisible,
              onChanged: (value) {
                setState(() {
                  _passwordStrength = _getPasswordStrength(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'New Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordVisible 
                      ? Icons.visibility 
                      : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            if (_passwordStrength.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Text(
                      'Strength: ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      _passwordStrength,
                      style: TextStyle(
                        color: _passwordStrength == 'Weak'
                            ? Colors.red
                            : _passwordStrength == 'Medium'
                                ? Colors.orange
                                : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible 
                      ? Icons.visibility 
                      : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isResettingPassword ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isResettingPassword ? null : _resetPassword,
          child: _isResettingPassword
              ? const CircularProgressIndicator()
              : const Text('Reset Password'),
        ),
      ],
    );
  }
}
