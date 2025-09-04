import 'dart:convert';

/// Ultra-advanced Instagram-level User model
class User {
  final String id;                   // Unique user ID
  final String name;                 // Full name
  final String username;             // Unique username
  final String email;                // Email address
  final String? bio;                 // User bio
  final String? gender;              // Gender
  final String? profileImageUrl;     // Profile picture URL
  final List<String> followers;      // List of user IDs who follow this user
  final List<String> following;      // List of user IDs this user follows
  final List<String> savedPostIds;   // List of saved post IDs
  final List<String> storyIds;       // List of active story IDs
  final bool isPrivate;              // Private account flag
  final bool isVerified;             // Verified badge flag
  final DateTime createdAt;          // Account creation timestamp

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.bio,
    this.gender,
    this.profileImageUrl,
    this.followers = const [],
    this.following = const [],
    this.savedPostIds = const [],
    this.storyIds = const [],
    this.isPrivate = false,
    this.isVerified = false,
    required this.createdAt,
  });

  /// Deserialize JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      bio: json['bio'],
      gender: json['gender'],
      profileImageUrl: json['profileImageUrl'],
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      savedPostIds: List<String>.from(json['savedPostIds'] ?? []),
      storyIds: List<String>.from(json['storyIds'] ?? []),
      isPrivate: json['isPrivate'] ?? false,
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Serialize User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'bio': bio,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
      'followers': followers,
      'following': following,
      'savedPostIds': savedPostIds,
      'storyIds': storyIds,
      'isPrivate': isPrivate,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
