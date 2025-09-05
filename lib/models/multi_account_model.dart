// models/multi_account_model.dart

class MultiAccountModel {
  final String userId;
  final String username;
  final String profilePictureUrl;
  final bool isActive; // Current active account
  final DateTime lastLogin;

  MultiAccountModel({
    required this.userId,
    required this.username,
    required this.profilePictureUrl,
    required this.isActive,
    required this.lastLogin,
  });

  // Factory method to create model from JSON
  factory MultiAccountModel.fromJson(Map<String, dynamic> json) {
    return MultiAccountModel(
      userId: json['userId'] as String,
      username: json['username'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String,
      isActive: json['isActive'] as bool,
      lastLogin: DateTime.parse(json['lastLogin'] as String),
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'profilePictureUrl': profilePictureUrl,
      'isActive': isActive,
      'lastLogin': lastLogin.toIso8601String(),
    };
  }

  // Copy with method for updating fields immutably
  MultiAccountModel copyWith({
    String? userId,
    String? username,
    String? profilePictureUrl,
    bool? isActive,
    DateTime? lastLogin,
  }) {
    return MultiAccountModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
