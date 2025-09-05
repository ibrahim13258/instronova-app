// models/user_model.dart

class UserModel {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String profileImageUrl;
  final String bio;
  final bool isVerified;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final List<String> followers; // List of user IDs
  final List<String> following; // List of user IDs

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.profileImageUrl,
    required this.bio,
    required this.isVerified,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.followers,
    required this.following,
  });

  // Factory constructor for creating a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      bio: json['bio'] ?? '',
      isVerified: json['isVerified'] ?? false,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      postsCount: json['postsCount'] ?? 0,
      followers: List<String>.from(json['followers'] ?? []),
      following: List<String>.from(json['following'] ?? []),
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'isVerified': isVerified,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'followers': followers,
      'following': following,
    };
  }

  // Update follower and following count dynamically
  void followUser(String userId) {
    if (!following.contains(userId)) {
      following.add(userId);
    }
  }

  void addFollower(String userId) {
    if (!followers.contains(userId)) {
      followers.add(userId);
    }
  }

  void unfollowUser(String userId) {
    following.remove(userId);
  }

  void removeFollower(String userId) {
    followers.remove(userId);
  }
}
