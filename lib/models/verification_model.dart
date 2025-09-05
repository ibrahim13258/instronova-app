// models/verification_model.dart

class VerificationModel {
  final String userId;
  final bool isVerified;
  final DateTime verifiedAt;
  final String verifiedBy; // Admin or system
  final String verificationMethod; // e.g., email, phone, document

  VerificationModel({
    required this.userId,
    required this.isVerified,
    required this.verifiedAt,
    required this.verifiedBy,
    required this.verificationMethod,
  });

  // Factory method to create model from JSON
  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      userId: json['userId'] as String,
      isVerified: json['isVerified'] as bool,
      verifiedAt: DateTime.parse(json['verifiedAt'] as String),
      verifiedBy: json['verifiedBy'] as String,
      verificationMethod: json['verificationMethod'] as String,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'isVerified': isVerified,
      'verifiedAt': verifiedAt.toIso8601String(),
      'verifiedBy': verifiedBy,
      'verificationMethod': verificationMethod,
    };
  }

  // Copy with method for immutably updating fields
  VerificationModel copyWith({
    String? userId,
    bool? isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
    String? verificationMethod,
  }) {
    return VerificationModel(
      userId: userId ?? this.userId,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verificationMethod: verificationMethod ?? this.verificationMethod,
    );
  }
}
