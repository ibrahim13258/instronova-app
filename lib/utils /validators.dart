class Validators {
  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    // Simple email regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    // Optional: Add complexity checks (uppercase, number, special char)
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{6,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain uppercase, number, and special character';
    }
    return null;
  }

  // Phone Number Validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    // Simple phone regex (10 digits)
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }
}
