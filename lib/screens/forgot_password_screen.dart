import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// State management class
class ForgotPasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _otpSent = false;
  String _recoveryMethod = 'email'; // 'email' or 'phone'
  int _cooldownSeconds = 0;
  
  bool get isLoading => _isLoading;
  bool get otpSent => _otpSent;
  String get recoveryMethod => _recoveryMethod;
  int get cooldownSeconds => _cooldownSeconds;
  
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void setOtpSent(bool value) {
    _otpSent = value;
    notifyListeners();
  }
  
  void setRecoveryMethod(String method) {
    _recoveryMethod = method;
    notifyListeners();
  }
  
  void startCooldown() {
    _cooldownSeconds = 60;
    notifyListeners();
    
    // Start countdown timer
    Future.delayed(const Duration(seconds: 1), () {
      if (_cooldownSeconds > 0) {
        _cooldownSeconds--;
        notifyListeners();
        startCooldown();
      }
    });
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Consumer<ForgotPasswordProvider>(
              builder: (context, provider, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Reset your password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        provider.otpSent
                            ? 'Enter the OTP sent to your ${provider.recoveryMethod} and set a new password'
                            : 'Select how you want to reset your password',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      if (!provider.otpSent) ...[
                        // Recovery method selector
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
                          ],
                          selected: {provider.recoveryMethod},
                          onSelectionChanged: (Set<String> newSelection) {
                            provider.setRecoveryMethod(newSelection.first);
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Email/Phone input
                        if (provider.recoveryMethod == 'email')
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          )
                        else
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
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
                        
                        // Request OTP button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: provider.cooldownSeconds > 0 || provider.isLoading
                                ? null
                                : () => _requestOtp(provider),
                            child: provider.cooldownSeconds > 0
                                ? Text('Resend in ${provider.cooldownSeconds}s')
                                : provider.isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('Send Reset Code'),
                          ),
                        ),
                      ] else ...[
                        // OTP and new password form
                        TextFormField(
                          controller: _otpController,
                          decoration: const InputDecoration(
                            labelText: 'Verification Code',
                            prefixIcon: Icon(Icons.sms),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the verification code';
                            }
                            if (value.length != 6) {
                              return 'Code must be 6 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Confirm New Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        
                        // Reset password button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: provider.isLoading
                                ? null
                                : () => _resetPassword(provider),
                            child: provider.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Reset Password'),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Back to login
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back to Login'),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestOtp(ForgotPasswordProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    
    provider.setLoading(true);
    
    try {
      // Simulate API call to send OTP
      await Future.delayed(const Duration(seconds: 2));
      
      // Start cooldown timer
      provider.startCooldown();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code sent successfully')),
      );
      
      // Show OTP input form
      provider.setOtpSent(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send code: ${e.toString()}')),
      );
    } finally {
      provider.setLoading(false);
    }
  }

  Future<void> _resetPassword(ForgotPasswordProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    
    provider.setLoading(true);
    
    try {
      // Simulate API call to reset password
      await Future.delayed(const Duration(seconds: 2));
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successfully')),
      );
      
      // Navigate back to login
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password: ${e.toString()}')),
      );
    } finally {
      provider.setLoading(false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
