import 'regex_patterns.dart';

class ValidationHelper {
  /// Check if email is valid
  static bool isValidEmail(String email) {
    final regex = RegExp(RegexPatterns.emailPattern);
    return regex.hasMatch(email);
  }

  /// Check if phone number is valid
  /// Optional country code handling
  static bool isValidPhone(String phone, {int minLength = 10, int maxLength = 15}) {
    final regex = RegExp(RegexPatterns.phonePattern);
    return regex.hasMatch(phone) &&
        phone.length >= minLength &&
        phone.length <= maxLength;
  }

  /// Check if password is strong
  /// At least 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 special char
  static bool isValidPassword(String password) {
    final regex = RegExp(RegexPatterns.passwordPattern);
    return regex.hasMatch(password);
  }

  /// Confirm password match
  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /// Check if input is not empty
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Check if username is valid (alphanumeric + underscore, 3-20 chars)
  static bool isValidUsername(String username) {
    final regex = RegExp(RegexPatterns.usernamePattern);
    return regex.hasMatch(username);
  }
}
