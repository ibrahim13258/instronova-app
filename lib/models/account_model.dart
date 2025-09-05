// models/account_model.dart
import 'package:flutter/foundation.dart';

class AccountModel {
  final String id;
  final String username;
  final String email;
  final String profilePictureUrl;
  final String bio;
  final bool isPrivate;
  final bool isVerified;
  final DateTime createdAt;

  AccountModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.bio,
    required this.isPrivate,
    required this.isVerified,
    required this.createdAt,
  });

  // JSON serialization
  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      bio: json['bio'] ?? '',
      isPrivate: json['isPrivate'] ?? false,
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'isPrivate': isPrivate,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AccountModel(id: $id, username: $username, email: $email, isPrivate: $isPrivate, isVerified: $isVerified)';
  }
}
