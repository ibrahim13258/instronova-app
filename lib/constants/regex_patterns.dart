class RegexPatterns {
  // Email validation
  static final RegExp email = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  // Phone number validation (10 digit, India)
  static final RegExp phone = RegExp(
    r'^[6-9]\d{9}$',
  );

  // Username validation: 3-15 chars, letters, numbers, underscores
  static final RegExp username = RegExp(
    r'^[a-zA-Z0-9_]{3,15}$',
  );

  // Password validation: Minimum 8 chars, at least 1 upper, 1 lower, 1 digit, 1 special char
  static final RegExp password = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  // URL validation
  static final RegExp url = RegExp(
    r'^(https?:\/\/)?([\w\-])+\.{1}([a-zA-Z]{2,63})([\/\w\-.?=&]*)*\/?$',
  );

  // Only letters validation
  static final RegExp onlyLetters = RegExp(
    r'^[a-zA-Z]+$',
  );

  // Only numbers validation
  static final RegExp onlyNumbers = RegExp(
    r'^\d+$',
  );
}
