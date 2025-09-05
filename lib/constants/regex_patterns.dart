class RegexPatterns {
  // Email validation
  static final RegExp email = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
  );

  // Phone number validation (Indian +91 format or general)
  static final RegExp phone = RegExp(
    r'^(?:\+91|0)?[6-9]\d{9}$',
  );

  // Password validation
  // Minimum 8 characters, at least 1 uppercase, 1 lowercase, 1 number, 1 special char
  static final RegExp password = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  // Username validation
  // Letters, numbers, underscore, 3-20 characters
  static final RegExp username = RegExp(
    r'^[a-zA-Z0-9_]{3,20}$',
  );

  // URL validation
  static final RegExp url = RegExp(
    r'^(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w\-\.\?=&]*)*\/?$',
  );

  // OTP validation (4-6 digits)
  static final RegExp otp = RegExp(
    r'^\d{4,6}$',
  );
}
