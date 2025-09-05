// models/security_model.dart

class SecurityModel {
  // Account security options
  bool twoFactorAuth;       // Two-factor authentication on/off
  bool loginAlerts;         // Notify on new login
  bool passwordChangeRequired; // Force password change
  List<String> authorizedDevices; // List of authorized device IDs

  SecurityModel({
    this.twoFactorAuth = false,
    this.loginAlerts = true,
    this.passwordChangeRequired = false,
    List<String>? authorizedDevices,
  }) : authorizedDevices = authorizedDevices ?? [];

  // From JSON (API response)
  factory SecurityModel.fromJson(Map<String, dynamic> json) {
    return SecurityModel(
      twoFactorAuth: json['twoFactorAuth'] ?? false,
      loginAlerts: json['loginAlerts'] ?? true,
      passwordChangeRequired: json['passwordChangeRequired'] ?? false,
      authorizedDevices: List<String>.from(json['authorizedDevices'] ?? []),
    );
  }

  // To JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'twoFactorAuth': twoFactorAuth,
      'loginAlerts': loginAlerts,
      'passwordChangeRequired': passwordChangeRequired,
      'authorizedDevices': authorizedDevices,
    };
  }
}
