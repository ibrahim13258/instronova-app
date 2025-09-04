import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _referralController = TextEditingController();

  int _currentStep = 0;
  bool _isPasswordVisible = false;
  bool _isTermsAccepted = false;
  XFile? _profileImage;
  final ImagePicker _picker = ImagePicker();

  bool _otpSent = false;
  bool _otpVerified = false;

  Future<void> _pickProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile;
      });
    }
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.trim().length < 10) {
      _showErrorSnackbar('Enter valid phone number');
      return;
    }
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.sendPhoneOtp(_phoneController.text.trim());
      setState(() {
        _otpSent = true;
      });
    } catch (error) {
      _showErrorSnackbar(authProvider.parseError(error));
    }
  }

  Future<void> _verifyOtp() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final success = await authProvider.verifyPhoneOtp(
        _phoneController.text.trim(),
        _otpController.text.trim(),
      );
      if (success) {
        setState(() {
          _otpVerified = true;
          _goToNextStep();
        });
      } else {
        _showErrorSnackbar('Invalid OTP');
      }
    } catch (error) {
      _showErrorSnackbar(authProvider.parseError(error));
    }
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate() || !_isTermsAccepted || !_otpVerified) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await authProvider.signup(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
        profileImage: _profileImage,
        referralCode: _referralController.text.trim(),
      );

      if (authProvider.authToken != null) {
        userProvider.setAuthToken(authProvider.authToken!);
        await userProvider.getUserProfile();
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackbar(authProvider.parseError(error));
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return _emailController.text.trim().isNotEmpty &&
            RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text.trim());
      case 2:
        return _usernameController.text.trim().isNotEmpty &&
            RegExp(r'^[a-z0-9]+$').hasMatch(_usernameController.text.trim());
      case 3:
        return _phoneController.text.trim().length >= 10 && _otpVerified;
      case 4:
        return _isTermsAccepted;
      default:
        return false;
    }
  }

  void _goToNextStep() {
    if (_validateCurrentStep()) {
      setState(() {
        if (_currentStep < 4) {
          _currentStep++;
        } else {
          _signup();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _goToNextStep,
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
          controlsBuilder: (context, details) {
            return Row(
              children: [
                if (_currentStep != 0)
                  TextButton(onPressed: details.onStepCancel, child: const Text('BACK')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_currentStep < 4 ? 'NEXT' : 'SIGN UP'),
                ),
              ],
            );
          },
          steps: [
            Step(
              title: const Text('Full Name'),
              content: TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name')),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Email & Password'),
              content: Column(
                children: [
                  TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Username'),
              content: Column(
                children: [
                  TextFormField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () => authProvider.checkUsernameAvailability(_usernameController.text), child: const Text('Check Availability')),
                ],
              ),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: const Text('Phone OTP'),
              content: Column(
                children: [
                  TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
                  const SizedBox(height: 8),
                  if (!_otpSent)
                    ElevatedButton(onPressed: _sendOtp, child: const Text('Send OTP')),
                  if (_otpSent && !_otpVerified) ...[
                    TextFormField(controller: _otpController, decoration: const InputDecoration(labelText: 'Enter OTP')),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: _verifyOtp, child: const Text('Verify OTP')),
                  ],
                  if (_otpVerified) const Text('Phone Verified', style: TextStyle(color: Colors.green)),
                ],
              ),
              isActive: _currentStep >= 3,
            ),
            Step(
              title: const Text('Profile & Terms'),
              content: Column(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: _profileImage != null ? FileImage(File(_profileImage!.path)) : null,
                      child: _profileImage == null ? const Icon(Icons.add_a_photo) : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(controller: _referralController, decoration: const InputDecoration(labelText: 'Referral Code (Optional)')),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(value: _isTermsAccepted, onChanged: (val) => setState(() => _isTermsAccepted = val ?? false)),
                      const Expanded(child: Text('I accept the Terms & Privacy Policy')),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep >= 4,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _referralController.dispose();
    super.dispose();
  }
}
